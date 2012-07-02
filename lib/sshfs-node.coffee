
###*
 * # Sshfs
###

exec = require('child_process').exec
util = require 'util'
fs = require 'fs'


###!
 * Sshfs object
###
sshfs = {}

###*
 * Mounts the host into the host point.
 *
 *  Examples:
 *
 *     sshfs.mount('ec2-user', '127.0.0.1', '/mnt/ec2', callback)
 *
 * @param {String} user User of the server
 * @param {String} host Host of the server
 * @param {String} mountpoint Path where host should be mounted
 * @param {Function} callback Callback function with parameters (err)
###
sshfs.mount = (user, host, mountpoint, callback) ->
  command = util.format 'sshfs -o StrictHostKeyChecking=no %s@%s:/ %s', user, host, mountpoint
  sshfs.exec command, callback
    
###*
 * Umounts the mountpoint.
 *
 *  Examples:
 *
 *     sshfs.umount('/mnt/ec2', false, callback)
 *
 * @param {String} mountpoint Path where host is mounted
 * @param {Boolean} force True if the umount should be force, false if not
 * @param {Function} callback Callback function with parameters (err)
###
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

###!
 * Execute a shell command.
 *
 * @param {String} command The command to execute
 * @param {Function} callback Callback function with parameters (error, stdout, stderr)
###
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

###*
 * Log function
 *
 * This function can be override to recieve message from sshfs.
 *
 *  Examples:
 *
 *     sshfs.log = function(message) {
 *       console.log(message);
 *     }
 *
 * @param {String} message The message to log
###
sshfs.log = (messages) ->


exports = module.exports = sshfs;