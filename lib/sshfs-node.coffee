
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
 *  Option list:
 *    * {String} user: name of the user to use (e.g. ec2-user)
 *    * {String} identityFile: identity file to use (e.g. ~/.ssh/id_rsa)
 *    * {Boolean} cache: true to activate cache, false if not (default true)
 *    * {Number} port: port number, default if not (e.g. 2222)
 *    * {Number} path: remote host path (e.g. /)
 *
 *  Examples:
 *     sshfs.mount('127.0.0.1', '/mnt/ec2', {user: 'ec2-user', port: 2222}, callback)
 *
 * @param {String} host Host of the server
 * @param {String} mountpoint Path where host should be mounted
 * @param {Object} options An object of options
 * @param {Function} callback Callback function with parameters (err)
###
sshfs.mount = (host, mountpoint, options, callback) ->
  identityOption = ''
  if options && options.identityFile
    identityOption = util.format '-o IdentityFile=%s', options.identityFile

  userOption = ''
  if options && options.user
    userOption = util.format '%s@', encodeURI(options.user)

  cacheOption = '-o cache=yes'
  if options && options.cache == false
    cacheOption = '-o cache=no'

  portOption = ''
  if options && options.port
    portOption = util.format '-o port=%d', options.port

  pathOption = '/'
  if options && (typeof(options.path) == 'string')
    pathOption = util.format '%s', options.path

  # sshfs -o IdentityFile=~/.ssh/id_rsa user@localhost:"/" "~/mnt/localhost_mount/"
  command = util.format 'sshfs %s %s %s -o StrictHostKeyChecking=no %s%s:"%s" "%s"', identityOption, cacheOption, portOption, userOption, host, pathOption, mountpoint
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
