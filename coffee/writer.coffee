
class Token
  constructor: (text) ->

class Exp
  constructor: (list) ->

class Caret
  constructor: ->
    @buffer = ''
    @indentation = '  '

  indent: ->
    @indentation += '  '

  outdent: ->
    @indentation = @indentation[...-2]

  newline: ->
    @buffer += '\n'
    @buffer += @indentation

writer = (data) ->
  caret = new Caret

  data
  .map (line) ->
    line
  .join '\n\n'

if exports?
  exports.writer = writer