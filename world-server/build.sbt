import com.typesafe.startscript.StartScriptPlugin

seq(StartScriptPlugin.startScriptForClassesSettings: _*)

name := "world-server"

version := "1.0"

scalaVersion := "2.10.0"

resolvers += "spray-repo" at "http://repo.spray.io"

libraryDependencies ++= List(
  "com.typesafe.slick" %% "slick" % "1.0.0",
  "io.spray" %%  "spray-json" % "1.2.3",
  "org.mashupbots.socko" %% "socko-webserver" % "0.2.4",
  "postgresql" % "postgresql" % "9.1-901-1.jdbc4"
)