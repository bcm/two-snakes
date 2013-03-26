package twosnakes.world.command

import org.jboss.netty.channel.Channel
import spray.json._
import twosnakes.world.message.ChatMessage

// XXX: refine into different types of chat commands - say, msg, emote

case class ChatCommand(p: ChatCommandPacket, c: Channel) extends Command(p, c) {
  def createProcessor = new ChatCommandProcessor()
}

case class ChatCommandPacket(val text: String) extends CommandPacket {
  def createCommand(channel: Channel) = ChatCommand(this, channel)
}

class ChatCommandProcessor extends CommandProcessor {
  def receive = {
    case command: ChatCommand =>
      log.warning("Received chat message: %s".format(command.packet.text))
      // XXX: send (new ChatMessage(command.text) to the client
      context.stop(self)
  }
}

object ChatCommandPacketJsonProtocol extends DefaultJsonProtocol {
  implicit object ChatCommandPacketJsonFormat extends BaseCommandPacketJsonFormat[ChatCommandPacket] {
    def read(value: JsValue) = {
      value.asJsObject.getFields("text") match {
        case Seq(JsString(text)) => new ChatCommandPacket(text)
        case _ => throw new DeserializationException("ChatCommand expected")
      }
    }
  }
}
