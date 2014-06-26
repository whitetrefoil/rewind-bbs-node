(function() {
  'use strict';
  var connection, mongoose;

  mongoose = require('mongoose');

  connection = mongoose.connect('mongodb://localhost');

  module.exports = connection;

}).call(this);
