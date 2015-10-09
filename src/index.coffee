# Summary
# -----

# This is the main file of the application.

# Code
# -----

# 'use strict' always first :)

'use strict'

#### Dependencies

util = require 'util'
# require the mongoose initializer
mongo = require './mongo'
# require the mongoose lib
mongoose = require 'mongoose'
# require all models
require './models'
# require the restify server.
restify = require './server'
# require all routes.
require './routes/misc/status'
require './routes/posts'

#### Entrance

# The main function
index = ->
  restify.listen 2345
  util.log 'Restify started on port 2345'

  Post = mongoose.model 'Post'
  post = new Post
    summary: 'Test Post'
    content: 'This is just a test.'
    author: 'Fran'
  post.save()

#### Exports

# For the `bin/rewind-bbs-node` file.
module.exports = index

# If it's run by node directly...
if require.main is module
  index(process.argv)
