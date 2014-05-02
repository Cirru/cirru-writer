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

make = (file) ->
  ast = require "./ast/#{file}.json"
  (pretty ast).to "./cirru/#{file}.cirru"

target.test = ->
  make file for file in names

target.run = ->
  make 'spaces'

target.compile = ->
  exec 'coffee -o src/ -bc coffee'