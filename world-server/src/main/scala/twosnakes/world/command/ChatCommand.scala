package twosnakes.world.command

import spray.json._
import twosnakes.world.message.ChatMessage
import twosnakes.world.session.CharacterSession

// XXX: refine into different types of chat commands - say, msg, emote

case class ChatCommand(text: String) extends Command {
  def createProcessor = new ChatCommandProcessor()
}

class ChatCommandProcessor extends CommandProcessor {
  def receive = {
    case Tuple2(command: ChatCommand, session: CharacterSession) =>
      log.warning("Received chat message from %s: %s".format(session.character.name, command.text))
      session.send(new ChatMessage(command.text))
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
