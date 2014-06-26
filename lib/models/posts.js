(function() {
  'use strict';
  var mongoose, postSchema;

  mongoose = require('mongoose');

  postSchema = new mongoose.Schema({
    summary: String,
    content: String,
    author: String
  });

  mongoose.model('Post', postSchema);

}).call(this);
