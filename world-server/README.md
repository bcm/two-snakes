# World Server

Coordinates game play and orchestrates the persistent shared world

## 1. Platform & build environment

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

## 2. Environment-specific configuration

Configuration items specific to the host environment are configured in the `.env` file. This file is read when the server starts up and its contents are made available to the server process as environment variables. The file is ignored by git and must be created by hand.

A similar file named `.env.test` is used for the test environment.

## 3. Database

Data is stored in [PostgreSQL](http://www.postgresql.org/). See the [API Server documentation] for how to create and set up the database.

### 3.1 Database connection

Database connection information is taken from the `DATABASE_URL` environment variable in the `.env` file.

#### Development environment

```sh
$ echo DATABASE_URL='jdbc:postgresql://localhost/twosnakes_development?user=twosnakes&password=twosnakes' &gt;&gt; .env
```

## 4. Build the server

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

## 5. Run the server

This method of running the server relies on the [sbt start script plugin](https://github.com/sbt/sbt-start-script) to generate a `target/start` script and [Foreman](https://github.com/ddollar/foreman) to run the script.

The project must be re-staged any time a dependency is added to the build or the application config file is modified:

```sh
$ sbt stage
[info] Loading project definition from /Users/bcm/Projects/maz/two-snakes/world-server/project
[info] Set current project to world-server (in build file:/Users/bcm/Projects/maz/two-snakes/world-server/)
[info] Wrote start script for mainClass := Some(twosnakes.world.WorldServer) to /Users/bcm/Projects/maz/two-snakes/world-server/target/start
[success] Total time: 1 s, completed Mar 3, 2013 11:37:38 AM
```

Foreman exports the environment from `.env` and runs the start script:

```sh
$ foreman start
11:39:20 world.1  | started with pid 4859
11:39:23 world.1  | 11:39:23.247 [main] INFO  o.m.socko.webserver.WebServer - Socko server '[WebServer, localhost, 8888]' started on {}:{}
```

Log output is written to the console.

```sh
# When a request is received at localhost:8888
11:32:49.869 [New I/O worker #1] DEBUG o.m.socko.webserver.RequestHandler - HTTP EndPoint(GET,localhost:8888,/) CHANNEL=731770033 
11:32:50.346 [New I/O worker #1] DEBUG o.m.socko.webserver.RequestHandler - HTTP EndPoint(GET,localhost:8888,/favicon.ico) CHANNEL=731770033
```
