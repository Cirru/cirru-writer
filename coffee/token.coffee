
{Unit} = require './unit'

tokenOnly = /^[^\s\(\)\$\,]+$/

exports.Token = class extends Unit

  constructor: (opts) ->
    for key in ['parent', 'index', 'caret']
      @[key] = opts[key]

    @text = opts.item

    @isToken = yes

  getLength: ->
    @text.length

  _make: ->
    if @text.match(tokenOnly)? then @text
    else JSON.stringify @text

  format: ->
    @caret.add @_make()

  formatInline: ->
    @format()
