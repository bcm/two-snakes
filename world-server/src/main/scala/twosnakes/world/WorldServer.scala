package twosnakes.world

import akka.actor._
import java.util.Date
import org.mashupbots.socko.events._
import org.mashupbots.socko.routes._
import org.mashupbots.socko.infrastructure.Logger
import org.mashupbots.socko.webserver._
import twosnakes.world.command.Command
import twosnakes.world.message.Message

object WorldServer extends Logger {
  val actorSystem = ActorSystem("WorldActorSystem")
  val config = WorldServerConfig(actorSystem)

  val routes = Routes({
    case WebSocketHandshake(handshake) => handshake match {
      case Path("/websocket/") =>
        handshake.authorize()
        // XXX: onSuccess, register this client with the client manager
        // see https://github.com/mashupbots/socko/blob/master/socko-webserver/src/main/scala/org/mashupbots/socko/handlers/WebSocketBroadcaster.scala
    }
    case WebSocketFrame(frame) =>
      val command = Command(frame.readText)
      actorSystem.actorOf(Props(command.createProcessor)) ! command
  })

  def main(args: Array[String]) = {
    // XXX: set up database connection pool
    // XXX: allow port to be provided as command line options

    val webServer = new WebServer(config, routes, actorSystem)
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
