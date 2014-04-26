
fs = require 'fs'
{generate} = require './coffee/writer'

names = [
  'demo'
  'folding'
  'indent'
  'line'
  'parentheses'
  'quote'
  'unfolding'
]

test = (file) ->
  codefile = "./cirru/#{file}.cirru"
  jsonfile = "./cirru/#{file}.json"

  data = require jsonfile
  console.log data
  cirru = generate data
  # console.log cirru
  fs.writeFileSync codefile, cirru, 'utf8'

names.forEach test
test 'demo'