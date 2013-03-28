package twosnakes.world.command

import akka.actor._
import spray.json._
import twosnakes.world.message.ChatMessage
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
          // XXX: if the socket dropped and had to be re-connected, then we may have an existing session for this
          // character whose state can be assumed (and old socket dropped).
          context.actorOf(Props[CharacterRepository]) ! FindCharacter(command.characterId)
      }
    case CharacterFound(character) =>
      log.debug("Entering world as %s (%d)".format(character.name, character.id))
      context.actorFor("/user/SessionManager") ! SessionAttachCharacter(currentSession, character)
      // XXX: do session sends through messaging
      currentSession.send(new ChatMessage("Welcome to the world of Two Snakes!"))
      context.stop(self)
    case CharacterNotFound(id) =>
      log.error("Could not enter world as character %d: character not found".format(id))
      currentSession.send(new ChatMessage("Something has gone terribly wrong - character does not exist"))
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
