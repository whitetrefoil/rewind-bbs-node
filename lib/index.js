(function() {
  'use strict';
  var index, mongo, mongoose;

  mongo = require('./mongo');

  mongoose = require('mongoose');

  require('./models');

  index = function() {
    console.log(mongoose.models);
    return mongo.disconnect();
  };

  module.exports = index;

  if (require.main === module) {
    index(process.argv);
  }

}).call(this);
