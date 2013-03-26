package twosnakes.world.session

import org.jboss.netty.channel.Channel
import org.jboss.netty.handler.codec.http.websocketx.TextWebSocketFrame
import twosnakes.world.message.Message
import twosnakes.world.model.Character

class Session (val channel: Channel) {
  def send(text: String): Unit = channel.write(new TextWebSocketFrame(text))
  def send(message: Message): Unit = send(message.serialize)
}

class CharacterSession(val c: Channel, val character: Character) extends Session(c)
