# 'use strict' always first :)

'use strict'

# Require the external dependencies.

fs = require 'fs-extra'
_ = require 'lodash'

# Main functions
# -----

# Get configurations by loading a config file.

readConfigFileSync = (path) ->
  try
    fs.readJsonSync path
  catch e
    {}

# Get default config.

getDefaultConfigSync = () ->
  readConfigFileSync '../config/config.default.json'


# Main function, get all possible config files then combine the config.

getConfig = ->
  defaultConfig = getDefaultConfigSync()
  userConfig = readConfigFileSync(process.argv[2]) || readConfigFileSync('config.json')
  config = _.defaults userConfig, defaultConfig
  console.log config

module.exports = getConfig
