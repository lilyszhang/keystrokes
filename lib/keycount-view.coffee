{Disposable, CompositeDisposable} = require 'atom'
{$$, View} = require 'atom-space-pen-views'

module.exports =
class KeycountView extends View
  @content: ->
    @div class: 'key-count-resolver', =>
      @div class: 'panel-heading padded', =>
        @div class: 'block', =>
          @span class: 'keycount-menu', 'Currently Recording Keystrokes'
          @button class: 'inline-block-tight stop', "Stop Recording"
      @div outlet: 'keylist', class: 'panel-body padded'

  add: (keys) ->
    if keys == '#'
      atom.notifications.addSuccess "Great job thinking through the problem!" + keys

    @count++
    @history = @history[-2..]
    @history.push keys
    @refresh()

  refresh: () ->
    c = @count
    history = @history
    time = Date.now()
    fs = require 'fs'
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    directory = file?.getParent()
    dirPath = directory?.path
    fs.appendFile dirPath + '/keystrokes.csv', time + ',' + history[-1..] + '\n'

  initialize: ->
    @count = 0
    @history = []
    @on 'click', '.stop', ({target}) => @detach()

  # Tear down any state and detach
  destroy: ->

  serialize: ->
    attached: @panel?.isVisible()

  toggle: ->
    if @panel?.isVisible()
      @detach()
    else
      @attach()
      @time = Date.now()

  reset: ->
    @count = 0
    @history = []
    @refresh()

  attach: ->
    @disposables = new CompositeDisposable

    @panel = atom.workspace.addBottomPanel(item: this)
    @disposables.add new Disposable =>
      @panel.destroy()
      @panel = null

    @disposables.add atom.keymaps.onDidMatchBinding ({keystrokes, binding, keyboardEventTarget}) =>
      @update(keystrokes)

    @disposables.add atom.keymaps.onDidPartiallyMatchBindings ({keystrokes, partiallyMatchedBindings, keyboardEventTarget}) =>
      @update(keystrokes)

    @disposables.add atom.keymaps.onDidFailToMatchBinding ({keystrokes, keyboardEventTarget}) =>
      @update(keystrokes)

  detach: ->
    @disposables?.dispose()

  update: (keystrokes) ->
    if (keystrokes[0] != '^')
      @add keystrokes
