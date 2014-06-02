# environments top tree can also be moved into envdir/top.sls

base:
  '*':
    - roles-as-grains
    - minion-id-as-hostname
    - timezone
    - locale
    - salt.minion

  'roles:salt-master':
    - match: pillar
    - salt.master

dev:
  'monitor*dev*':
    - monitor
  'worker*dev*':
    - worker
  'bccvl*dev*':
    - bccvl

qa:
  'monitor*qa*':
    - monitor
  'worker*qa*':
    - worker
  'bccvl*qa*':
    - bccvl

test:
  'monitor*test*':
    - monitor
  'worker*test*':
    - worker
  'bccvl*test*':
    - bccvl

prod:
  'monitor*prod*':
    - monitor
  'worker*prod*':
    - worker
  'bccvl*prod*':
    - bccvl
