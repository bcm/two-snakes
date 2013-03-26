package twosnakes.world.repository

import scala.slick.driver.PostgresDriver.simple._
import Database.threadLocalSession
import twosnakes.world.model.Character

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

// XXX: what is the best practice for accessing slick sessions in an akka context? should the repository be an actor?
// how do db sessions map to actors/threads?
// see http://doc.akka.io/docs/akka/2.1.2/general/actor-systems.html -
// " A common pattern is to create a router for N actors, each of which wraps a single DB connection and handles
// queries as sent to the router. The number N must then be tuned for maximum throughput, which will vary depending
// on which DBMS is deployed on what hardware."

object CharacterRepository {
  def findCharacter(id: Long): Option[Character] =
    Database.forURL(System.getenv("DATABASE_URL"), driver = "org.postgresql.Driver") withSession {
      (for(c <- Characters if c.id is id) yield c).firstOption
   }
}
