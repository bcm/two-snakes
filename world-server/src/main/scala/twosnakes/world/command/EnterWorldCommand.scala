package twosnakes.world.command

import akka.actor._
import spray.json._
import twosnakes.world.message.ChatMessage
import twosnakes.world.repository.CharacterRepository
import twosnakes.world.session._

case class EnterWorldCommand(characterId: Long) extends Command {
  def createProcessor = new EnterWorldCommandProcessor()
}

class EnterWorldCommandProcessor extends CommandProcessor {
  def receive = {
    case Tuple2(command: EnterWorldCommand, session: Session) =>
      session match {
        case cs: CharacterSession =>
          log.debug("Re-entering world as %s (%d)".format(cs.character.name, cs.character.id))
        case _ =>
          // XXX: if the socket dropped and had to be re-connected, then we may have an existing session for this
          // character whose state can be assumed (and old socket dropped).
          CharacterRepository.findCharacter(command.characterId) match {
            case Some(character) =>
              log.debug("Entering world as %s (%d)".format(character.name, character.id))
              context.actorFor("/user/SessionManager") ! SessionAttachCharacter(session, character)
              session.send(new ChatMessage("Welcome to the world of Two Snakes!"))
            case _ =>
              log.error("Could not enter world as character %d: character not found".format(command.characterId))
              session.send(new ChatMessage("Something has gone terribly wrong - character does not exist"))
          }
      }
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
