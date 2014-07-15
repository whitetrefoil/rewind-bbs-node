# Summary
# -----

# Load all models under `src/models`.
# All `.js`, `.coffee`, `.litcoffee` files will be required.
# But files in sub-directory will **NOT** be required.

# Code
# -----

# 'use strict' always first :)

'use strict'

#### Dependencies

mongoose = require 'mongoose'
fs = require 'fs'
path = require 'path'

# Scan the `src/models` directory, then load the models.

if fs.existsSync('src/models') and fs.statSync('src/models').isDirectory()
  fs.readdirSync('src/models').forEach (model) ->
    if path.extname(model).search /\.(?:js|coffee|litcoffee)/ >= 0
      require "./models/#{model}"

#### Exports

# There's no need to export anything.
# `mongoose` will handle all the required models.
