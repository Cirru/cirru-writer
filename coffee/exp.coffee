
{Token} = require './token'

class Exp
  isExp: yes
  isToken: no
  constructor: (line) ->
    @list = line.map (item) ->
      if Array.isArray item
        new Exp item
      else
        new Token item

  formatInline: (caret) ->
    caret.writeLeftParen()
    @list.forEach (item) ->
      item.formatInline caret
    caret.writeRightParen()

  format: (caret) ->
    [head, body...] = @list
    head.formatInline caret
    body.forEach (item) ->
      if item.isExp
        if item.isPlain()
          item.formatInline caret
        else
          item.formatBlock caret
      else if item.isToken
        item.format caret

  formatBlock: (caret) ->
    caret.newline()
    caret.indent()
    @format caret
    caret.state = 'block'
    caret.outdent()

  isNested: ->
    if @list.length is 0
      return false
    else
      @list.some (item) ->
        item.isExp

  isPlain: ->
    not @isNested()

exports.Exp = Exp