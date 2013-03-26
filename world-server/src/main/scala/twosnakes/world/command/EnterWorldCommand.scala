package twosnakes.world.command

import akka.actor._
import spray.json._
import twosnakes.world.message.ChatMessage
import twosnakes.world.repository.CharacterRepository

case class EnterWorldCommand(characterId: Long) extends Command {
  def createProcessor = new EnterWorldCommandProcessor()
}

class EnterWorldCommandProcessor extends CommandProcessor {
  def receive = {
    case command: EnterWorldCommand =>
      // XXX: if there's an existing session for this character then use it. otherwise, begin a new session
      // XXX: model session as a specifically-named actor which maintains the state of the player's socket, the
      // character and its location in the world
      // see http://doc.akka.io/docs/akka/2.1.2/general/addressing.html
      CharacterRepository.findCharacter(command.characterId) match {
        case Some(character) =>
          log.debug("Establishing session for %s (%d)".format(character.name, character.id))
          // XXX: send (new ChatMessage("Welcome to the world of Two Snakes!") to the client
          context.stop(self)
        case _ =>
          log.error("Could not establish session for haracter %d: Character not found".format(command.characterId))
          // XXX: send new ChatMessage("Something has gone horribly wrong")) to the client
          context.stop(self)
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
