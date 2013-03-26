package twosnakes.world.command

import spray.json._
import twosnakes.world.message.ChatMessage

// XXX: refine into different types of chat commands - say, msg, emote

class ChatCommand(val text: String) extends Command {
  def createProcessor = new ChatCommandProcessor()
}

class ChatCommandProcessor extends CommandProcessor {
  def receive = {
    case command: ChatCommand =>
      log.warning("Received chat message: %s".format(command.text))
      // XXX: send (new ChatMessage(command.text) to the client
      context.stop(self)
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
