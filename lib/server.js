(function() {
  'use strict';
  var restify, server;

  restify = require('restify');

  server = restify.createServer({
    name: 'RewindBBS'
  });

  module.exports = server;

}).call(this);
