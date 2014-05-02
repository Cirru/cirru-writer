#!/usr/bin/env coffee

require 'shelljs/make'

fs = require 'fs'
{pretty} = require './coffee/writer'

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
  cirru = pretty data
  # console.log cirru
  fs.writeFileSync codefile, cirru, 'utf8'

target.test = ->
  names.forEach test

target.run = ->
  test 'spaces'

target.compile = ->
  exec 'coffee -o src/ -bc coffee'