var exec = require('cordova/exec');

exports.play = function(id, success, error) {
  exec(success, error, 'BrightcovePlayer', 'play', [id]);
};
