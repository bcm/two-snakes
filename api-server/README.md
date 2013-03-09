# API Server

Presents an HTTP API for player and character management

## 1. Platform & build environment

Written in [Ruby](http://ruby-lang.org/). **Version 2.0.x**

Ruby and various support packages are installed via the [main project instructions](../).

Note that the API server has its own set of gem dependencies in addition to those required by the main project.

```sh
# Install api server dependencies
$ bundle
```

## 2. Environment-specific configuration

Configuration items specific to the host environment are configured in the `.env` file. This file is read when the server starts up and its contents are made available to the server process as environment variables. The file is ignored by git and must be created by hand.

### 2.1 Development environment

```sh
$ echo RACK_ENV=development >> .env
```

## 3. Database

Data is stored in [PostgreSQL](http://www.postgresql.org/).

### 3.1 Database Connection

Database connection information is taken from the `DATABASE_URL` environment variable in the `.env` file.

```sh
$ echo DATABASE_URL=postgresql://twosnakes:twosnakes@localhost/twosnakes_development >> .env
```

### 3.2 Database Setup

Use these commands to set up the database in Postgres:

```sh
# Create the database user (role) with a password and permission to create databases
$ createuser -P -d twosnakes
Enter password for new role: twosnakes
Enter it again: twosnakes
```

### 3.3 Database Migration

Use these commands to create and migrate the database:

```sh
# Creates the database
$ rake db:create

# Applies migrations to arrive at the final schema
$ rake db:migrate
```

## 4. Run the server

The server runs on port 5000 using the [Thin](http://code.macournoyer.com/thin/) web server. [Foreman](https://github.com/ddollar/foreman) is used to run the server process.

```sh
$ foreman start
10:49:44 web.1  | started with pid 99238
10:49:47 web.1  | => Booting Thin
10:49:47 web.1  | => Rails 3.2.12 application starting in development on http://0.0.0.0:5000
10:49:47 web.1  | => Call with -d to detach
10:49:47 web.1  | => Ctrl-C to shutdown server
10:49:48 web.1  | >> Thin web server (v1.5.0 codename Knife)
10:49:48 web.1  | >> Maximum connections set to 1024
10:49:48 web.1  | >> Listening on 0.0.0.0:5000, CTRL+C to stop
```
