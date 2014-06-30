# Summary
# -----

# This is a API of post model

# Code
# -----

# 'use strict' always first :)

'use strict'

#### Dependencies

util = require 'util'
# require the mongoose initializer
mongo = require '../mongo'
# require the restify server.
restify = require '../server'

#### API

restify.get 'posts', (req, res, next) ->
  model = mongo.model 'Post'
  model.find()
  .exec (err, posts) ->
    res.charSet 'utf-8'
    if err?
      res.send 500,
        code: 500
        message: 'MongoDB failed.'
    else
      res.send 200, posts
    next()

restify.get 'posts/:id', (req, res, next) ->
  model = mongo.model 'Post'
  model.findById(req.params.id)
  .exec (err, posts) ->
    res.charSet 'utf-8'
    if err?
      res.send 500,
        code: 500
        message: 'MongoDB failed.'
        error: err
    else if !posts?
      res.send 404,
        code: 404
    else
      res.send 200, posts
    next()

##### Post
restify.post 'posts',  (req, res, next) ->
  reqBody = ''
  req.setEncoding 'utf8'
  req.on 'data', (chunk) -> reqBody += chunk
  req.on 'end', ->
    try
      body = JSON.parse reqBody
      Post = mongo.model('Post')
      post = new Post(body)
    catch e
      res.send 400,
        code: 400
        message: 'The request body cannot be parsed as a legal JSON object.'
        error: e.message
      next()
    post.save (err) ->
      if err?
        res.send 500,
          code: 500
          message: 'Failed to save into MongoDB.'
          error: err
        next()
      else
        res.send 201, post
        next()
