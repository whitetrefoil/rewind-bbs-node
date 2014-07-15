(function() {
  'use strict';
  var restify, server;

  restify = require('restify');

  server = restify.createServer({
    name: 'RewindBBS'
  });

  server.use(function(req, res, next) {
    res.charSet('utf-8');
    return next();
  });

  module.exports = server;

}).call(this);
