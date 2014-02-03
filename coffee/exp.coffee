
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
      new (if Array.isArray item then Exp else Token)
        parent: @, index: index, item: item, caret: @caret

    @indented = no

  len: ->
    @list.length

  getFirst: ->
    @list[0]

  makeInline: ->
    simpleJoin = (item) ->
      if item.isToken
        item.text
      else if item.isExp
        result = item.list.map (obj) ->
          simpleJoin obj
        .join ' '
        "(#{result})"
    simpleJoin @

  makeHead: ->
    "(#{@makeInline()})"

  column: ->
    str = @makeInline()
    str += ' ' while str.length < 20
    str

  format: ->
    return if @len() is 0
    @indented = no

    for item in @list then switch

      when item.is 'token first'
        console.log item.column(), 'exp first'
        item.format()
        @caret.setState 'word'

      when item.is 'exp first'
        console.log item.column(), 'exp first'
        @caret.token item.makeHead()
        .setState 'word'

      when item.is 'exp empty word last'
        console.log item.column(), 'exp empty'
        @caret.token '$'
        @caret.setState 'word'

      when item.is 'token word'
        console.log item.column(), 'token word'
        @caret.token item.text
        @caret.setState 'word'

      when item.is 'token block'
        console.log item.column(), 'token block'
        @caret.newline()
        .token ','
        .token item.text
        .setState 'word'

      when item.is 'exp short last indented'
        console.log item.column(), 'exp short last indented'
        @caret.newline()
        .token '$'
        .token item.getFirst().format()
        @caret.setState 'word'

      when item.is 'exp short nested align'
        console.log item.column(), 'exp short nested align'
        @caret.token '$'
        item.getFirst().format()
        @caret.setState 'block'

      when item.is 'exp plain empty word'
        console.log item.column(), 'exp plain empty word'
        @caret.token '()'
        .setState 'word'

      when item.is 'exp plain empty block'
        console.log item.column(), 'exp plain empty block'
        @caret.newline()
        .token ','
        .token '()'
        .setState 'word'

      when item.is 'exp plain word'
        console.log item.column(), 'exp plain word'
        @caret.token item.makeHead()
        .setState 'word'

      when item.is 'exp plain block'
        console.log item.column(), 'exp plain block'
        @caret.newline()
        .token ','
        item.format()
        @caret.setState 'block'

      when item.is 'exp nested align'
        console.log item.column(), 'exp nested align'
        @indented = yes
        @caret.indent().newline()
        item.format()
        @caret.setState 'block'

      when item.is 'exp nested indented'
        console.log item.column(), 'exp nested indented'
        @caret.newline()
        item.format()
        @caret.setState 'block'

      else
        console.log item.column(), '!!! is not recognized'

    @caret.unindent() if @indented

exports.Exp = Exp