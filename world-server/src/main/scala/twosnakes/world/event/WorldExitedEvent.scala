package twosnakes.world.event

import spray.json._
import twosnakes.world.grid.GridSquare
import twosnakes.world.model.Character

case class WorldExitedEvent(c: Character, location: GridSquare) extends CharacterEvent(c)

object WorldExitedEvent {
  val eventType = "world-exited"
}

object WorldExitedEventJsonProtocol extends DefaultJsonProtocol {
  implicit object WorldExitedEventJsonFormat extends BaseEventJsonFormat[WorldExitedEvent] {
    def write(event: WorldExitedEvent) =
      JsObject("character" -> JsObject("id" -> JsNumber(event.character.id),
                                       "name" -> JsString(event.character.name)),
               "location" -> JsObject("x" -> JsNumber(event.location.x),
                                      "y" -> JsNumber(event.location.y)),
               "at" -> JsNumber(event.at))
  }
}
