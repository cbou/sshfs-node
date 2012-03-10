exec = require('child_process').exec
util = require 'util'
fs = require 'fs'

sshfs = {}

sshfs.mount = (user, host, mountpoint, callback) ->
  #sshfs -o StrictHostKeyChecking=no ec2-user@ec2-50-16-89-0.compute-1.amazonaws.com:/ ssh-test
  command = util.format 'sshfs -o StrictHostKeyChecking=no %s@%s:/ %s', user, host, mountpoint
  sshfs.exec command, callback
    
sshfs.umount = (mountpoint, callback) ->
  #fusermount -u ssh-test
  command = util.format 'fusermount -u %s', mountpoint
  sshfs.exec command, callback

sshfs.exec = (command, callback) ->
  sshfs.log ['Call command: ' + command]
  exec command, (error, stdout, stderr) ->
    if error
      sshfs.log [error, stdout, stderr]
      callback error, stdout, stderr
    else
      callback null

sshfs.log = (messages) ->


exports = module.exports = sshfs;