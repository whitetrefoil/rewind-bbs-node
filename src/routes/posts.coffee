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


#### Helpers

# Will be moved to separated file later.

readReq = (req, callback) ->
  reqBody = ''
  req.setEncoding 'utf8'
  req.on 'data', (chunk) -> reqBody += chunk
  req.on 'end', ->
    try
      body = JSON.parse reqBody
    catch e
      next(new restify.InvalidArgumentError('The request body cannot be parsed as a legal JSON object.'))
    callback(body)?


#### Used Models
Post = mongo.model 'Post'

#### API

#### Index
server.get 'posts', (req, res, next) ->
  Post.find()
  .exec (err, posts) ->
    if err?
      next(new restify.InternalError('MongoDB failed.'))
    else
      res.send 200, posts
      next()

##### Get
server.get 'posts/:id', (req, res, next) ->
  Post.findById(req.params.id)
  .exec (err, posts) ->
    if err?
      next(new restify.InternalError('MongoDB failed.'))
    else if !posts?
      next(new restify.ResourceNotFoundError('Post not found.'))
    else
      res.send 200, posts
      next()

#### Post
server.post 'posts', (req, res, next) ->
  readReq req, (body) ->
    post = new Post(body)
    post.save (err) ->
      if err?
        next(new restify.InternalError('MongoDB failed.'))
      else
        res.send 201, post
        next()

#### PUT
server.put 'posts/:id', (req, res, next) ->
  readReq req, (body) ->
    id = req.params.id
    Post.findById(id).exec (err, post) ->
      if err?
        next(new restify.InternalError('Failed to locate the post in MongoDB.'))
      else if !post?
        next(new restify.ResourceNotFoundError('Cannot find such post to update.'))
      else
        post.update(body).exec (err, numberAffected, raw) ->
          if err?
            next(new restify.InternalError('Failed to modify in MongoDB.'))
          else
            res.send 200, raw or post
            next()


#### Delete
server.del 'posts/:id', (req, res, next) ->
  id = req.params.id
  Post.findById(id).exec (err, post) ->
    if err?
      next(new restify.InternalError('Failed to remove from MongoDB.'))
    else if !post?
      next(new restify.ResourceNotFoundError('Cannot find such post to remove.'))
    else
      Post.remove({ _id: post.id }).exec (err) ->
        if err?
          next(new restify.InternalError('Failed to remove from MongoDB.'))
        else
          res.send 200, post
          next()
