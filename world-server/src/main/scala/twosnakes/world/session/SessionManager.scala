package twosnakes.world.session

import akka.actor._
import java.nio.channels.ClosedChannelException
import org.jboss.netty.channel.Channel
import org.jboss.netty.handler.codec.http.websocketx.TextWebSocketFrame
import scala.collection.mutable.Map
import twosnakes.world.command.Command
import twosnakes.world.event._
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
      addSession(new Session(), channel)
    case SessionExecuteCommand(command, channel) =>
      val commandArgs = sessionsByChannel.get(channel) match {
        case Some(session: CharacterSession) => Tuple2(command, session)
        case Some(session: Session) => Tuple2(command, session)
        case None => addSession(new Session(), channel)
      }
      context.actorOf(Props(command.createProcessor)) ! commandArgs
    case SessionAttachCharacter(session, character) =>
      attachCharacterToSession(session, character) match {
        case Some(newSession) =>
          sender ! SessionCharacterAttached(newSession)
        case None =>
          // don't send the event
      }
    case SessionSend(session, event) =>
      val text = event.serialize
      channelsBySession.get(session) match {
        case Some(channel) => sendText(session, channel, text)
        case None => log.warning("No channel for session - client must have disconnected")
      }
    case SessionSendAll(event) =>
      val text = event.serialize
      for (session <- sessionsByCharacterId.values) {
        channelsBySession.get(session) match {
          case Some(channel) => sendText(session, channel, text)
          case None => log.warning("No channel for session - client must have disconnected")
        }
      }
    case SessionEnd(session) =>
      detachCharacterFromSession(session)
      removeSession(session)
      self ! SessionSendAll(WorldExitedEvent(session.character, session.location))
  }

  def addSession(session: Session, channel: Channel) {
    channelsBySession += session -> channel
    sessionsByChannel += channel -> session
  }

  def attachCharacterToSession(session: Session, character: Character): Option[CharacterSession] = {
    sessionsByCharacterId.get(character.id) match {
      case Some(oldSession) =>
        detachCharacterFromSession(oldSession)
        removeSession(oldSession)
        channelsBySession.get(session) match {
          case Some(channel) =>
            log.debug("Re-using existing session for %s".format(character))
            val newSession = replaceSessionWithCharacterSession(session, channel, character)
            newSession.location = oldSession.location
            // return None because we don't want everybody being updated when an existing session gets a new channel
            None
          case None =>
            log.warning("Can't re-use the existing session for %s because the channel is gone".format(character))
            None
        }
      case None =>
        channelsBySession.get(session) match {
          case Some(channel) =>
            Some(replaceSessionWithCharacterSession(session, channel, character))
          case None =>
            log.warning("Can't attach %s to the session because the channel is gone".format(character))
            None
        }
    }
  }

  def replaceSessionWithCharacterSession(session: Session, channel: Channel, character: Character): CharacterSession = {
    val characterSession = new CharacterSession(character)
    removeSession(session)
    addSession(characterSession, channel)
    sessionsByCharacterId += character.id -> characterSession
    characterSession
  }

  def sendText(session: Session, channel: Channel, text: String) {
    try {
      channel.write(new TextWebSocketFrame(text))
    } catch {
      case e: ClosedChannelException => removeSession(session)
    }
  }

  def detachCharacterFromSession(session: CharacterSession) {
    sessionsByCharacterId -= session.character.id
  }

  def removeSession(session: Session) {
    channelsBySession.get(session) match {
      case Some(channel) => sessionsByChannel -= channel
      case None => // channel's already gone
    }
    channelsBySession -= session
  }
}

case class SessionRegistration(channel: Channel)
case class SessionExecuteCommand(command: Command, channel: Channel)
case class SessionAttachCharacter(session: Session, character: Character)
case class SessionCharacterAttached(session: CharacterSession)
case class SessionSend(session: Session, event: Event)
case class SessionSendAll(event: Event)
case class SessionEnd(session: CharacterSession)
