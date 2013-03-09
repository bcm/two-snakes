# Two Snakes

An exploration of "thick client" web application technology and server-side concurrency and distributed systems issues in the guise of an extremely simplistic multiplayer game with a persistent shared world

![Thulsa Doom](./thulsa-doom.jpg)

## 1. Build environment

While the various components are written in a variety of languages, a number of them require [Ruby](http://ruby-lang.org/) 2.0 for build automation and other tasks.

[RVM](https://rvm.io/) provides a mechanism for managing multiple versions of Ruby and project-specific dependency sets (gemsets). The `.rvmrc` file in the project directory specifies the version of the ruby interpreter and the name of the gemset to use for this project.

```sh
# Install RVM
$ \curl -#L https://get.rvm.io | bash -s stable --ruby

# Load RVM in your current shell (not needed if you close the shell and open a new one)
$ source ~/.rvm/scripts/rvm

# If you did not follow the instructions provided in the output of the installation script, run these commands and do what they say
$ rvm requirements
$ rvm notes

# Install Ruby 2.0
$ rvm install 2.0.0

# Load the project-specific RVM configuration
$ source .rvmrc 
Using /Users/bcm/.rvm/gems/ruby-2.0.0-p0 with gemset two-snakes

# Ensure rvm is using the right ruby and gemset
$ rvm info

ruby-2.0.0-p0@two-snakes:
...
```

[Bundler](http://gembundler.com/) is used to manage dependencies. 

```sh
# Install bundler
$ gem install bundler

# Install dependencies
$ bundle
```

A project-specific Bash script provides a number of utility functions.

```sh
# Load bash script
$ source etc/bashrc
```

## 2. Services

The system is expected to provide services for data storage etc.

```sh
# Start services
$ 2s-start-services

# Stop services
$ 2s-stop-services
```
