"use strict"

class CompositeView extends Backbone.View
  remove: =>
    super.remove()
    this._removeChildren()
    this._removeFromParent()

  renderChild: (view) =>
    view.render()
    @children ?= []
    @children.push(view)
    view.parent = this

  renderChildInto: (view, container) =>
    this.renderChild(view)
    $(container).empty().append(view.el)

  appendChild: (view) =>
    this.appendChildTo(this.el)

  appendChildTo: (view, container) =>
    this.renderChild(view)
    $(container).append(view.el)

  prependChild: (view) =>
    this.prependChildTo(this.el)

  prependChildTo: (view, container) =>
    this.renderChild(view)
    $(container).prepend(view.el)

  _removeChildren: =>
    if @children?
      @children.chain().clone().each (view) =>
        view.remove()

  _removeFromParent: =>
    if @parent?
      @parent._removeChild(this)

  _removeChild: (view) =>
    index = @children.indexOf(view)
    @children.splice(index, 1)

window.CompositeView = CompositeView

