
rsyslog-pgsql:
  pkg:
    - installed
    - require:
      - pkg: rsyslog
      - file: /etc/yum.repos.d/adiscon.repo
    - watch_in:
      - service: rsyslog
