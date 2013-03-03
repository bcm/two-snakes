package twosnakes.world

import akka.actor.Actor
import akka.actor.ActorSystem
import akka.actor.Props
import java.util.Date
import org.mashupbots.socko.routes._
import org.mashupbots.socko.events.HttpRequestEvent
import org.mashupbots.socko.infrastructure.Logger
import org.mashupbots.socko.webserver.WebServer
import org.mashupbots.socko.webserver.WebServerConfig

object WorldServer extends Logger {
  val actorSystem = ActorSystem("WorldActorSystem")

  val routes = Routes({
    case GET(request) =>
      actorSystem.actorOf(Props[HelloHandler]) ! request
  })

  def main(args: Array[String]) = {
    val webServer = new WebServer(WebServerConfig(), routes, actorSystem)
    webServer.start()

    Runtime.getRuntime.addShutdownHook(new Thread {
      override def run { webServer.stop() }
    })
  }
}

class HelloHandler extends Actor {
  def receive = {
    case event: HttpRequestEvent =>
      event.response.write("World still spinning at " + new Date().toString)
      context.stop(self)
  }
}
