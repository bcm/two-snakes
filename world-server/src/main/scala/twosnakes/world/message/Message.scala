package twosnakes.world.message

import spray.json._

trait Message {
  val at = System.currentTimeMillis

  def serialize = {
    val extendedData = data ++ Map[String, JsValue]("at" -> JsNumber(at))
    JsObject("type" -> JsString("chat"), "data" -> JsObject(extendedData)).compactPrint
  }

  val data: Map[String, JsValue]
}
