

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

Build Worker Node:
==================

  Run the script downloadrlibs.sh to fetch all required R
  libraries. This step is necessary until a bug in salt file.managed
  with multiple alternatvie source locatinos is fixed.

  # ./downloadrlibs.sh

  Go to http://www.cs.princeton.edu/~schapire/maxent/ and download a
  copy of maxent.jar and place it in salt/roots/salt/prod/worker

  The last steps are the same steps as above

  # vagrant up worker
  # vagrant ssh worker
  # sudo salt-call state.highstate

Available URIs after build:
===========================

Master Node:
------------

+------------------------------------+-------------+
|URL                                 |Description  |
+====================================+=============+
|https://192.168.100.100/loganalyzer/|Loganalyzer  |
+------------------------------------+-------------+
|https://192.168.100.100/flower/     |Flower       |
+------------------------------------+-------------+
|https://192.168.100.100/kibana/     |Elasticsearch|
+------------------------------------+-------------+

BCCVL Node:
-----------

+------------------------------------+-----------+
|URL                                 |Description|
+====================================+===========+
|https://192.168.100.200/            |BCCVL      |
|http://192.168.100.200/             |           |
+------------------------------------+-----------+
|https://192.168.100.200/_debug/     |BCCVL debug|
|http://192.168.100.200/_debug/      |           |
+------------------------------------+-----------+
|https://192.168.100.200:15167       |Rabbitmq   |
+------------------------------------+-----------+
|https://192.168.100.200/_visualiser/|Visualiser |
|http://192.168.100.200/_visualiser/ |           |
+------------------------------------+-----------+
|https://192.168.100.200/_datamover/ |Datamover  |
|http://192.168.100.200/_datamover/  |           |
+------------------------------------+-----------+


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
* change monitor node to manage all envs
* add halite to monitor
