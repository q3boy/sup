#mocha
e = require 'expect.js'

describe 'Argument Parser', ->
  parser = require '../lib/args'
  it 'default value', ->
    e(parser []).to.eql port : 8080, list : false, dir : process.cwd()
  it 'set port', ->
    e(parser ['-p', '81']).to.have.property 'port', 81
  it 'use list', ->
    e(parser ['-l']).to.have.property 'list', true
  it 'set dir', ->
    e(parser ['abc']).to.have.property 'dir', 'abc'
