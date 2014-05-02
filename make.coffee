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
  wanted = cat "./cirru/#{file}.cirru"
  got = pretty ast
  if wanted.trim() is got.trim()
    console.log "ok! right for: #{file}"
  else
    console.log ''
    console.log "failed! file {#{file}} not match:"
    console.log got

target.test = ->
  make file for file in names

target.run = ->
  make 'demo'

target.compile = ->
  exec 'coffee -o src/ -bc coffee'
  console.log 'done: compiled to src/'