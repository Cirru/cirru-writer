
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

  getLength: ->
    @list.length

  getFirst: ->
    @list[0]

  markIndented: ->
    @indented = yes

  makeInline: ->
    simpleJoin = (item) ->
      item.list.map (obj) ->
        if obj.isToken
          obj.make()
        else if item.isExp
          "(#{simpleJoin obj})"
      .join ' '
    simpleJoin @

  makeHead: ->
    "(#{@makeInline()})"

  # this is for debugging
  column: ->
    str = @makeInline()
    str += ' ' while str.length < 20
    str

  format: ->
    return if @getLength() is 0

    for item in @list
      if item.is 'token first'
        # console.log item.column(), 'token first'
        item.format()
        @caret.setState 'word'

      else if item.is 'exp last empty word'
        # console.log item.column(), 'exp last empty word'
        @caret.token '$'
        .setState 'word'

      else if item.is 'exp first'
        # console.log item.column(), 'exp first'
        @caret.token item.makeHead()
        .setState 'word'

      else if item.is 'exp empty word last'
        # console.log item.column(), 'exp empty word last'
        @caret.token '$'
        .setState 'word'

      else if item.is 'token word'
        # console.log item.column(), 'token word'
        @caret.token item.make()
        .setState 'word'

      else if item.is 'token block'
        # console.log item.column(), 'token block'
        @caret.newline()
        .token ','
        .token item.make()
        .setState 'word'

      else if item.is 'exp short last word'
        # console.log item.column(), 'exp short last word'
        @caret.token '$'
        item.getFirst().format()
        @caret.setState 'word'

      else if item.is 'exp short nested align'
        # console.log item.column(), 'exp short nested align'
        @markIndented()
        @caret.indent().newline().token '$'
        item.getFirst().format()
        @caret.setState 'block'

      else if item.is 'exp short nested indented'
        # console.log item.column(), 'exp short nested indented'
        @caret.newline().token '$'
        item.getFirst().format()
        @caret.setState 'block'

      else if item.is 'exp plain empty word'
        # console.log item.column(), 'exp plain empty word'
        @caret.token '()'
        .setState 'word'

      else if item.is 'exp plain empty block'
        # console.log item.column(), 'exp plain empty block'
        @caret.newline()
        .token ','
        .token '()'
        .setState 'word'

      else if item.is 'exp plain last word'
        # console.log item.column(), 'exp plain last word'
        @caret.token '$'
        .token item.makeInline()
        .setState 'word'

      else if item.is 'exp plain word'
        # console.log item.column(), 'exp plain word'
        @caret.token item.makeHead()
        .setState 'word'

      else if item.is 'exp plain block'
        # console.log item.column(), 'exp plain block'
        @caret.newline()
        .token item.makeInline()
        @caret.setState 'block'

      else if item.is 'exp nested align'
        # console.log item.column(), 'exp nested align'
        @markIndented()
        @caret.indent().newline()
        item.format()
        @caret.setState 'block'

      else if item.is 'exp nested indented'
        # console.log item.column(), 'exp nested indented'
        @caret.newline()
        item.format()
        @caret.setState 'block'

      else
        # console.log item.column(), '!!! is not recognized'
        throw new Error "[Cirru Writer] not considered: #{item}"

    @caret.unindent() if @indented

exports.Exp = Exp