package twosnakes.world

import akka.actor.Actor
import akka.actor.ActorSystem
import akka.actor.Props
import akka.event.Logging
import java.util.Date
import org.mashupbots.socko.events.HttpRequestEvent
import org.mashupbots.socko.events.WebSocketFrameEvent
import org.mashupbots.socko.routes._
import org.mashupbots.socko.infrastructure.Logger
import org.mashupbots.socko.webserver.WebServer
import org.mashupbots.socko.webserver.WebServerConfig
import scala.util.parsing.json.JSON

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

class WebSocketHandler extends Actor {
  val log = Logging(context.system, this)

  def receive = {
    case event: WebSocketFrameEvent =>
      val parsed = JSON.parseFull(event.readText)
      event.writeText(event.readText)
      context.stop(self)
    case _ => {
      log.warning("received unknown message")
      context.stop(self)
    }
  }
}
