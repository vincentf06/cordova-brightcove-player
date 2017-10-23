var exec = require('cordova/exec');

exports.play = function(id, success, error) {
    exec(success, error, 'BrightcovePlayer', 'play', [videoId]);
};

exports.init = function(token, success, error) {
    exec(sucess, error, 'BrightcovePlayer', 'initAccount', [token, accountId])
};
