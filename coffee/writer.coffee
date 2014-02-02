
{Caret} = require './caret'
{Token} = require './token'
{Exp} = require './exp'

writer = (data) ->
  data
  .map (line) ->
    caret = new Caret
    exp = new Exp line
    
    exp.format caret
    caret.buffer
  .join '\n\n'

if exports?
  exports.writer = writer