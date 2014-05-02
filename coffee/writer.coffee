
{Caret} = require './caret'
{Exp} = require './exp'

message = '[Cirru Writer] takesnesting arries'

exports.pretty = (data) ->
  throw new Error message unless Array.isArray data
  ret = data.map (line) ->
    throw new Error message unless Array.isArray line
    caret = new Caret
    exp = new Exp
      parent: null
      item: line
      index: null
      caret: caret

    exp.format()
    caret.buffer
  .join('\n')

  return "\n#{ret}"