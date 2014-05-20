#!/bin/bash

function create_keypair() {
  if [ -f "$1.id_dsa" ] ; then
    echo "Key for $name already exists"
    return 1
  fi
  ssh-keygen -t dsa -C "$name" -f "$name.id_dsa" -N ""
}


for name in data_mover visualiser plone ; do
  create_keypair $name
done

