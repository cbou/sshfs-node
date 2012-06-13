assert = require 'assert'
vows = require 'vows'
sshfs = require '../index'
path = require 'path'
fs = require 'fs'
wrench = require 'wrench'
u = require 'underscore'

try
  config = require './config.private'
catch error
  config = require './config.public'

suite = vows.describe('Try the sshfs library')

mountPoint = config.prefixPath + config.folderName

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
        assert.isNull err
  .addBatch
    'when reading mountedpoint':
      topic: ->
        fs.readdir mountPoint, this.callback
        return

      'we got no error': (err, result) ->
        assert.isNull err
        
        assert.isTrue u.include result, 'root'
        assert.isTrue u.include result, 'etc'
        assert.isTrue u.include result, 'home'
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
        fs.readdir mountPoint, this.callback
        return

      'we got no error': (err, result) ->
        assert.isNull err
        
        assert.isFalse u.include result, 'root'
        assert.isFalse u.include result, 'etc'
        assert.isFalse u.include result, 'home'
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
        assert.isNull err
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
        assert.isNull err
  .export(module)