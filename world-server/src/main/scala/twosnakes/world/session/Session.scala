package twosnakes.world.session

import twosnakes.world.grid.GridSquare
import twosnakes.world.model.Character

class Session

class CharacterSession(val character: Character) extends Session {
  var location: GridSquare = null
}
