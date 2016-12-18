

<!-- Start lib/sshfs-node.coffee -->

# Sshfs

## mount(host, mountpoint, options, callback)

Mounts the host into the host point.

 Option list:
   * {String} user: name of the user to use (e.g. ec2-user)
   * {String} identityFile: identity file to use (e.g. ~/.ssh/id_rsa)
   * {Boolean} cache: true to activate cache, false if not (default true)
   * {Number} port: port number, default if not (e.g. 2222)
   * {String} path: remote host path (e.g. /)

 Examples:
    sshfs.mount('127.0.0.1', '/mnt/ec2', {user: 'ec2-user', port: 2222, path: '/'}, callback)

### Params: 

* **String** *host* Host of the server

* **String** *mountpoint* Path where host should be mounted

* **Object** *options* An object of options

* **Function** *callback* Callback function with parameters (err)

## umount(mountpoint, force, callback)

Umounts the mountpoint.

 Examples:

    sshfs.umount('/mnt/ec2', false, callback)

### Params: 

* **String** *mountpoint* Path where host is mounted

* **Boolean** *force* True if the umount should be force, false if not

* **Function** *callback* Callback function with parameters (err)

## log(message)

Log function

This function can be override to recieve message from sshfs.

 Examples:

    sshfs.log = function(message) {
      console.log(message);
    }

### Params: 

* **String** *message* The message to log

<!-- End lib/sshfs-node.coffee -->

