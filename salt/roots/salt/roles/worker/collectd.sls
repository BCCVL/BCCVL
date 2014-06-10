include:
  - collectd

/etc/collectd.d/df.conf:
  file.managed:
    - source: salt://worker/collectd_df.conf
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
    - source: salt://worker/collectd_network.conf
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - pkg: collectd
    - watch_in:
      - service: collectd
