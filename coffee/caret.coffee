
class Caret
  constructor: ->
    @buffer = ''
    @indentation = ''
    @state = undefined
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
    @addBuffer('\n').addBuffer(@indentation)
    @setState 'newline'

  writeToken: (text) ->
    switch @state
      when 'dollar', 'rightParen', 'token'
        @addBuffer ' '
      when 'newline'
        @addBuffer(', ').setState 'newline'
    @addBuffer(text).setState 'token'

  writeLeftParen: ->
    switch @state
      when 'dollar', 'rightParen', 'token'
        @addSpace()
    @addBuffer('(').setState 'leftParen'

  writeRightParen: ->
    @addBuffer(')').setState 'rightParen'

  writeDollar: ->
    switch @state
      when 'dollar', 'rightParen', 'token'
        @addSpace()
    @addBuffer('$').setState 'dollar'

  addSpace: ->
    @addBuffer ' '

exports.Caret = Caret