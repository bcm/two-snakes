package twosnakes.world

import akka.actor._
import org.jboss.netty.channel.Channel
import org.mashupbots.socko.events.WebSocketHandshakeEvent
import scala.collection.mutable.Map

// Inspired by
// https://github.com/mashupbots/socko/blob/master/socko-webserver/src/main/scala/org/mashupbots/socko/handlers/WebSocketBroadcaster.scala

class SessionManager extends Actor with ActorLogging {
  private val sessions = Map[Session, Channel]()
  private val channels = Map[Channel, Session]()

  def receive = {
    case SessionRegistration(context) =>
      val session = Session()
      sessions += session -> context.channel
      channels += context.channel -> session
   }
}

case class SessionRegistration(context: WebSocketHandshakeEvent)

case class Session
