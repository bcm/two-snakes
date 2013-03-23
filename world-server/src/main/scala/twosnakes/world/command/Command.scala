package twosnakes.world.command

import spray.json._
import twosnakes.world.message.Message

abstract class BaseCommandJsonFormat[T] extends RootJsonFormat[T] {
  def write(command: T) = null
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
  def process: Seq[Message]
}

object Command {
  import CommandJsonProtocol._

  def apply(source: String) = source.asJson.convertTo[Command]
}
