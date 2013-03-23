package twosnakes.world

import spray.json._

trait Message {
  val at = System.currentTimeMillis

  def serialize = {
    val extendedData = data ++ Map[String, JsValue]("at" -> JsNumber(at))
    JsObject("type" -> JsString("chat"), "data" -> JsObject(extendedData)).compactPrint
  }

  val data: Map[String, JsValue]
}

case class ChatMessage(text: String) extends Message {
  val data = Map[String, JsValue]("text" -> JsString(text))
}
