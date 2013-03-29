package twosnakes.world.command

import spray.json._
import twosnakes.world.event.ChatSayEvent
import twosnakes.world.session._

// XXX: refine into different types of chat commands - say, msg, emote

case class ChatCommand(text: String) extends Command {
  def createProcessor = new ChatCommandProcessor()
}

class ChatCommandProcessor extends CommandProcessor {
  def receive = {
    case Tuple2(command: ChatCommand, session: CharacterSession) =>
      log.warning("Received chat message from %s: %s".format(session.character.name, command.text))
      sessionManager ! SessionSendAll(new ChatSayEvent(session.character, command.text))
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
