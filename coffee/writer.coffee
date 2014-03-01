
{Caret} = require './caret'
{Token} = require './token'
{Exp} = require './exp'

generate = (data) ->
  data
  .map (line) ->
    caret = new Caret
    exp = new Exp
      parent: null
      item: line
      index: null
      caret: caret
    
    exp.format()
    caret.buffer
  .join '\n\n'

if exports?
  exports.generate = generate