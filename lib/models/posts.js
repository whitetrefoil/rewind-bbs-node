(function() {
  'use strict';
  var mongoose, postSchema;

  mongoose = require('mongoose');

  postSchema = new mongoose.Schema({
    summary: String,
    content: String,
    author: String
  });

  postSchema.set('toJSON', {
    getters: true,
    virtuals: true,
    transform: function(doc, ret) {
      ret.id = ret._id;
      delete ret._id;
      delete ret.__v;
      return ret;
    }
  });

  mongoose.model('Post', postSchema);

}).call(this);
