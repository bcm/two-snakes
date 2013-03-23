package twosnakes.world

import spray.json._

trait Command {
  def process: Seq[Message]
}

case class EnterWorldCommand(characterId: Long) extends Command {
  def process = {
    // XXX: look up the character, figure out where in the world it is and remember it
    Seq(ChatMessage("Welcome to the world of Two Snakes!"))
  }
}

// XXX: refine into different types of chat commands - say, msg, emote
case class ChatCommand(text: String) extends Command {
  def process = {
    Seq(ChatMessage(text))
  }
}

object Command {
  def apply(source: String) = {
    val packet = source.asJson.asJsObject
    val data = packet.getFields("data")(0).asJsObject
    packet.getFields("type")(0) match {
      case JsString("enterworld") =>
        data.getFields("characterId") match {
          case Seq(JsNumber(characterId)) => EnterWorldCommand(characterId.toLong)
          case _ => throw new DeserializationException("EnterWorldCommand expected")
        }
      case JsString("chat") =>
        data.getFields("text") match {
          case Seq(JsString(text)) => ChatCommand(text)
          case _ => throw new DeserializationException("ChatCommand expected")
        }
      case _ => throw new DeserializationException("Invalid command type %s".format(packet.getFields("type")(0)))
    }
  }
}
