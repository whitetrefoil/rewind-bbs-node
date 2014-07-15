(function() {
  'use strict';
  var Post, mongo, readReq, restify, server, util;

  util = require('util');

  restify = require('restify');

  mongo = require('../mongo');

  server = require('../server');

  readReq = function(req, next, callback) {
    var reqBody;
    reqBody = '';
    req.setEncoding('utf8');
    req.on('data', function(chunk) {
      return reqBody += chunk;
    });
    return req.on('end', function() {
      var body, e;
      try {
        body = JSON.parse(reqBody);
        if (typeof body !== 'object') {
          throw new TypeError();
        }
      } catch (_error) {
        e = _error;
        next(new restify.InvalidContentError('The request body cannot be parsed as a legal JSON object.'));
        return;
      }
      return callback(body) != null;
    });
  };

  Post = mongo.model('Post');

  server.get('posts', function(req, res, next) {
    return Post.find().exec(function(err, posts) {
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
    return readReq(req, next, function(body) {
      var post;
      post = new Post(body);
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

  server.put('posts/:id', function(req, res, next) {
    return readReq(req, next, function(body) {
      var id;
      id = req.params.id;
      return Post.findById(id).exec(function(err, post) {
        if (err != null) {
          return next(new restify.InternalError('Failed to locate the post in MongoDB.'));
        } else if (post == null) {
          return next(new restify.ResourceNotFoundError('Cannot find such post to update.'));
        } else {
          return post.update(body).exec(function(err, numberAffected, raw) {
            if (err != null) {
              return next(new restify.InternalError('Failed to modify in MongoDB.'));
            } else {
              res.send(200, raw || post);
              return next();
            }
          });
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
        return next(new restify.ResourceNotFoundError('Cannot find such post to remove.'));
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
