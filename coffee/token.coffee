
{Unit} = require './unit'

class Token extends Unit
  isExp: no
  isToken: yes
  constructor: (opts) ->
    @parent = opts.parent
    @text = opts.item
    @index = opts.index
    @caret = opts.caret

  format: ->
    if @text.match /^[\w\d-><]+$/
      @caret.writeToken @text
    else
      @caret.writeToken (JSON.stringify @text)
    @caret.setState 'token'

exports.Token = Token