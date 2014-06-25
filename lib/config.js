(function() {
  'use strict';
  var fs, getConfig, getDefaultConfigSync, readConfigFileSync;

  fs = require('fs-extra');

  readConfigFileSync = function(path) {
    return fs.readJsonSync(path);
  };

  getDefaultConfigSync = function() {
    return readConfigFileSync('config/config.default.json');
  };

  getConfig = function() {
    return getDefaultConfigSync();
  };

  module.exports = getConfig;

}).call(this);
