package twosnakes.world.event

import spray.json._
import twosnakes.world.model.Character

case class SystemErrorEvent(code: Int) extends Event

object SystemErrorEvent {
  val eventType = "system-error"
}

object SystemErrorEventJsonProtocol extends DefaultJsonProtocol {
  implicit object SystemErrorEventJsonFormat extends BaseEventJsonFormat[SystemErrorEvent] {
    def write(event: SystemErrorEvent) =
      JsObject("code" -> JsNumber(event.code),
               "at" -> JsNumber(event.at))
  }
}
