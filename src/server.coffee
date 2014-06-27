# Summary
# -----

# This module is used to initialized the server (using restify)

# Code
# -----

# 'use strict' always first ;)
'use strict'

#### Dependencies

restify = require 'restify'

# Create the server here.
# Later I will add code to load config.

server = restify.createServer
  name: 'RewindBBS'

#### Exports

# Export a created but not started server instance.
module.exports = server
