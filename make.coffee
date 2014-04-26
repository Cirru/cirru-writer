
require 'shelljs/make'

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
  'spaces'
]

test = (file) ->
  codefile = "./cirru/#{file}.cirru"
  jsonfile = "./cirru/#{file}.json"

  data = require jsonfile
  console.log data
  cirru = generate data
  # console.log cirru
  fs.writeFileSync codefile, cirru, 'utf8'

target.test = ->
  names.forEach test

target.run = ->
  test 'spaces'

target.compile = ->
  exec 'coffee -o src/ -bc coffee'