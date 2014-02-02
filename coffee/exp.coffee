
{Token} = require './token'
{Unit} = require './unit'

class Exp extends Unit
  isExp: yes
  isToken: no
  constructor: (opts) ->
    @parent = opts.parent
    @index = opts.index
    @caret = opts.caret
    @list = opts.item.map (item, index) =>
      info =
        parent: @
        index: index
        item: item
        caret: @caret
      if Array.isArray item
        new Exp info
      else
        new Token info

  formatInline: ->
    @caret.writeLeftParen()
    @list.forEach (item) =>
      item.formatInline()
    @caret.writeRightParen()

  format: ->
    return if @len() is 0
    [head, body...] = @list
    head.formatInline()
    indented = no
    body.forEach (item) =>
      if item.isExp
        console.log item.list
        if item.isEmpty()
          @caret.newline().writeDollar()
        else if item.isShort() and item.isLast()
          @caret.newline().writeDollar()
          item.getItem(0).format()
        else if item.isPlain()
          indented = yes
          @caret.indent().newline()
          item.format()
        else
          indented = yes
          @caret.indent().newline()
          item.format()
      else if item.isToken
        item.format()
    @caret.outdent() if indented

  isNested: ->
    if @isEmpty()
      return no
    else
      @list.some (item) ->
        item.isExp

  isPlain: ->
    not @isNested()

  isEmpty: ->
    @len() is 0

  isShort: ->
    @len() is 1

  len: ->
    @list.length

  getItem: (index) ->
    @list[index]

exports.Exp = Exp