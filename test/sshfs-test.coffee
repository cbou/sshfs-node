assert = require 'assert'
vows = require 'vows'
sshfs = require '../index'
path = require 'path'
fs = require 'fs'
wrench = require 'wrench'
u = require 'underscore'

suite = vows.describe('Try the sshfs library')

validUser = 'ec2-user'
validHost = 'big-bazar.fr'
mountPoint = '/mountpoint-test'

prefixPath = '/tmp/sshfs'

if !path.existsSync prefixPath
  fs.mkdirSync prefixPath

if path.existsSync prefixPath + mountPoint
  wrench.rmdirSyncRecursive prefixPath + mountPoint
fs.mkdirSync prefixPath + mountPoint

suite
  .addBatch
    'when mounting a server':
      topic: ->
        sshfs.mount validUser, validHost, prefixPath + mountPoint, this.callback
        return

      'we got no error': (err, arg2) ->
        assert.isNull err
  .addBatch
    'when reading mountedpoint':
      topic: ->
        fs.readdir prefixPath + mountPoint, this.callback
        return

      'we got no error': (err, result) ->
        assert.isNull err
        
        assert.isTrue u.include result, 'root'
        assert.isTrue u.include result, 'etc'
        assert.isTrue u.include result, 'home'
  .addBatch
    'when umounting a server':
      topic: ->
        sshfs.umount prefixPath + mountPoint, this.callback
        return

      'we got no error': (err, arg2) ->
        assert.isNull err
  .addBatch
    'when reading mountedpoint':
      topic: ->
        fs.readdir prefixPath + mountPoint, this.callback
        return
        
      'we got no error': (err, result) ->
        assert.isNull err
        
        assert.isFalse u.include result, 'root'
        assert.isFalse u.include result, 'etc'
        assert.isFalse u.include result, 'home'
  .export(module)