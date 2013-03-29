package twosnakes.world.event

import spray.json._
import twosnakes.world.model.Character

case class ChatSayEvent(c: Character, text: String) extends CharacterEvent(c)

object ChatSayEvent {
  val eventType = "chat-say"
}

object ChatSayEventJsonProtocol extends DefaultJsonProtocol {
  implicit object ChatSayEventJsonFormat extends BaseEventJsonFormat[ChatSayEvent] {
    def write(event: ChatSayEvent) =
      JsObject("character" -> JsObject("id" -> JsNumber(event.character.id),
                                       "name" -> JsString(event.character.name)),
               "text" -> JsString(event.text),
               "at" -> JsNumber(event.at))
  }
}
