(function() {
  'use strict';
  var index, mongo, mongoose, restify, util;

  util = require('util');

  mongo = require('./mongo');

  mongoose = require('mongoose');

  require('./models');

  restify = require('./server');

  require('./routes/misc/status');

  require('./routes/posts');

  index = function() {
    restify.listen(2345);
    return util.log('Restify started on port 2345');
  };


  /*
    Post = mongoose.model 'Post'
    post = new Post
      summary: 'Test Post'
      content: 'This is just a test.'
      author: 'Fran'
    post.save ->
      Post.find().exec (args...) ->
        console.log args
        mongo.disconnect()
   */

  module.exports = index;

  if (require.main === module) {
    index(process.argv);
  }

}).call(this);
