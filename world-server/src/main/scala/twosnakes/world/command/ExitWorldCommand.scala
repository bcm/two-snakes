package twosnakes.world.command

import akka.actor._
import spray.json._
import twosnakes.world.event._
import twosnakes.world.grid._
import twosnakes.world.session._

case class ExitWorldCommand() extends Command {
  def createProcessor = new ExitWorldCommandProcessor()
}

class ExitWorldCommandProcessor extends CommandProcessor {
  def receive = {
    case Tuple2(command: ExitWorldCommand, session: CharacterSession) =>
      log.debug("Exiting world as %s (%d)".format(session.character.name, session.character.id))
      sessionManager ! SessionEnd(session)
      // XXX: remove from the grid
      context.stop(self)
  }
}

object ExitWorldCommandJsonProtocol extends DefaultJsonProtocol {
  implicit object ExitWorldCommandJsonFormat extends BaseCommandJsonFormat[ExitWorldCommand] {
    def read(value: JsValue) = ExitWorldCommand()
  }
}
