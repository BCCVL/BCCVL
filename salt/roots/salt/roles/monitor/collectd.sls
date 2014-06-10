include:
  - collectd


/etc/collectd.d/passwd:
  file.managed:
    - source: salt://monitor/collectd_passwd
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - pkg: collectd

/etc/collectd.d/df.conf:
  file.managed:
    - source: salt://monitor/collectd_df.conf
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - pkg: collectd
    - watch_in:
      - service: collectd

/etc/collectd.d/write_graphite.conf:
  file.managed:
    - source: salt://monitor/collectd_write_graphite.conf
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - pkg: collectd
    - watch_in:
      - service: collectd

/etc/collectd.d/network.conf:
  file.managed:
    - source: salt://monitor/collectd_network.conf
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - pkg: collectd
    - watch_in:
      - service: collectd
