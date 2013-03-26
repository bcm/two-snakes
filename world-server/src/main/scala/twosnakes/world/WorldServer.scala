package twosnakes.world

import akka.actor._
import java.util.Date
import org.mashupbots.socko.events._
import org.mashupbots.socko.routes._
import org.mashupbots.socko.infrastructure.Logger
import org.mashupbots.socko.webserver._
import twosnakes.world.command.Command
import twosnakes.world.message.Message
import twosnakes.world.session._

object WorldServer extends Logger {
  val actorSystem = ActorSystem("WorldActorSystem")
  val sessionManager = actorSystem.actorOf(Props[SessionManager], "SessionManager")
  val webServerConfig = WorldServerConfig(actorSystem)

  // XXX: when the client drops the connection, let the session stick around for a few minutes but then idle it out
  // if the client doesn't try to reconnect

  val routes = Routes({
    case WebSocketHandshake(handshake) => handshake match {
      case Path("/websocket/") =>
        handshake.authorize(onComplete = Some((event: WebSocketHandshakeEvent) =>
          sessionManager ! new SessionRegistration(event.channel)
       ))
    }
    case WebSocketFrame(event) =>
      sessionManager ! SessionCommand(Command(event.readText), event.channel)
  })

  def main(args: Array[String]) = {
    // XXX: set up database connection pool

    // XXX: allow port to be provided as command line options

    val webServer = new WebServer(webServerConfig, routes, actorSystem)
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
