package twosnakes.world

import akka.actor.Actor
import akka.actor.ActorLogging
import akka.actor.ActorSystem
import akka.actor.Props
import java.util.Date
import org.mashupbots.socko.events.HttpRequestEvent
import org.mashupbots.socko.events.WebSocketFrameEvent
import org.mashupbots.socko.routes._
import org.mashupbots.socko.infrastructure.Logger
import org.mashupbots.socko.webserver.WebServer
import org.mashupbots.socko.webserver.WebServerConfig

object WorldServer extends Logger {
  val actorSystem = ActorSystem("WorldActorSystem")

  val routes = Routes({
    case WebSocketHandshake(handshake) => handshake match {
      case Path("/websocket/") =>
        handshake.authorize()
    }
    case WebSocketFrame(frame) =>
      actorSystem.actorOf(Props[WebSocketHandler]) ! frame
  })

  def main(args: Array[String]) = {
    val webServer = new WebServer(WebServerConfig(), routes, actorSystem)
    webServer.start()

    Runtime.getRuntime.addShutdownHook(new Thread {
      override def run { webServer.stop() }
    })
  }
}

class WebSocketHandler extends Actor with ActorLogging {
  def receive = {
    case event: WebSocketFrameEvent =>
      for (message <- Command(event.readText).process)
        event.writeText(message.serialize)
      context.stop(self)
  }
}
