fs              = require 'fs-extra'
{_}             = require 'lodash'
path            = require 'path'
{EventEmitter}  = require 'events'
jade            = module.parent.exports.jade.jade
class TemplateManager extends EventEmitter
  'use strict'
  dependencies:{}
  constructor:->
  processConfig:(config)->
    @out   = ''
    getTemplate = (template)=>
      if template.match /\.[a-z]*$/i
        @root = "#{path.dirname template}#{path.sep}"
        t = @processTemplate template
      else
        @root = "#{template}#{path.sep}"
        t = @compileDirectory template
      "\n\n#{t}"
    if config.templates?
      switch typeof config.templates
        when 'string'
          @out += getTemplate config.templates
        when 'object'
          _.each config.templates, (t)=> 
            @out += getTemplate t
        else
          console.log "config.templates was unprocessable"
    @out
  processTemplate: (fileName,opts={})->
    options = _.extend {filename: path.join path.dirname(fileName), path.basename fileName}, opts
    refName = (options.filename.replace @root, '').split('.')[0]
    # @dependencies[refName] ?= []
    try
      # inputString = fs.readFileSync fileName, 'utf8'
      # jade.compileWithDependenciesTracked inputString, options
      result = jade.compileFileClient fileName, options
    catch e
      return @emit 'error', e
      
    # append sdependencies for this file to dependencies hash element
    # @dependencies[refName] = @dependencies[refName].concat result.dependencies
    result = result.replace /^(function)\stemplate/, '$1'

    # return module exports entry for template function
    "module.exports['#{refName}'] = #{result};"

  compileDirectory: (dir)->
    files = fs.readdirSync dir
    out   = ''
    for file in files
      try
        stat = fs.statSync _path = path.join dir, file
      catch e
        console.log "unable to stat file: #{_path}"
        continue
      out += if stat.isFile() then "\n\n#{@processTemplate _path}" else @compileDirectory path.join dir, file
    out
  save:(path, callback)->
    fs.writeFile path, @out, callback 
module.exports = TemplateManager