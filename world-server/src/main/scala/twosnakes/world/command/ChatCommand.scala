package twosnakes.world.command

import spray.json._
import twosnakes.world.message.ChatMessage

// XXX: refine into different types of chat commands - say, msg, emote
class ChatCommand(text: String) extends Command {
  def process = {
    Seq(ChatMessage(text))
  }
}

object ChatCommandJsonProtocol extends DefaultJsonProtocol {
  implicit object ChatCommandJsonFormat extends BaseCommandJsonFormat[ChatCommand] {
    def read(value: JsValue) = {
      value.asJsObject.getFields("text") match {
        case Seq(JsString(text)) => new ChatCommand(text)
        case _ => throw new DeserializationException("ChatCommand expected")
      }
    }
  }
}
