

Install Virtualbox and Vagrant:
===============================

  For local setup, please install Virtualbox and Vagrant on your
  machine. Follow the installation instructions on their websites.


Bootstrap env:
==============

  Follow the steps below to create a new BCCVL environment.

  1. Creat BCCVL local CA:

  cd into salt/roots/CA folder (or if deployed directly on server cd into /srv/CA)

  # pushd salt/roots/CA
  # ./creatcerts.sh
  # popd

  this copies also all generated certs and keys into pillar/base/certs
  from where they can be used in normal pillar files

  2. Provision master node

  Next step is to bring up the master node. The following command will
  create a VM with salt installed and activated.

  # vagrant up monitor

  As a first step it is necessary to bring up the master node.Because
  the master "salts" itself, we have to run highstate on the master
  first

  # vagrant ssh monitor
  # sudo salt-call state.highstate

  This should trigger a restart of the salt master daemon, which
  causes the minion to loose it's connection. If that's the case we'll
  have to re-run the highstate

  # sudo salt-call state.highstate

  3. create minion keys for master pre-seeding

  # cd /srv
  # ./createminionkeys.sh


Build BCCVL Node:
=================

  This works very similar to building the master node.

  # vagrant up bccvl
  # vagrant ssh bccvl
  # sudo salt-call state.highstate




Problems:
=========

* When updating the master config via salt, the master will be restarted
and the minion looses the connection with the master and fails to
finish executing the remainder of the state tree

TODO:
=====

* document folder structure ... esp. pillar/base/keys and certs
* document how and what to override for different environments
* change monitor node to manage all envs
* add halite to monitor
