package twosnakes.world.grid

import akka.actor._
import scala.collection.mutable.Map
import scala.util.Random
import twosnakes.world.model.Character

case class GridSquare(x: Int, y: Int)

// XXX: remove assigned square when character exits the world

class GridManager extends Actor with ActorLogging {
  private val assignedSquares = Map[GridSquare, Character]()

  def receive = {
    case AssignCharacterToRandomSquare(character) =>
      sender ! CharacterAssignedToSquare(character, randomSquare(character))
  }

  def randomSquare(character: Character): GridSquare = {
    val square = GridSquare(Random.nextInt(10), Random.nextInt(10))
    assignedSquares.get(square) match {
      case Some(character) => randomSquare(character)
      case None =>
        assignedSquares += square -> character
        square
    }
  }
}

case class AssignCharacterToRandomSquare(character: Character)
case class CharacterAssignedToSquare(character: Character, square: GridSquare)
