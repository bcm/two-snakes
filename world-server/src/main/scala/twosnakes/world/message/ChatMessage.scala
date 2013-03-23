package twosnakes.world.message

import spray.json._

case class ChatMessage(text: String) extends Message {
  val data = Map[String, JsValue]("text" -> JsString(text))
}
