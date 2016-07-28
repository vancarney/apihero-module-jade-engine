EventEmitter = require 'events'

class MockApp extends EventEmitter
  getModuleConfigs: ->
      confog =
        setting: 'blah'

global.app = 
  ApiHero: new MockApp
