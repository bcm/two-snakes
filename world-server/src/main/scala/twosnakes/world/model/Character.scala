package twosnakes.world.model

case class Character(val id: Long, val name: String, val str: Int, val dex: Int, val con: Int, val int: Int,
                     val wis: Int, val cha: Int) {
  override def toString = "%s (%d)".format(name, id)
}
