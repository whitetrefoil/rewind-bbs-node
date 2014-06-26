(function() {
  'use strict';
  var index, mongo, mongoose,
    __slice = [].slice;

  mongo = require('./mongo');

  mongoose = require('mongoose');

  require('./models');

  index = function() {
    var Post, post;
    Post = mongoose.model('Post');
    post = new Post({
      summary: 'Test Post',
      content: 'This is just a test.',
      author: 'Fran'
    });
    return post.save(function() {
      return Post.find().exec(function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        console.log(args);
        return mongo.disconnect();
      });
    });
  };

  module.exports = index;

  if (require.main === module) {
    index(process.argv);
  }

}).call(this);
