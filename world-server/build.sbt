import com.typesafe.startscript.StartScriptPlugin

seq(StartScriptPlugin.startScriptForClassesSettings: _*)

name := "world-server"

version := "1.0"

scalaVersion := "2.10.0"

libraryDependencies += "org.mashupbots.socko" %% "socko-webserver" % "0.2.4"
