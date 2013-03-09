# Web Front End

Renders a web interface to the API and World Servers

## 1. Platform & build environment

Executable code written in [CoffeeScript](http://coffeescript.org/).

The CoffeeScript build environment requires a [Node](http://nodejs.org/) JavaScript runtime and the [NPM](https://npmjs.org/) package manager.

```sh
# Install Node on OS X with Homebrew
$ brew install node

# Install NPM
$ curl https://npmjs.org/install.sh | sh
```

# Install NPM dependencies
$ npm install
```

CSS code written using the [SCSS syntax](http://sass-lang.com/). Compiling SCSS code requires [Ruby](http://www.ruby-lang.org/en/) and the [Compass](http://compass-style.org/) framework. These packages are installed via the [main project instructions](../).

### NPM dependencies

Some build tools are installed via NPM.

```sh
# Install NPM dependencies
$ npm install
```

Web packages (bundles of images, CSS and JavaScript) and their dependencies are managed with [Bower](http://twitter.github.com/bower/).

```sh
# Install Bower components into `app/components/`
$ bower install
```

[Grunt](http://gruntjs.com/) automates project tasks like compiling CoffeeScript and SCSS code, running tests, packaging the application and previewing it in a web server.

[Yeoman](http://yeoman.io/) provides a number of useful Grunt tasks and generators for popular web frameworks. The project was scaffolded with Yeoman.

## 2. Run the application

Compiling and running the application is accomplished with `grunt server`. The application runs in an embedded web server on port 9000. The application is automatically opened in the default web browser. Changes to source files are detected and cause the application to be reloaded automatically.

```sh
$ grunt server
Running "server" task

Running "clean:server" (clean) task
Cleaning ".tmp"...OK

Running "coffee:dist" (coffee) task
File .tmp/scripts/account_nav_view.js created.
File .tmp/scripts/alert_view.js created.
...

Running "compass:server" (compass) task
directory .tmp/styles/
   create .tmp/styles/main.css

Running "livereload-start" task
... Starting Livereload server on 35729 ...

Running "connect:livereload" (connect) task
Starting connect web server on localhost:9000.

Running "open:server" (open) task

Running "watch" task
Watching app/scripts/{,*/}*.coffee
Watching test/spec/{,*/}*.coffee
Watching app/styles/{,*/}*.{scss,sass}
Watching app/*.html,{.tmp,app}/styles/{,*/}*.css,{.tmp,app}/scripts/{,*/}*.js,app/images/{,*/}*.{png,jpg,jpeg,webp}


```
