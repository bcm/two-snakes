package twosnakes.world

import akka.actor._
import akka.routing.SmallestMailboxRouter
import java.util.Date
import org.mashupbots.socko.events._
import org.mashupbots.socko.routes._
import org.mashupbots.socko.infrastructure.Logger
import org.mashupbots.socko.webserver._
import twosnakes.world.command.Command
import twosnakes.world.repository.db.DbSupervisor
import twosnakes.world.session._

object WorldServer extends Logger {
  val worldActorSystem = ActorSystem("WorldActorSystem")
  val sessionManager = worldActorSystem.actorOf(Props[SessionManager], "SessionManager")
  val webServerConfig = WorldServerConfig(worldActorSystem)

  val dbActorSystem = ActorSystem("DbActorSystem")
  // note that the external config overrides this number of routees
  val dbSupervisor = dbActorSystem.actorOf(Props[DbSupervisor].withRouter(SmallestMailboxRouter(2)), "DbSupervisor")

  // XXX: when the client drops the connection, let the session stick around for a few minutes but then idle it out
  // if the client doesn't try to reconnect

  val routes = Routes({
    case WebSocketHandshake(handshake) => handshake match {
      case Path("/websocket/") =>
        handshake.authorize(onComplete = Some((event: WebSocketHandshakeEvent) =>
          sessionManager ! SessionRegistration(event.channel)
       ))
    }
    case WebSocketFrame(event) =>
      sessionManager ! SessionCommand(Command(event.readText), event.channel)
  })

  def main(args: Array[String]) = {
    // XXX: allow port to be provided as command line options

    val webServer = new WebServer(webServerConfig, routes, worldActorSystem)
    webServer.start()

    Runtime.getRuntime.addShutdownHook(new Thread {
      override def run { webServer.stop() }
    })
  }
}

object WorldServerConfig extends ExtensionId[WebServerConfig] with ExtensionIdProvider {
  override def lookup = WorldServerConfig
  override def createExtension(system: ExtendedActorSystem) =
    new WebServerConfig(system.settings.config, "world-server")
}
