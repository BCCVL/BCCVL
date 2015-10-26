# environments top tree can also be moved into envdir/top.sls

base:
  '*':
    - roles-as-grains
    - timezone
    - locale
    - salt.minion
    - groups

  'roles:salt-master':
    - match: pillar
    - salt.master

dev:
  '*dev*':
    - users
    - elgis.purge
  'monitor*dev*':
    - monitor
  'worker*dev*':
    - worker
    - worker.worker_virtualenv
    - worker.collectd
  'bccvl*dev*':
{% if salt['pillar.items']('shibboleth:enabled', False) %}
    - shibboleth
{% endif %}
    - bccvl
    - bccvl.data_mover_worker.data_mover_worker_virtualenv
    - bccvl.collectd

qa:
  '*qa*':
    - users
    - openssh.config
    - elgis.purge
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
    - elgis.purge
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
