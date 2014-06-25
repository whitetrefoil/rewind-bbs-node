# 'use strict' always first :)

'use strict'

# Require the external dependencies.

fs = require 'fs-extra'

# Main functions
# -----

# Get configurations by loading a config file.

getConfig = (path, callback) ->
  fs.readJson path, (err, json) ->
    callback?(json) unless err?


module.exports = getConfig
