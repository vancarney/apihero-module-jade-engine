{_}         = require 'lodash'
fs          = require 'fs-extra'
path        = require 'path'
router      = require 'apihero-module-jade-router'
browserify  = require 'apihero-module-browserify'

module.exports.browserify = browserify

module.exports.jade = {}
_.each router['jade'], (fun,param)=>
  module.exports.jade[param] = fun
  
module.exports.router = router
  
module.exports.init = (app,options,callback)->
  defaults =
    distDir: path.join app_root || process.cwd(), 'dist'
    buildDir: path.join app_root || process.cwd(), 'build'
    fileName: 'templates.js'
    templateDirectives:{}

  @options = _.extend {}, defaults, options
  
  router.init app, options, =>
    callback.apply @, arguments
    
  tMan = new TemplateManager
  
  app.once 'ahero-modules-loaded', =>
    out = "var jade = require('#{path.join __dirname, '..', 'node_modules', 'jade-runtime'}')"
    _.each (@configs = app.ApiHero.getModuleConfigs()), (config)=>
      out += tMan.processConfig config
    outFile = path.join @options.buildDir, @options.fileName
    fs.outputFile outFile, out, (e)=>
      try
        browserify.browserify outFile
        .bundle()
        .pipe fs.createWriteStream @options.distDir
      catch e
        console.log e
        return callback "unable to create template client"
      callback if e? then e else null
    # (loadedModules = _.keys @modules).splice idx, 1 if 0 <= (idx = loadedModules.indexOf path.basename module.id, '.js')
    # done = _.after loadedModules.length, =>
      # console.log 'done done done'
    # call done if no modules need loading
    # return done() unless loadedModules.length
    # @views = _.compact _.flatten _.map _.pluck _.values @modules, 'templates'
    # console.log @views
      
    
TemplateManager = require './TemplateManager'