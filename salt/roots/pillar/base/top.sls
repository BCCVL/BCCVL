#base:
#  '*':
#    - mine_functions

dev:
  'monitor*dev*':
    - salt.master
    - monitor
  'worker*dev*':
    - salt.minion
    - worker
  'bccvl*dev*':
    - salt.minion
    - bccvl

qa:
  'monitor*qa*':
    - salt.master
    - monitor
  'worker*qa*':
    - salt.minion
    - worker
  'bccvl*qa*':
    - salt.minion
    - bccvl

prod:
  'monitor*prod*':
    - salt.master
    - monitor
  'worker*prod*':
    - salt.minion
    - worker
  'bccvl*prod*':
    - salt.minion
    - bccvl
