package twosnakes.world.command

import akka.actor._
import org.jboss.netty.channel.Channel
import spray.json._
import twosnakes.world.message.ChatMessage
import twosnakes.world.repository.CharacterRepository

case class EnterWorldCommand(p: EnterWorldCommandPacket, c: Channel) extends Command(p, c) {
  def createProcessor = new EnterWorldCommandProcessor()
}

case class EnterWorldCommandPacket(characterId: Long) extends CommandPacket {
  def createCommand(channel: Channel) = EnterWorldCommand(this, channel)
}

class EnterWorldCommandProcessor extends CommandProcessor {
  def receive = {
    case command: EnterWorldCommand =>
      // XXX: if there's an existing session for this character then use it. otherwise, begin a new session
      // XXX: model session as a specifically-named actor which maintains the state of the player's socket, the
      // character and its location in the world
      // see http://doc.akka.io/docs/akka/2.1.2/general/addressing.html
      CharacterRepository.findCharacter(command.packet.characterId) match {
        case Some(character) =>
          log.debug("Establishing session for %s (%d)".format(character.name, character.id))
          // XXX: send (new ChatMessage("Welcome to the world of Two Snakes!") to the client
          context.stop(self)
        case _ =>
          log.error("Could not establish session for haracter %d: Character not found".
                      format(command.packet.characterId))
          // XXX: send new ChatMessage("Something has gone horribly wrong")) to the client
          context.stop(self)
      }
      context.stop(self)
  }
}

object EnterWorldCommandPacketJsonProtocol extends DefaultJsonProtocol {
  implicit object EnterWorldCommandPacketJsonFormat extends BaseCommandPacketJsonFormat[EnterWorldCommandPacket] {
    def read(value: JsValue) = {
      value.asJsObject.getFields("characterId") match {
        case Seq(JsNumber(characterId)) => new EnterWorldCommandPacket(characterId.toLong)
        case _ => throw new DeserializationException("EnterWorldCommand expected")
      }
    }
  }
}
