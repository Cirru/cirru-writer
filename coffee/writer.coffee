
{Caret} = require './caret'
{Exp} = require './exp'

message = '[Cirru Writer] takesnesting arries'

exports.pretty = (data) ->
  throw new Error message unless Array.isArray data
  data
  .filter (x) ->
    x.length > 0

  .map (line) ->
    throw new Error message unless Array.isArray line
    exp = new Exp
      parent: null
      item: line
      index: null
      caret: new Caret

    exp.format()
    exp.caret.get()

  .join('\n')
