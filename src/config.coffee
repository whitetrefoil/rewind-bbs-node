# 'use strict' always first :)

'use strict'

# Require the external dependencies.

fs = require 'fs-extra'

# Main functions
# -----

# Get configurations by loading a config file.

readConfigFileSync = (path) -> fs.readJsonSync path

# Get default config.

getDefaultConfigSync = () ->
  readConfigFileSync 'config/config.default.json'


# Main function, get all possible config files then combine the config.

getConfig = ->
  getDefaultConfigSync()
  # TODO

module.exports = getConfig
