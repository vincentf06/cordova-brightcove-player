var exec = require('cordova/exec');

exports.play = function(videoId, success, error) {
    exec(success, error, 'BrightcovePlayer', 'play', [videoId]);
};

exports.init = function(policyKey, accountId, success, error) {
    exec(success, error, 'BrightcovePlayer', 'initAccount', [policyKey, accountId])
};
