exec = require('child_process').exec
util = require 'util'
fs = require 'fs'

sshfs = {}

sshfs.mount = (user, host, mountpoint, callback) ->
  command = util.format 'sshfs -o StrictHostKeyChecking=no %s@%s:/ %s', user, host, mountpoint
  sshfs.exec command, callback
    
sshfs.umount = (mountpoint, force, callback) ->
  defaultForce = false

  if typeof force == 'function'
    callback = force
    force = false

  if !force
    force = defaultForce

  forceArg = ''
  if force
    forceArg = '-z'

  command = util.format 'fusermount -u %s %s', forceArg, mountpoint
  sshfs.exec command, (error, stdout, stderr) ->
    if !error
      sshfs.log ['umounted ' + mountpoint]

    if typeof callback == 'function'
      callback error

sshfs.exec = (command, callback) ->
  sshfs.log ['Call command: ' + command]

  exec command, (error, stdout, stderr) ->
    if error
      sshfs.log [error, stdout, stderr]
      if typeof callback == 'function'
        callback error, stdout, stderr

    else
      if typeof callback == 'function'
        callback null

sshfs.log = (messages) ->


exports = module.exports = sshfs;