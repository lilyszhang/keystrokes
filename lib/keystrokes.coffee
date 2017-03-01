module.exports = # Keycount =
  keystrokesView: null

  activate: ({attached}={}) ->
    @createView().toggle() if attached
    atom.commands.add 'atom-workspace',
      'keycount:toggle': => @createView().toggle()
      'core:cancel': => @createView().detach()
      'core:close': => @createView().detach()

  createView: ->
    unless @keystrokesView?
      KeystrokesView = require './keystrokes-view'
      @keystrokesView = new KeystrokesView()
    @keystrokesView

  deactivate: ->
    @keystrokesView?.destroy()

  serialize: ->
    @keystrokesView?.serialize()
