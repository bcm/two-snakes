package twosnakes.world.repository

import scala.slick.driver.PostgresDriver.simple._
import Database.threadLocalSession

object Characters extends Table[(Long, String, Int, Int, Int, Int, Int, Int)]("characters") {
  def id = column[Long]("id", O.PrimaryKey)
  def name = column[String]("name")
  def str = column[Int]("str")
  def dex = column[Int]("dex")
  def con = column[Int]("con")
  def int = column[Int]("int")
  def wis = column[Int]("wis")
  def cha = column[Int]("cha")

  def * = id ~ name ~ str ~ dex ~ con ~ int ~ wis ~ cha
}

// XXX: what is the best practice for accessing slick sessions in an akka context? should the repository be an actor?
// how do db sessions map to actors/threads?
// XXX: wow, the logging is so obnoxious, turn off debug logging for scala.slick

object CharacterRepository {
  def findCharacter(id: Long): Option[_] =
    Database.forURL(System.getenv("DATABASE_URL"), driver = "org.postgresql.Driver") withSession {
      (for(c <- Characters if c.id is id) yield c).firstOption
   }
}
