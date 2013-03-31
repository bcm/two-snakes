package twosnakes.world.event

import spray.json._
import twosnakes.world.model.Character

abstract class BaseEventJsonFormat[T] extends RootJsonFormat[T] {
  def read(json: JsValue): T = throw new UnsupportedOperationException
}

object EventJsonProtocol extends DefaultJsonProtocol {
  import ChatSayEventJsonProtocol._
  import SystemErrorEventJsonProtocol._
  import WorldEnteredEventJsonProtocol._
  import WorldExitedEventJsonProtocol._

  implicit object EventJsonFormat extends BaseEventJsonFormat[Event] {
    def write(event: Event) = event match {
      case e: ChatSayEvent => JsObject("type" -> JsString(ChatSayEvent.eventType), "data" -> e.toJson)
      case e: SystemErrorEvent => JsObject("type" -> JsString(SystemErrorEvent.eventType), "data" -> e.toJson)
      case e: WorldEnteredEvent => JsObject("type" -> JsString(WorldEnteredEvent.eventType), "data" -> e.toJson)
      case e: WorldExitedEvent => JsObject("type" -> JsString(WorldExitedEvent.eventType), "data" -> e.toJson)
      case _ => throw new SerializationException("Unrecognized event type")
    }

    // XXX: fails to compile with "Cannot find JsonWriter or JsonFormat type class for T"
//    def writeEnvelope[T <: Event](event: T, eventType: String) =
//      JsObject("type" -> JsString(eventType), "data" -> event.toJson)
  }
}

abstract class Event {
  import EventJsonProtocol._

  val at = System.currentTimeMillis

  def serialize = this.toJson.compactPrint
}

abstract class CharacterEvent(val character: Character) extends Event
