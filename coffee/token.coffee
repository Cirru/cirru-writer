
class Token
  isExp: no
  isToken: yes
  constructor: (@text) ->

  format: (caret) ->
    if @text.match /[\w\d]+/
      caret.writeToken @text
    else
      caret.writeToken (JSON.stringify @text)

  formatInline: (caret) ->
    @format caret

exports.Token = Token