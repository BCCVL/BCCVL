
bccvl_user:
  group.present:
    - system: True

ssh_user:
  group.present:
    - gid: 2000
