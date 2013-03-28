package twosnakes.world.session

import akka.actor._
import org.jboss.netty.channel.Channel
import scala.collection.mutable.Map
import twosnakes.world.command.Command
import twosnakes.world.message.Message
import twosnakes.world.model.Character

// Inspired by
// https://github.com/mashupbots/socko/blob/master/socko-webserver/src/main/scala/org/mashupbots/socko/handlers/WebSocketBroadcaster.scala

class SessionManager extends Actor with ActorLogging {
  private val channelsBySession = Map[Session, Channel]()
  private val sessionsByChannel = Map[Channel, Session]()
  private val sessionsByCharacterId = Map[Long, CharacterSession]()

  // XXX: idle sessions out after ~15 minutes

  def receive = {
    case SessionRegistration(channel) =>
      initializeSession(new Session(channel))
    case SessionCommand(command, channel) =>
      val session = sessionsByChannel.get(channel) match {
        case Some(s) => s
        case None => initializeSession(new Session(channel))
      }
      context.actorOf(Props(command.createProcessor)) ! Tuple2(command, session)
    case SessionAttachCharacter(session, character) =>
      initializeSession(new CharacterSession(session.channel, character))
    case SessionSend(session, message) =>
      session.send(message.serialize)
   }

  def initializeSession(session: Session): Session = {
    channelsBySession += session -> session.channel
    sessionsByChannel += session.channel -> session
    session
  }

  def initializeSession(session: CharacterSession): CharacterSession = {
    sessionsByCharacterId += session.character.id -> session
    initializeSession(session.asInstanceOf[Session]).asInstanceOf[CharacterSession]
  }
}

case class SessionRegistration(channel: Channel)
case class SessionCommand(command: Command, channel: Channel)
case class SessionAttachCharacter(session: Session, character: Character)
case class SessionSend(session: Session, message: Message)
