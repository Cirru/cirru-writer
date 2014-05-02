
exports.Caret = class
  constructor: ->
    @_buffer = '\n'
    @_indentation = ''
    @_needSeperator = no
    @

  indent: ->
    @_indentation += '  '
    @

  unindent: ->
    if @_indentation.length is 0
      throw new Error '[Cirru Writer] too many unindent'
    @_indentation = @_indentation[...-2]
    @

  newline: ->
    @_buffer += '\n'
    @_buffer += @_indentation
    @_needSeperator = no
    @

  _addSpace: ->
    @_buffer += ' '
    @_needSeperator = no
    @

  _addOpen: ->
    @_buffer += '\('
    @_needSeperator = no

  _addClose: ->
    @_buffer += '\)'
    @_needSeperator = yes

  _addToken: (text) ->
    @_buffer += text
    @_needSeperator = yes

  add: (text) ->
    if text is '\('
      @_addSpace() if @_needSeperator
      @_addOpen()
    else if text is '\)'
      @_addClose()
    else
      @_addSpace() if @_needSeperator
      @_addToken text

  get: ->
    @_buffer