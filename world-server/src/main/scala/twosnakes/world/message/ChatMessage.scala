package twosnakes.world.message

import spray.json._

case class ChatMessage(val text: String) extends Message

object ChatMessage {
  val messageType = "chat"
}

object ChatMessageJsonProtocol extends DefaultJsonProtocol {
  implicit object ChatMessageJsonFormat extends BaseMessageJsonFormat[ChatMessage] {
    def write(message: ChatMessage) = JsObject("text" -> JsString(message.text), "at" -> JsNumber(message.at))
  }
}
