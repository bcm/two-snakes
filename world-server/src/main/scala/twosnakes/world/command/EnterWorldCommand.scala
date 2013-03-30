package twosnakes.world.command

import akka.actor._
import spray.json._
import twosnakes.world.Error
import twosnakes.world.event._
import twosnakes.world.repository.character._
import twosnakes.world.session._

case class EnterWorldCommand(characterId: Long) extends Command {
  def createProcessor = new EnterWorldCommandProcessor()
}

class EnterWorldCommandProcessor extends CommandProcessor {
  var currentSession: Session = null

  def receive = {
    case Tuple2(command: EnterWorldCommand, session: Session) =>
      session match {
        case cs: CharacterSession =>
          log.debug("Re-entering world as %s (%d)".format(cs.character.name, cs.character.id))
          context.stop(self)
        case _ =>
          currentSession = session
          context.actorOf(Props[CharacterRepository]) ! FindCharacter(command.characterId)
      }
    case CharacterFound(character) =>
      log.debug("Entering world as %s (%d)".format(character.name, character.id))
      sessionManager ! SessionAttachCharacter(currentSession, character)
      sessionManager ! SessionSendAll(new WorldEnteredEvent(character))
      context.stop(self)
    case CharacterNotFound(id) =>
      log.error("Could not enter world as character %d: character not found".format(id))
      sessionManager !
        SessionSend(currentSession, new SystemErrorEvent(Error.CHARACTER_NOT_FOUND))
      context.stop(self)
  }
}

object EnterWorldCommandJsonProtocol extends DefaultJsonProtocol {
  implicit object EnterWorldCommandJsonFormat extends BaseCommandJsonFormat[EnterWorldCommand] {
    def read(value: JsValue) = {
      value.asJsObject.getFields("characterId") match {
        case Seq(JsNumber(characterId)) => new EnterWorldCommand(characterId.toLong)
        case _ => throw new DeserializationException("EnterWorldCommand expected")
      }
    }
  }
}
