{_}             = require 'lodash'
fs              = require 'fs'
path            = require 'path'
{should,expect} = require 'chai'
global._        = _
global.should   = should
global.expect   = expect
global.app_root = __dirname
should()

engine = require '../src/apihero-module-pug-engine'

describe 'Pug Engine Test Suite', ->
  it 'should initialize', (done)=>
    engine.init app, {}, (e, res)->
      console.log "initialized"
      console.log arguments
      done()
    
