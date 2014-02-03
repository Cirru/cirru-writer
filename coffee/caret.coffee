
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

  addBuffer: (str) ->
    @buffer += str
    @

  newline: ->
    @addBuffer('\n')
    .addBuffer @indentation

  token: (text) ->
    lastChar = @buffer[@buffer.length - 1]
    if lastChar? and lastChar isnt ' '
      @addBuffer ' '
    @addBuffer text

exports.Caret = Caret