"use strict"

class SwappableRouter extends Backbone.Router
  swap: (newView) =>
    @currentView.remove() if @currentView?
    @currentView = newView
    @$el.empty().append(@currentView.render().el)

window.SwappableRouter = SwappableRouter
