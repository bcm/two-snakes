package twosnakes.world.session

import akka.actor._
import java.nio.channels.ClosedChannelException
import org.jboss.netty.channel.Channel
import org.jboss.netty.handler.codec.http.websocketx.TextWebSocketFrame
import scala.collection.mutable.Map
import twosnakes.world.command.Command
import twosnakes.world.event.Event
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
      initializeSession(new Session(), channel)
    case SessionCommand(command, channel) =>
      val session = sessionsByChannel.get(channel) match {
        case Some(s) => s
        case None => initializeSession(new Session(), channel)
      }
      context.actorOf(Props(command.createProcessor)) ! Tuple2(command, session)
    case SessionAttachCharacter(session, character) =>
      channelsBySession.get(session) match {
        case Some(channel) => {
          val characterSession = new CharacterSession(character)
          initializeCharacterSession(characterSession, channel)
          sender ! SessionCharacterAttached(characterSession)
        }
        case None => log.warning("No channel for session %s - client must have disconnected")
      }
    case SessionSend(session, event) =>
      val text = event.serialize
      channelsBySession.get(session) match {
        case Some(channel) => sendText(session, channel, text)
        case None => log.warning("No channel for session %s - client must have disconnected")
      }
    case SessionSendAll(event) =>
      val text = event.serialize
      for (session <- sessionsByCharacterId.values) {
        channelsBySession.get(session) match {
          case Some(channel) => sendText(session, channel, text)
          case None => log.warning("No channel for session %s - client must have disconnected")
        }
      }
  }

  def sendText(session: Session, channel: Channel, text: String) = try {
    channel.write(new TextWebSocketFrame(text))
  } catch {
    case e: ClosedChannelException =>
      // remove the channel and let a new one be initialized on the next registration for this session
      channelsBySession.get(session) match {
        case Some(channel) => {
          channelsBySession -= session
          sessionsByChannel -= channel
        }
        case None => // channel's already gone
      }
  }

  def initializeSession(session: Session, channel: Channel) = {
    channelsBySession += session -> channel
    sessionsByChannel += channel -> session
  }

  def initializeCharacterSession(session: CharacterSession, channel: Channel) = {
    initializeSession(session.asInstanceOf[Session], channel)
    sessionsByCharacterId += session.character.id -> session
  }
}

case class SessionRegistration(channel: Channel)
case class SessionCommand(command: Command, channel: Channel)
case class SessionAttachCharacter(session: Session, character: Character)
case class SessionCharacterAttached(session: CharacterSession)
case class SessionSend(session: Session, event: Event)
case class SessionSendAll(event: Event)

