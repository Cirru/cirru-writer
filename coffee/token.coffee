
{Unit} = require './unit'

class Token extends Unit
  isExp: no
  isToken: yes
  constructor: (opts) ->
    @parent = opts.parent
    @text = opts.item
    @index = opts.index
    @caret = opts.caret

  make: ->
    if @text.match /^[\w\d-><\:\.\#\\\/\?]+$/
      @text
    else
      JSON.stringify @text

  format: ->
    @caret.token @make()

  formatHead: ->
    @format()

  makeHead: ->
    @make()

  column: ->
    str = @make()
    str += ' ' while str.length < 20
    str

  makeInline: ->
    @make()

exports.Token = Token