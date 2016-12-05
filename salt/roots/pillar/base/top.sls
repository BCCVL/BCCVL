
dev:
  '*dev*':
    - salt.minion
    - collectd
    - users
    - versions
    - sentry
    - authtkt
    - nectar
    - oauth
    - ala
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
    - sentry
    - authtkt
    - nectar
    - oauth
    - ala
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
    - sentry
    - authtkt
    - nectar
    - oauth
    - ala
  'monitor*prod*':
    - salt.master
    - monitor
  'worker*prod*':
    - worker
  'bccvl*prod*':
    - bccvl.shibboleth
    - bccvl
