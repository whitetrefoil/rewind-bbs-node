(function() {
  'use strict';
  var index;

  index = function() {
    return console.log('GO!');
  };

  module.exports = index;

  if (require.main === module) {
    index(process.argv);
  }

}).call(this);
