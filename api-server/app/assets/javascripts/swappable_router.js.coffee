"use strict"

# CoffeeScript, Backbone 1.0-compatible version of the class from https://github.com/thoughtbot/backbone-support
class SwappableRouter extends Backbone.Router
  swap: (newView) =>
    @currentView.remove() if @currentView?
    @currentView = newView
    @currentView.render()
    @$el.empty().append(@currentView.el) if @$el?

window.SwappableRouter = SwappableRouter
