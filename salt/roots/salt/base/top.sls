# environments top tree can also be moved into envdir/top.sls

base:
  '*':
    - roles-as-grains
    - minion-id-as-hostname
    - timezone
    - locale
    - salt.minion
    - groups

  'roles:salt-master':
    - match: pillar
    - salt.master

dev:
  'monitor*dev*':
    - monitor
  'worker*dev*':
    - worker
  'bccvl*dev*':
{% if salt['pillar.items']('shibboleth:enabled', False) %}
    - shibboleth
{% endif %}
    - bccvl

qa:
  '*qa*':
    - users
    - openssh.config
  'monitor*qa*':
    - monitor
  'worker*qa*':
    - worker
    - worker.collectd
  'bccvl*qa*':
    - bccvl
    - shibboleth
    - bccvl.collectd

prod:
  '*prod*':
    - users
    - openssh.config
  'monitor*prod*':
    - monitor
    - monitor.graphite
    - monitor.collectd
  'worker*prod*':
    - worker
    - worker.collectd
  'bccvl*prod*':
    - bccvl
    - shibboleth
    - bccvl.collectd
