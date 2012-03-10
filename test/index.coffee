assert = require 'assert'
vows = require 'vows'
sshfs = require '../index'
path = require 'path'
fs = require 'fs'
wrench = require 'wrench'

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

suite.addBatch(
  'when mounting a server':
    topic: () ->
      sshfs.mount validUser, validHost, prefixPath + mountPoint, this.callback
      return

    'we got no error': (err, arg2) ->
      assert.isNull err
).addBatch(
  'when waiting that everything is ok':
    topic: () ->
      setTimeout this.callback, 5000
      return
    'we got no error': () ->
      assert.isNull null
).addBatch(
  'when umounting a server':
    topic: () ->
      sshfs.umount prefixPath + mountPoint, this.callback
      return

    'we got no error': (err, arg2) ->
      assert.isNull err
).export(module)