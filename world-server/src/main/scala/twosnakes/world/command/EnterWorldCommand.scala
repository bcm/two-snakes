package twosnakes.world.command

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spray.json._
import twosnakes.world.message.ChatMessage
import twosnakes.world.repository.CharacterRepository

class EnterWorldCommand(val characterId: Long) extends Command {
  val log = LoggerFactory.getLogger(classOf[EnterWorldCommand])

  def process = {
    CharacterRepository.findCharacter(characterId) match {
      case Some(character) =>
        log.warn("Character %d: %s".format(characterId, character))
        // XXX: figure out where in the world the character is and remember it
        // XXX: if the character is already in the world, then just pick the session back up where it was
        // XXX: externalize string
        Seq(new ChatMessage("Welcome to the world of Two Snakes!"))
      case _ =>
        log.error("Character %d not found".format(characterId))
        Seq(new ChatMessage("Something has gone horribly wrong"))
    }
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
