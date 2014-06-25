(function() {
  'use strict';
  var fs, getConfig;

  fs = require('fs-extra');

  getConfig = function(path, callback) {
    return fs.readJson(path, function(err, json) {
      if (err == null) {
        return typeof callback === "function" ? callback(json) : void 0;
      }
    });
  };

  module.exports = getConfig;

}).call(this);
