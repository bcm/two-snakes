package twosnakes.world.event

import spray.json._
import twosnakes.world.grid.GridSquare
import twosnakes.world.model.Character

case class WorldEnteredEvent(c: Character, location: GridSquare) extends CharacterEvent(c)

object WorldEnteredEvent {
  val eventType = "world-entered"
}

object WorldEnteredEventJsonProtocol extends DefaultJsonProtocol {
  implicit object WorldEnteredEventJsonFormat extends BaseEventJsonFormat[WorldEnteredEvent] {
    def write(event: WorldEnteredEvent) =
      JsObject("character" -> JsObject("id" -> JsNumber(event.character.id),
                                       "name" -> JsString(event.character.name)),
               "location" -> JsObject("x" -> JsNumber(event.location.x),
                                      "y" -> JsNumber(event.location.y)),
               "at" -> JsNumber(event.at))
  }
}
