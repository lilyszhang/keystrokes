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
          @span class: 'keycount-menu-points', outlet: "pointcount", " 0 "
          @span class: 'keycount-menu-points', 'Brain Points:'
      @div outlet: 'keylist', class: 'panel-body padded'

  add: (keys) ->
    if keys == '#'
      atom.notifications.addSuccess "Great job thinking through the problem! +1"
      @points++

    if keys== 'cmd-i'
      atom.notifications.addWarning("Think about what your code will output before running it.")

    @count++
    @history = @history[-2..]
    @history.push keys
    @refresh()

  refresh: () ->
    p=@points
    @pointcount.html $$ ->
      @span class: 'keycount'," " + p
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
    @points = 0
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
