
class Caret
  constructor: ->
    @buffer = ''
    @indentation = ''
    @state = 'initial'

  indent: ->
    @indentation += '  '
    @state = 'indent'

  outdent: ->
    @indentation = @indentation[...-2]
    @state = 'outdent'

  newline: ->
    @buffer += '\n'
    @buffer += @indentation
    @state = 'newline'

  writeToken: (text) ->
    switch @state
      when 'token'
        @buffer += ' '
      when 'rightParen'
        @buffer += ' '
      when 'outdent'
        @indent()
        @newline()
        @outdent()
        @buffer += ', '
        @state = 'newline'
    @buffer += text
    @state = 'token'

  writeLeftParen: ->
    switch @state
      when 'rightParen'
        @buffer += ' '
      when 'token'
        @buffer += ' '
    @buffer += '('
    @state = 'leftParen'

  writeRightParen: ->
    @buffer += ')'
    @state = 'rightParen'

exports.Caret = Caret