package twosnakes.world.command

import akka.actor._
import spray.json._

abstract class BaseCommandJsonFormat[T] extends RootJsonFormat[T] {
  def write(packet: T) = throw new UnsupportedOperationException
}

object CommandJsonProtocol extends DefaultJsonProtocol {
  import EnterWorldCommandJsonProtocol._
  import ChatCommandJsonProtocol._

  implicit object CommandJsonFormat extends BaseCommandJsonFormat[Command] {
    def read(value: JsValue) = {
      value.asJsObject.getFields("type", "data") match {
        case Seq(JsString("enterworld"), JsObject(data)) => JsObject(data).convertTo[EnterWorldCommand]
        case Seq(JsString("chat"), JsObject(data)) => JsObject(data).convertTo[ChatCommand]
        case _ => throw new DeserializationException("Invalid command type")
      }
    }
  }
}

trait Command {
  def createProcessor: CommandProcessor
}

object Command {
  import CommandJsonProtocol._

  def apply(source: String) = source.asJson.convertTo[Command]
}

abstract class CommandProcessor extends Actor with ActorLogging
