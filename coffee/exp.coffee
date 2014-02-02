
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

  makeInline: ->
    simpleJoin = (item) ->
      if item.isToken
        item.text
      else if item.isExp
        item.list.map simpleJoin
        .join ' '
    simpleJoin @

  formatInline: ->
    @caret.writeToken @makeInline()
    @caret.setState 'token'

  formatHead: ->
    @caret.writeToken "(#{@makeInline()})"
    @caret.setState 'token'

  format: ->
    return if @len() is 0
    [head, body...] = @list
    if head.isExp
      head.formatHead()
    else
      head.format()
    indented = no

    body.forEach (item) =>
      if item.isExp
        if item.isPlain()
          if indented
            @caret.newline()
            item.formatInline()
          else
            item.formatHead()
        else
          indented = yes
          @caret.indent().newline()
          item.format()
          @caret.setState 'block'
      else if item.isToken
        if indented and @caret.state is 'block'
          @caret.newline()
          .writeToken ','
          @caret.setState 'token'
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

exports.Exp = Exp