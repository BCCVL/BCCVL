Install Virtualbox and Vagrant
==============================

For local setup, please install Virtualbox and Vagrant on your
machine. Follow the installation instructions on their websites.


Bootstrap the Environment
=========================

1. Boot the master node

The following command will create a VM with salt installed and activated::

  $ vagrant up monitor

2. Create BCCVL certificates

::

  $ vagrant ssh monitor
  $ pushd /srv/CA
  $ ./createcerts.sh
  $ popd

This copies also all generated certs and keys into pillar/base/certs
from where they can be used in normal pillar files

3. Provision the monitor node

Create an empty users.sls::

  $ touch /srv/pillar/base/users.sls

Because the master "salts" itself, we have to run highstate on the master
first::

  $ vagrant ssh monitor
  $ sudo salt-call state.highstate

This should trigger a restart of the salt master daemon, which
causes the minion to loose it's connection. If that's the case we'll
have to re-run the highstate::

  $ sudo salt-call state.highstate
  $ exit


Build BCCVL Node:
=================

First, create the SSH keys for the various components::

  $ pushd salt/roots/pillar/dev/keys
  $ ./createkeys.sh
  $ popd

Then, bring up the BCCVL node. This works very similar to building the master node::

  $ vagrant up bccvl
  $ vagrant ssh bccvl
  $ sudo salt-call state.highstate
  $ exit


Build Worker Node:
==================

Run the script downloadrlibs.sh to fetch all required R
libraries. This step is necessary until a bug in salt file.managed
with multiple alternative source locations is fixed::

  $ ./downloadrlibs.sh

Go to http://www.cs.princeton.edu/~schapire/maxent/ and download a
copy of maxent.jar v3.3.3k and place it in `salt/roots/salt/prod/worker`

The last steps are the same steps as above::

  $ vagrant up worker
  $ vagrant ssh worker
  $ sudo salt-call state.highstate
  $ exit

Available URIs after build:
===========================

Master Node:
------------

+--------------------------------------+---------------+
| URL                                  | Description   |
+======================================+===============+
| https://192.168.100.100/loganalyzer/ | Loganalyzer   |
+--------------------------------------+---------------+
| https://192.168.100.100/flower/      | Flower        |
+--------------------------------------+---------------+
| https://192.168.100.100/kibana/      | Elasticsearch |
+--------------------------------------+---------------+

BCCVL Node:
-----------

+--------------------------------------+-------------+
| URL                                  | Description |
+======================================+=============+
| https://192.168.100.200/             | BCCVL       |
| http://192.168.100.200/              |             |
+--------------------------------------+-------------+
| https://192.168.100.200/_debug/      | BCCVL debug |
| http://192.168.100.200/_debug/       |             |
+--------------------------------------+-------------+
| https://192.168.100.200:15671        | Rabbitmq    |
+--------------------------------------+-------------+
| https://192.168.100.200/_visualiser/ | Visualiser  |
| http://192.168.100.200/_visualiser/  |             |
+--------------------------------------+-------------+
| https://192.168.100.200/_datamover/  | Datamover   |
| http://192.168.100.200/_datamover/   |             |
+--------------------------------------+-------------+


Worker Node:
------------

Nothing exposed here


Problems:
=========

* When updating the master config via salt, the master will be restarted
  and the minion looses the connection with the master and fails to
  finish executing the remainder of the state tree

TODO:
=====

* document folder structure ... esp. pillar/base/keys and certs
* document how and what to override for different environments

