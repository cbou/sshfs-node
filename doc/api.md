

<!-- Start lib/sshfs-node.coffee -->



# Sshfs








## mount(user, host, mountpoint, callback)
Mounts the host into the host point.

 Examples:

    sshfs.mount('ec2-user', '127.0.0.1', '/mnt/ec2', callback)


### Params: 

* **String** *user* User of the server

* **String** *host* Host of the server

* **String** *mountpoint* Path where host should be mounted

* **Function** *callback* Callback function with parameters (err)




---





## umount(mountpoint, force, callback)
Umounts the mountpoint.

 Examples:

    sshfs.umount('/mnt/ec2', false, callback)


### Params: 

* **String** *mountpoint* Path where host is mounted

* **Boolean** *force* True if the umount should be force, false if not

* **Function** *callback* Callback function with parameters (err)




---








## log(message)
Log function

This function can be override to recieve message from sshfs.

 Examples:

    sshfs.log = function(message) {
      console.log(message);
    }


### Params: 

* **String** *message* The message to log




---




<!-- End lib/sshfs-node.coffee -->

