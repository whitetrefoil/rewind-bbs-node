# Summary
# -----

# This is the main file of the application.

# Code
# -----

# 'use strict' always first :)

'use strict'

#### Dependencies

# require the mongoose initializer
mongo = require './mongo'
# require the mongoose lib
mongoose = require 'mongoose'
# require all models
require './models'

#### Entrance

# The main function
index = ->
  console.log mongoose.models
  mongo.disconnect()

#### Exports

# For the `bin/rewind-bbs-node` file.
module.exports = index

# If it's run by node directly...
if require.main is module
  index(process.argv)
