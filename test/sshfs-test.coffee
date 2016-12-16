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

# Example of ssh.log override
sshfs.log = (message)->
  if typeof fs.appendFile == 'function'
    fs.appendFileSync config.testLog, message, 'utf-8'

suite = vows.describe('Try the sshfs library')

mountPoint = config.prefixPath + config.folderName
tips = util.format('Make sure you can open an SSH connection to %s@%s\nYou might need to manually umount the mountpoint with sudo fusermount -u -z %s', config.user, config.host, mountPoint)

if !fs.existsSync config.prefixPath
  fs.mkdirSync config.prefixPath

if !fs.existsSync mountPoint
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
        options = 
          user: config.user
        sshfs.mount config.host, mountPoint, options, this.callback
        return

      'we got no error': (err, arg2) ->
        assert.isNull err

  .addBatch
    'when reading mountedpoint':
      topic: ->
        fs.readdir mountPoint + __dirname, this.callback
        return

      'we got no error': (err, result) ->
        assert.isNull err

        assert.isTrue u.include result, 'config.public.coffee'
        assert.isTrue u.include result, 'sshfs-test.coffee'
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
  .addBatch
    'when mounting a server without callback':
      topic: ->
        callback = this.callback
        options = 
          user: config.user
        sshfs.mount config.host, mountPoint, options
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
