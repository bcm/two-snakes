package twosnakes.world.command

import akka.actor._
import org.jboss.netty.channel.Channel
import spray.json._

abstract class BaseCommandPacketJsonFormat[T] extends RootJsonFormat[T] {
  def write(packet: T) = throw new UnsupportedOperationException
}

object CommandPacketJsonProtocol extends DefaultJsonProtocol {
  import EnterWorldCommandPacketJsonProtocol._
  import ChatCommandPacketJsonProtocol._

  implicit object CommandPacketJsonFormat extends BaseCommandPacketJsonFormat[CommandPacket] {
    def read(value: JsValue) = {
      value.asJsObject.getFields("type", "data") match {
        case Seq(JsString("enterworld"), JsObject(data)) => JsObject(data).convertTo[EnterWorldCommandPacket]
        case Seq(JsString("chat"), JsObject(data)) => JsObject(data).convertTo[ChatCommandPacket]
        case _ => throw new DeserializationException("Invalid command type")
      }
    }
  }
}

abstract class Command(val packet: CommandPacket, val channel: Channel) {
  def createProcessor: CommandProcessor
}

object Command {
  import CommandPacketJsonProtocol._

  def apply(source: String, channel: Channel) = {
    val packet = source.asJson.convertTo[CommandPacket]
    packet.createCommand(channel)
  }
}

trait CommandPacket {
  def createCommand(channel: Channel): Command
}

abstract class CommandProcessor extends Actor with ActorLogging
