
class Caret
  constructor: ->
    @buffer = ''
    @indentation = '  '
    @state = 'initial'

  indent: ->
    @indentation += '  '

  outdent: ->
    @indentation = @indentation[...-2]

  newline: ->
    @buffer += '\n'
    @buffer += @indentation

  writeToken: (text) ->
    switch @state
      when 'token'
        @buffer += ' '
      when 'rightParen'
        @buffer += ' '
      when 'block'
        @newline()
        @buffer += ', '
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