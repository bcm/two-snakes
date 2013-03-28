package twosnakes.world.repository

import akka.actor._
import twosnakes.world.WorldServer

abstract class Repository extends Actor with ActorLogging {
  val dbPool = WorldServer.dbActorSystem.actorFor("/user/DbSupervisor")
  var querier: ActorRef = null
}
