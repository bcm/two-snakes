package twosnakes.world.session

import org.jboss.netty.channel.Channel
import org.jboss.netty.handler.codec.http.websocketx.TextWebSocketFrame
import twosnakes.world.event.Event
import twosnakes.world.model.Character

class Session (val channel: Channel) {
  // XXX: throws java.nio.channels.ClosedChannelException when the client closes the socket unexpectedly
  def send(text: String): Unit = channel.write(new TextWebSocketFrame(text))
  def send(event: Event): Unit = send(event.serialize)
}

class CharacterSession(val c: Channel, val character: Character) extends Session(c)
