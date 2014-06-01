#base:
#  '*':
#    - mine_functions

dev:
  'monitor*dev*':
    - salt.master
    - salt.minion
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
    - salt.minion
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
    - salt.minion
    - monitor
  'worker*prod*':
    - salt.minion
    - worker
  'bccvl*prod*':
    - salt.minion
    - bccvl
