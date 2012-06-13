assert = require 'assert'
vows = require 'vows'
sshfs = require '../index'
path = require 'path'
fs = require 'fs'
wrench = require 'wrench'
u = require 'underscore'
util = require 'util'

try
  config = require './config.private'
catch error
  config = require './config.public'

suite = vows.describe('Try the sshfs library')

mountPoint = config.prefixPath + config.folderName
tips = util.format('Make sure you can open an SSH connection to %s@%s\nYou might need to manually umount the mountpoint with sudo fusermount -u -z %s', config.user, config.host, mountPoint)

if !path.existsSync config.prefixPath
  fs.mkdirSync config.prefixPath

if !path.existsSync mountPoint
  fs.mkdirSync mountPoint

suite
  .addBatch
    'force to unmount':
      topic: ->
        callback = this.callback
        sshfs.umount mountPoint, true, this.callback
        return

      'we do not track errors here': (err, arg2) ->
        assert.isNull null

  .addBatch
    'when mounting a server':
      topic: ->
        sshfs.mount config.user, config.host, mountPoint, this.callback
        return

      'we got no error': (err, arg2) ->
        assert.isNull err, tips
  .addBatch
    'when reading mountedpoint':
      topic: ->
        fs.readdir mountPoint + __dirname, this.callback
        return

      'we got no error': (err, result) ->
        assert.isNull err, tips

        assert.isTrue u.include result, 'config.public.coffee'
        assert.isTrue u.include result, 'sshfs-test.coffee'
        assert.isTrue u.include result, 'config.private.coffee'
  .addBatch
    'when umounting a server':
      topic: ->
        sshfs.umount mountPoint, true, this.callback
        return

      'we got no error': (err, arg2) ->
        assert.isNull err
  .addBatch
    'when reading umounted mountedpoint':
      topic: ->
        fs.readdir mountPoint + __dirname, this.callback
        return

      'we got no error': (err, result) ->
        assert.isFalse u.include result, 'config.public.coffee'
        assert.isFalse u.include result, 'sshfs-test.coffee'
        assert.isFalse u.include result, 'config.private.coffee'
  .addBatch
    'when mounting a server without callback':
      topic: ->
        callback = this.callback

        sshfs.mount config.user, config.host, mountPoint
        setTimeout ->
          callback()
        , 1000
        return

      'we got no error': (err, arg2) ->
        assert.isNull err, tips
  .addBatch
    'when umounting a server':
      topic: ->
        callback = this.callback

        sshfs.umount mountPoint, true
        setTimeout ->
          callback()
        , 1000
        return

      'we got no error': (err, arg2) ->
        assert.isNull err, tips
  .export(module)