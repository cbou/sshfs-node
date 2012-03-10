(function() {
  var assert, fs, mountPoint, path, prefixPath, sshfs, suite, validHost, validUser, vows, wrench;

  assert = require('assert');

  vows = require('vows');

  sshfs = require('../index');

  path = require('path');

  fs = require('fs');

  wrench = require('wrench');

  suite = vows.describe('Try the sshfs library');

  validUser = 'ec2-user';

  validHost = 'big-bazar.fr';

  mountPoint = '/mountpoint-test';

  prefixPath = '/tmp/sshfs';

  if (!path.existsSync(prefixPath)) fs.mkdirSync(prefixPath);

  if (path.existsSync(prefixPath + mountPoint)) {
    wrench.rmdirSyncRecursive(prefixPath + mountPoint);
  }

  fs.mkdirSync(prefixPath + mountPoint);

  suite.addBatch({
    'when mounting a server': {
      topic: function() {
        sshfs.mount(validUser, validHost, prefixPath + mountPoint, this.callback);
      },
      'we got no error': function(err, arg2) {
        return assert.isNull(err);
      }
    }
  }).addBatch({
    'when waiting that everything is ok': {
      topic: function() {
        setTimeout(this.callback, 5000);
      },
      'we got no error': function() {
        return assert.isNull(null);
      }
    }
  }).addBatch({
    'when umounting a server': {
      topic: function() {
        sshfs.umount(prefixPath + mountPoint, this.callback);
      },
      'we got no error': function(err, arg2) {
        return assert.isNull(err);
      }
    }
  })["export"](module);

}).call(this);
