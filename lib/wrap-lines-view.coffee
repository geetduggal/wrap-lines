{View} = require 'atom'

module.exports =
class WrapLinesView extends View
  @content: ->
    @div class: 'wrap-lines overlay from-top', =>
      @div "The WrapLines package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "wrap-lines:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "WrapLinesView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
