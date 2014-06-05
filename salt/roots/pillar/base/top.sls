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
    - users
  'monitor*prod*':
    - salt.master
    - monitor
  'worker*prod*':
    - worker
  'bccvl*prod*':
    - bccvl.shibboleth
    - bccvl
