include:
  - collectd
  - supervisord

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

/etc/supervisord.d/graphite.ini:
  file.managed:
    - source: salt://monitor/graphite_supervisord.ini
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: supervisor
      - pkg: graphite-web
      - pip: uwsgi
      - service: carbon-cache
    - watch_in:
      - service: supervisord
