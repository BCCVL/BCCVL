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
  '*qa*':
    - users
    - sshd
  'monitor*qa*':
    - monitor
  'worker*qa*':
    - worker
  'bccvl*qa*':
    - bccvl
    - shibboleth

test:
  '*test*':
    - users
    - sshd
  'monitor*test*':
    - monitor
  'worker*test*':
    - worker
  'bccvl*test*':
    - bccvl
    - shibboleth

prod:
  '*prod*':
    - users
    - sshd
  'monitor*prod*':
    - monitor
  'worker*prod*':
    - worker
  'bccvl*prod*':
    - bccvl
    - shibboleth
