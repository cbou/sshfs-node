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

  sshfs.umount = function(mountpoint, callback) {
    var command;
    command = util.format('fusermount -u %s', mountpoint);
    return sshfs.exec(command, callback);
  };

  sshfs.exec = function(command, callback) {
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
