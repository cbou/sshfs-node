(function() {
  var assert, fs, mountPoint, path, prefixPath, sshfs, suite, u, validHost, validUser, vows, wrench;

  assert = require('assert');

  vows = require('vows');

  sshfs = require('../index');

  path = require('path');

  fs = require('fs');

  wrench = require('wrench');

  u = require('underscore');

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
    'when reading mountedpoint': {
      topic: function() {
        fs.readdir(prefixPath + mountPoint, this.callback);
      },
      'we got no error': function(err, result) {
        assert.isNull(err);
        assert.isTrue(u.include(result, 'root'));
        assert.isTrue(u.include(result, 'etc'));
        return assert.isTrue(u.include(result, 'home'));
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
