(function() {
  var exec, exports, fs, sshfs, util;

  exec = require('child_process').exec;

  util = require('util');

  fs = require('fs');

  sshfs = {};

  sshfs.mount = function(user, host, mountpoint, callback) {
    var command;
    command = util.format('sshfs -o StrictHostKeyChecking=no %s@%s:/ %s', user, host, mountpoint);
    return sshfs.exec(command, callback);
  };

  sshfs.umount = function(mountpoint, tryMax, callback) {
    var command;
    if (arguments.length === 3) {
      callback = arguments[2];
      tryMax = arguments[1];
    } else {
      callback = tryMax;
      tryMax = 10;
    }
    command = util.format('fusermount -u %s', mountpoint);
    return sshfs.exec(command, function(error, stdout, stderr) {
      if (error) {
        if (tryMax === 0) {
          callback('Try Max is reached');
        } else {
          setTimeout(function() {
            return sshfs.umount(mountpoint, tryMax - 1, callback);
          }, 1000);
        }
      } else {
        sshfs.log(['umounted ' + mountpoint]);
        callback(null);
      }
    });
  };

  sshfs.exec = function(command, callback) {
    var tryMax;
    tryMax = 10;
    sshfs.log(['Call command: ' + command]);
    return exec(command, function(error, stdout, stderr) {
      if (error) {
        sshfs.log([error, stdout, stderr]);
        return callback(error, stdout, stderr);
      } else {
        return callback(null);
      }
    });
  };

  sshfs.log = function(messages) {};

  exports = module.exports = sshfs;

}).call(this);
