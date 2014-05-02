
class Caret
  constructor: ->
    @buffer = ''
    @indentation = ''
    @state = 'block'
    @

  indent: ->
    @indentation += '  '
    @

  unindent: ->
    @indentation = @indentation[...-2]
    @

  setState: (name) ->
    # Avialable: token, block
    @state = name
    @

  _add: (str) ->
    @buffer += str
    @

  newline: ->
    @_add('\n')
    ._add @indentation

  token: (text) ->
    lastChar = @buffer[@buffer.length - 1]
    if lastChar? and lastChar isnt ' '
      @_add ' '
    @_add text

exports.Caret = Caret