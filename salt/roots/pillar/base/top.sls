#base:
#  '*':
#    - mine_functions

dev:
  '*dev*':
    - salt.minion
  'monitor*dev*':
    - salt.master
    - monitor
  'worker*dev*':
    - worker
  'bccvl*dev*':
    - bccvl

qa:
  '*qa*':
    - salt.minion
    - collectd
    - openssh
    - users
  'monitor*qa*':
    - salt.master
    - monitor
  'worker*qa*':
    - worker
  'bccvl*qa*':
    - bccvl.shibboleth
    - bccvl

test:
  '*test*':
    - salt.minion
    - collectd
    - openssh
    - users
  'monitor*test*':
    - salt.master
    - monitor
  'worker*test*':
    - worker
  'bccvl*test*':
    - bccvl.shibboleth
    - bccvl

prod:
  '*prod*':
    - salt.minion
    - collectd
    - openssh
    - users
  'monitor*prod*':
    - salt.master
    - monitor
  'worker*prod*':
    - worker
  'bccvl*prod*':
    - bccvl.shibboleth
    - bccvl
