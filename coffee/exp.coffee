
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
        if item.isEmpty()
          caret.writeLeftParen()
          caret.writeRightParen()
        else if item.isPlain()
          caret.indent()
          caret.newline()
          item.format caret
          caret.outdent()
        else
          item.formatBlock caret
      else if item.isToken
        item.format caret

  formatBlock: (caret) ->
    caret.indent()
    caret.newline()
    @format caret
    caret.outdent()

  isNested: ->
    if @list.length is 0
      return no
    else
      @list.some (item) ->
        item.isExp

  isPlain: ->
    not @isNested()

  isEmpty: ->
    @list.length is 0

exports.Exp = Exp