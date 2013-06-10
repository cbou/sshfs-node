sshfs-node [![Build Status](https://secure.travis-ci.org/cbou/sshfs-node.png)](http://travis-ci.org/cbou/sshfs-node)
==========

This module helps to mount filesystem through ssh thanks [sshfs]. 
It only works with public and private keys, not with password.


Installation
--------

    npm install sshfs-node

Quick Start
--------

    // mount
    sshfs.mount(user, host, mountpoint, callback);
    
    // unmount
    sshfs.umount(mountpoint, force, callback);

Running Tests
--------

Run tests:

    npm test

Documentation
---

Documentation is [here](doc/api.md) and can be generate with:

    $ npm run-script documentation

License
--------

(The MIT License)

Copyright (c) 2012 Charles Bourasseau charles.bourasseau@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[sshfs]: http://fuse.sourceforge.net/sshfs.html
