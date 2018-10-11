
supervisor:
  pkg.installed:

# TODO: configure childlogdir=/var/log/supervisord/
supervisord:
  service:
    - running
    - enable: True
    - require:
      - pkg: supervisor
