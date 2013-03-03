# World Server

Coordinates game play, orchestrates persistent shared world

## 1. Java, Scala & SBT

Written in [Scala](http://www.scala-lang.org/). **Version 2.10.x**

```sh
# Install scala on OS X with Homebrew
$ brew install scala
```

[sbt](http://www.scala-sbt.org/) builds the project and manages dependencies. **Version 0.12.x**

```sh
# Install sbt on OS X with Homebrew
$ brew install sbt

# Download dependencies and establish build artifacts in `target/`
$ sbt
```

Scala runs on the JVM. **Version 1.7.x**

On OS X, download a JDK at http://www.oracle.com/technetwork/java/javase/downloads/index.html.

## 2. Build the server

Use sbt to compile the code:

```sh
# Compile the code at the command line
$ sbt compile
[info] Loading project definition from /Users/bcm/Projects/maz/two-snakes/world-server/project
[info] Set current project to world-server (in build file:/Users/bcm/Projects/maz/two-snakes/world-server/)
[success] Total time: 1 s, completed Mar 3, 2013 11:29:36 AM

# Compile the code interactively in the sbt console
$ sbt
[info] Loading project definition from /Users/bcm/Projects/maz/two-snakes/world-server/project
[info] Set current project to world-server (in build file:/Users/bcm/Projects/maz/two-snakes/world-server/)
> compile
[success] Total time: 1 s, completed Mar 3, 2013 11:29:36 AM
> 
```

Remove compiled code in the same way:

```sh
$ sbt clean
[info] Loading project definition from /Users/bcm/Projects/maz/two-snakes/world-server/project
[info] Set current project to world-server (in build file:/Users/bcm/Projects/maz/two-snakes/world-server/)
[success] Total time: 0 s, completed Mar 3, 2013 11:30:56 AM
```

## 3. Run the server

The server runs on port 8888 by default.

```sh
$ sbt run
[info] Loading project definition from /Users/bcm/Projects/maz/two-snakes/world-server/project
[info] Set current project to world-server (in build file:/Users/bcm/Projects/maz/two-snakes/world-server/)
[info] Updating {file:/Users/bcm/Projects/maz/two-snakes/world-server/}default-dc97d9...
[info] Resolving ch.qos.logback#logback-core;1.0.9 ...
[info] Done updating.
[info] Compiling 1 Scala source to /Users/bcm/Projects/maz/two-snakes/world-server/target/scala-2.10/classes...
[info] Running twosnakes.world.WorldServer 
11:32:08.482 [run-main] INFO  o.m.socko.webserver.WebServer - Socko server '[WebServer, localhost, 8888]' started on {}:{}
```

Log output is written to the console.

```sh
# When a request is received at localhost:8888
11:32:49.869 [New I/O worker #1] DEBUG o.m.socko.webserver.RequestHandler - HTTP EndPoint(GET,localhost:8888,/) CHANNEL=731770033 
11:32:50.346 [New I/O worker #1] DEBUG o.m.socko.webserver.RequestHandler - HTTP EndPoint(GET,localhost:8888,/favicon.ico) CHANNEL=731770033
```

### Run the server with Foreman

This method is used by Heroku to run the server without keeping sbt in memory. It relies on the [sbt start script plugin](https://github.com/sbt/sbt-start-script) to generate a `target/start` script and [Foreman](https://github.com/ddollar/foreman) to run the script.

```sh
$ sbt stage
[info] Loading project definition from /Users/bcm/Projects/maz/two-snakes/world-server/project
[info] Set current project to world-server (in build file:/Users/bcm/Projects/maz/two-snakes/world-server/)
[info] Wrote start script for mainClass := Some(twosnakes.world.WorldServer) to /Users/bcm/Projects/maz/two-snakes/world-server/target/start
[success] Total time: 1 s, completed Mar 3, 2013 11:37:38 AM

$ foreman start
11:39:20 web.1  | started with pid 4859
11:39:23 web.1  | 11:39:23.247 [main] INFO  o.m.socko.webserver.WebServer - Socko server '[WebServer, localhost, 8888]' started on {}:{}
```
