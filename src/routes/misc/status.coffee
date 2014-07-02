# Summary
# -----

# This is a API to tell the status of server.

# Code
# -----

# 'use strict' always first :)

'use strict'

#### Dependencies

util = require 'util'
# require the mongoose initializer
mongo = require '../../mongo'
# require the restify server.
restify = require '../../server'

#### API

restify.get 'misc/status', (req, res, next) ->
  res.charSet 'utf-8'
  res.send 200,
    server: true
  next()
