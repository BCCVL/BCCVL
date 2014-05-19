include:
  - erpel

supervisor:
  pkg.installed:
    - require:
      - pkgrepo: erpel

# TODO: configure childlogdir=/var/log/supervisord/
supervisord:
  service:
    - running
    - enable: True
    - require:
      - pkg: supervisor
