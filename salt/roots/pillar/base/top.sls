#base:
#  '*':
#    - mine_functions

dev:
  '*dev*':
    - salt.minion
    - users
    - versions
  'monitor*dev*':
    - salt.master
    - monitor
  'worker*dev*':
    - worker
  'bccvl*dev*':
    - bccvl.shibboleth
    - bccvl

qa:
  '*qa*':
    - salt.minion
    - collectd
    - openssh
    - users
    - versions
  'monitor*qa*':
    - salt.master
    - monitor
  'worker*qa*':
    - worker
  'bccvl*qa*':
    - bccvl.shibboleth
    - bccvl

prod:
  '*prod*':
    - salt.minion
    - collectd
    - openssh
    - users
    - versions
  'monitor*prod*':
    - salt.master
    - monitor
  'worker*prod*':
    - worker
  'bccvl*prod*':
    - bccvl.shibboleth
    - bccvl
