# Summary
# -----

# This is an initializer of MongoDB (via mongoose).
# Must be required before any model.

# Code
# -----

# 'use strict' always first :)

'use strict'

#### Dependencies

# Use mongoose to manager MongoDB.

mongoose = require 'mongoose'
connection = mongoose.connect 'mongodb://localhost'

#### Exports

module.exports = connection
