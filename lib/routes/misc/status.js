(function() {
  'use strict';
  var mongo, restify, util;

  util = require('util');

  mongo = require('../../mongo');

  restify = require('../../server');

  restify.get('misc/status', function(req, res, next) {
    res.charSet('utf-8');
    res.send(200, {
      server: true
    });
    return next();
  });

}).call(this);
