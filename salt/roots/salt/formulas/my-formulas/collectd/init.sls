include:
  - rpmforge

collectd:
  pkg.installed:
    - enablerepo: rpmforge-testing
    - require:
      - pkg: rpmforge-release
  service.running:
    - enable: True
    - require:
      - pkg: collectd

/etc/collectd.conf:
  file.append:
    - text: Include "/etc/collectd.d/*.conf"
    - require:
      - pkg: collectd
    - watch_in:
      - service: collectd

# TODO: maybe one file per plugin ... leave default sensors, and add
#       plugins for custom config in /etc/collect.d/*.conf (make sure
#       default include is on)
