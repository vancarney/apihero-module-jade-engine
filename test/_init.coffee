EventEmitter = require 'events'

class MockApp extends EventEmitter
  listModules: -> []
  getModuleConfigs: ->
      [
        setting: 'blah'
      ]

global.app =
  set: ->
  get: -> true
  use: ->
  engine: -> {}
  once: (name, callback)->
    callback(null, true)
  ApiHero: new MockApp
