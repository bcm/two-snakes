package twosnakes.world.repository.character

import akka.actor._
import scala.slick.driver.PostgresDriver.simple._
import Database.threadLocalSession
import twosnakes.world.model.Character
import twosnakes.world.repository.db._

object Characters extends Table[Character]("characters") {
  def id = column[Long]("id", O.PrimaryKey)
  def name = column[String]("name")
  def str = column[Int]("str")
  def dex = column[Int]("dex")
  def con = column[Int]("con")
  def int = column[Int]("int")
  def wis = column[Int]("wis")
  def cha = column[Int]("cha")

  def * = id ~ name ~ str ~ dex ~ con ~ int ~ wis ~ cha <> (Character, Character.unapply _)
}

class CharacterRepository extends Actor with ActorLogging {
  var querier: ActorRef = null

  def receive = {
    case FindCharacter(id) =>
      querier = sender
      context.system.actorFor("/user/DbSupervisor") ! QueryDatabase(FindCharacterQuery(id))
    // XXX: it'd be nice to specify query: FindCharacterQuery, but then I get this compilation error, and I don't
    //      understand variance well enough to fix it.
    //  found   : twosnakes.world.repository.character.FindCharacterQuery
    //  required: twosnakes.world.repository.db.DbQuery[Any]
    // Note: Option[twosnakes.world.model.Character] <: Any (and twosnakes.world.repository.character.FindCharacterQuery <: twosnakes.world.repository.db.DbQuery[Option[twosnakes.world.model.Character]]), but trait DbQuery is invariant in type T.
    // You may wish to define T as +T instead. (SLS 4.5)
    //     case DatabaseQueried(query: FindCharacterQuery, result) =>
    case DatabaseQueried(query, result) =>
      result match {
        case Some(character: Character) =>
          querier ! CharacterFound(character)
        case None =>
          querier ! CharacterNotFound(query.asInstanceOf[FindCharacterQuery].id)
      }
  }
}

case class FindCharacterQuery(id: Long) extends DbQuery[Option[Character]] {
  // XXX: barfs about not finding implicit session if I don't import import Database.threadLocalSession... but that
  // violates encapsulation of DbSupervisor and it may have side effects that I'm not aware of
  def execute: Option[Character] = (for(c <- Characters if c.id is id) yield c).firstOption
}

case class FindCharacter(id: Long)
case class CharacterFound(character: Character)
case class CharacterNotFound(id: Long)
