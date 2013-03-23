package twosnakes.world.message

import spray.json._

abstract class BaseMessageJsonFormat[T] extends RootJsonFormat[T] {
  def read(json: JsValue): T = throw new UnsupportedOperationException
}

object MessageJsonProtocol extends DefaultJsonProtocol {
  import ChatMessageJsonProtocol._

  implicit object MessageJsonFormat extends BaseMessageJsonFormat[Message] {
    def write(message: Message) = message.messageType match {
      case ChatMessage.messageType =>
        val cm = message.asInstanceOf[ChatMessage]
        JsObject("type" -> JsString(cm.messageType), "data" -> cm.toJson)
      case _ => throw new SerializationException("Unrecognized message type")
    }
  }
}

trait Message {
  import MessageJsonProtocol._

  def messageType: String

  val at = System.currentTimeMillis

  def serialize = this.toJson.compactPrint
}
