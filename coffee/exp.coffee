
{Token} = require './token'
{Unit} = require './unit'

exports.Exp = Exp = class extends Unit
  constructor: (opts) ->
    for key in ['parent', 'index', 'caret']
      @[key] = opts[key]

    @list = opts.item.map (item, index) =>
      AstNode =
        if (Array.isArray item) then Exp
        else Token
      new AstNode
        parent: @
        index: index
        item: item
        caret: @caret

    @isToken = no

    @_indented = no
    @_crowded = no
    @_newline = yes

  getLength: ->
    @list.length

  getFirst: ->
    @list[0]

  format: ->
    for item, index in @list
      if index is 0
        @getFirst().formatInline()
        @_newline = no
      else
        if @isLast index
          if @_newline
            @addNewline()
            if item.isToken
              @addComma()
              item.format()
            else
              item.format()
          else
            if item.isToken
              item.format()
            else
              @addDollar()
              item.format()
          return

        if @_newline
          @addNewline()
          if item.isToken
            @addComma()
            item.format()
          else
            item.format()
        else
          if item.isToken
            item.format()
          else
            if @_crowded
              @addNewline()
              item.format()
              @turnNewline()
            else
              if item.isSimple()
                @caret.add '\('
                item.format()
                @caret.add '\)'
                @_crowded = yes
              else
                @addNewline()
                item.format()
                @turnNewline()

    if @_indented then @caret.unindent()

  formatInline: ->
    @caret.add '\('
    item.formatInline() for item in @list
    @caret.add '\)'

  isSimple: ->
    @list.every (item) ->
      item.isToken and (item.getLength() < 16)

  isLast: (index) ->
    (index + 1) is @getLength()

  addNewline: ->
    if not @_indented
      @caret.indent()
      @_indented = yes
    @caret.newline()
    @_newline = yes
    @_crowded = off

  addComma: ->
    @caret.add ','
    @_newline = off
    @_crowded = off

  addDollar: ->
    @caret.add '$'
    @_newline = off
    @_crowded = off

  turnNewline: ->
    if not @_indented
      @caret.indent()
      @_indented = yes
    @_newline = yes
    @_crowded = yes
