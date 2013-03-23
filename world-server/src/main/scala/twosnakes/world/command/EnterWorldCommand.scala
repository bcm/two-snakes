package twosnakes.world.command

import spray.json._
import twosnakes.world.message.ChatMessage

class EnterWorldCommand(characterId: Long) extends Command {
  def process = {
    // XXX: look up the character, figure out where in the world it is and remember it
    Seq(ChatMessage("Welcome to the world of Two Snakes!"))
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
