# Summary
# -----

# This is a API of post model

# Code
# -----

# 'use strict' always first :)

'use strict'

#### Dependencies

util = require 'util'
restify = require 'restify'
# require the mongoose initializer
mongo = require '../mongo'
# require the restify server.
server = require '../server'

#### Used Models
Post = mongo.model 'Post'

#### API

#### Index
server.get 'posts', (req, res, next) ->
  Post.find()
  .exec (err, posts) ->
    res.charSet 'utf-8'
    if err?
      next(new restify.InternalError('MongoDB failed.'))
    else
      res.send 200, posts
      next()

##### Get
server.get 'posts/:id', (req, res, next) ->
  Post.findById(req.params.id)
  .exec (err, posts) ->
    res.charSet 'utf-8'
    if err?
      next(new restify.InternalError('MongoDB failed.'))
    else if !posts?
      next(new restify.ResourceNotFoundError('Post not found.'))
    else
      res.send 200, posts
      next()

#### Post
server.post 'posts', (req, res, next) ->
  reqBody = ''
  req.setEncoding 'utf8'
  req.on 'data', (chunk) -> reqBody += chunk
  req.on 'end', ->
    try
      body = JSON.parse reqBody
      post = new Post(body)
    catch e
      next(new restify.InvalidArgumentError('The request body cannot be parsed as a legal JSON object.'))
    post.save (err) ->
      if err?
        next(new restify.InternalError('MongoDB failed.'))
      else
        res.send 201, post
        next()
