
class Caret
  constructor: ->
    @buffer = ''
    @indentation = ''
    @state = 'block'
    @

  indent: ->
    @indentation += '  '
    @

  outdent: ->
    @indentation = @indentation[...-2]
    @

  setState: (name) ->
    # Avialable states:
    # newline, token, dollar, leftParen, rightParen
    @state = name
    @

  addBuffer: (str) ->
    @buffer += str
    @

  newline: ->
    @addBuffer('\n')
    .addBuffer @indentation

  writeToken: (text) ->
    if @state is 'token'
      if @buffer[-1..-1][0] isnt ' '
        @addBuffer ' '
    @addBuffer text

  addSpace: ->
    @addBuffer ' '

exports.Caret = Caret