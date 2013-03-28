package twosnakes.world.repository.db

import akka.actor._
import scala.slick.driver.PostgresDriver.simple._
import Database.threadLocalSession

class DbSupervisor extends Actor with ActorLogging {
  val db = Database.forURL(System.getenv("DATABASE_URL"), driver = "org.postgresql.Driver")

  def receive = {
    case QueryDatabase(query) =>
      val result = db withSession { query.execute }
      sender ! query.queried(result)
  }
}

trait DbQuery[T] {
  def execute: T

  def queried(result: T) = DatabaseQueried[T](this, result)
}

case class QueryDatabase[T](query: DbQuery[T])
case class DatabaseQueried[T](query: DbQuery[T], result: T)
