(function() {
  'use strict';
  var mongo, restify, util;

  util = require('util');

  mongo = require('../mongo');

  restify = require('../server');

  restify.get('posts', function(req, res, next) {
    return mongo.model('Post').find().exec(function(err, posts) {
      res.charSet('utf-8');
      if (err != null) {
        res.send(500, {
          code: 500,
          message: 'MongoDB failed.'
        });
      } else {
        res.send(200, posts);
      }
      return next();
    });
  });

  restify.post('posts', function(req, res, next) {
    var reqBody;
    reqBody = '';
    req.setEncoding('utf8');
    req.on('data', function(chunk) {
      return reqBody += chunk;
    });
    return req.on('end', function() {
      var Post, body, e, post;
      try {
        body = JSON.parse(reqBody);
        Post = mongo.model('Post');
        post = new Post(body);
      } catch (_error) {
        e = _error;
        res.send(400, {
          code: 400,
          message: 'The request body cannot be parsed as a legal JSON object.',
          error: e.message
        });
        next();
      }
      return post.save(function(err) {
        if (err != null) {
          res.send(500, {
            code: 500,
            message: 'Failed to save into MongoDB.',
            error: err
          });
          return next();
        } else {
          res.send(201, post);
          return next();
        }
      });
    });
  });

}).call(this);
