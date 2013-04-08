"use strict"

class NewCharacter extends CompositeView
  initialize: (options) =>
    this.delegateEvents {
      'click button[name=roll]': (e) =>
        e.preventDefault()
        this.rollAbilityScores()
        false
      'submit form': (e) =>
        e.preventDefault()
        this.createCharacter()
        false
    }

  render: =>
    @$el.modal('show')
    this

  remove: =>
    # since the contents of the view are rendered on the server side, don't clear out @$el
    # XXX: but do reset the form and abilities
    this.stopListening()
    this

  rollAbilityScores: =>
    console.log "rolling"
    for ability in ["str", "dex", "con", "int", "wis", "cha"]
      @$el.find("#character-new-#{ability}").html(Die.roll(4, 6, dropLowest: 1))

window.CharacterSelector.Views.NewCharacter = NewCharacter
