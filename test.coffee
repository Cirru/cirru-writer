
fs = require 'fs'
{writer} = require './coffee/writer'

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
  cirru = writer data
  console.log cirru
  fs.writeFileSync codefile, cirru, 'utf8'

test 'unfolding'