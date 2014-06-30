(function() {
  'use strict';
  var Post, mongo, restify, server, util;

  util = require('util');

  restify = require('restify');

  mongo = require('../mongo');

  server = require('../server');

  Post = mongo.model('Post');

  server.get('posts', function(req, res, next) {
    return Post.find().exec(function(err, posts) {
      res.charSet('utf-8');
      if (err != null) {
        return next(new restify.InternalError('MongoDB failed.'));
      } else {
        res.send(200, posts);
        return next();
      }
    });
  });

  server.get('posts/:id', function(req, res, next) {
    return Post.findById(req.params.id).exec(function(err, posts) {
      res.charSet('utf-8');
      if (err != null) {
        return next(new restify.InternalError('MongoDB failed.'));
      } else if (posts == null) {
        return next(new restify.ResourceNotFoundError('Post not found.'));
      } else {
        res.send(200, posts);
        return next();
      }
    });
  });

  server.post('posts', function(req, res, next) {
    var reqBody;
    reqBody = '';
    req.setEncoding('utf8');
    req.on('data', function(chunk) {
      return reqBody += chunk;
    });
    return req.on('end', function() {
      var body, e, post;
      try {
        body = JSON.parse(reqBody);
        post = new Post(body);
      } catch (_error) {
        e = _error;
        next(new restify.InvalidArgumentError('The request body cannot be parsed as a legal JSON object.'));
      }
      return post.save(function(err) {
        if (err != null) {
          return next(new restify.InternalError('MongoDB failed.'));
        } else {
          res.send(201, post);
          return next();
        }
      });
    });
  });

  server.del('posts/:id', function(req, res, next) {
    var id;
    id = req.params.id;
    return Post.findById(id).exec(function(err, post) {
      if (err != null) {
        return next(new restify.InternalError('Failed to remove from MongoDB.'));
      } else if (post == null) {
        return next(new restify.ResourceNotFoundError('Cannot find such document to remove.'));
      } else {
        return Post.remove({
          _id: post.id
        }).exec(function(err) {
          if (err != null) {
            return next(new restify.InternalError('Failed to remove from MongoDB.'));
          } else {
            res.send(200, post);
            return next();
          }
        });
      }
    });
  });

}).call(this);
