(function() {
  'use strict';
  var fs, mongoose, path;

  mongoose = require('mongoose');

  fs = require('fs');

  path = require('path');

  if (fs.existsSync('src/models') && fs.statSync('src/models').isDirectory()) {
    fs.readdirSync('src/models').forEach(function(model) {
      if (path.extname(model).search(/\.(?:js|coffee|litcoffee)/ >= 0)) {
        return require("./models/" + model);
      }
    });
  }

}).call(this);
