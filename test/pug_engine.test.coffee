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
templateManager = require '../src/TemplateManager'

describe 'Pug Engine Test Suite', ->
  _path = "#{__dirname}/compiled/template.js"
  tMan = new templateManager
  it 'should initialize', =>
    engine.init app, {}, (e, res)->
      console.log "initialized"
      console.log arguments
  it 'should process configs', =>
    out = tMan.processConfig 
      templates: "#{__dirname}/assets/templates/index.pug"
    out.should.contain 'index'
  it 'should process a templates directory', =>
    @compiled = tMan.processConfig 
      templates: "#{__dirname}/assets/templates"
    @compiled.should.contain 'page'
  it 'should save compiled templates to a file', (done)=>
    tMan.out = @compiled
    tMan.save _path, =>
      stat = fs.lstatSync _path
      expect(stat.isFile()).to.be.true
      done()
  after =>
    fs.unlinkSync _path
