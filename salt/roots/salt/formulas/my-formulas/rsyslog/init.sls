
/etc/yum.repos.d/adiscon.repo:
  file.managed:
    - source: http://rpms.adiscon.com/v8-stable/rsyslog.repo
    - source_hash: sha1=86d80fde5f223fb899ea2f9d0eca6be56f365e16
    - user: root
    - group: root
    - mode: 644

rsyslog:
  pkg:
    - installed
    - require:
      - file: /etc/yum.repos.d/adiscon.repo
  service:
    - running
    - enable: True
    - require:
      - pkg: rsyslog


rsyslog-relp:
  pkg:
    - installed
    - require:
      - pkg: rsyslog
      - file: /etc/yum.repos.d/adiscon.repo
    - watch_in:
      - service: rsyslog

rsyslog-gnutls:
  pkg:
    - installed
    - require:
      - pkg: rsyslog
      - file: /etc/yum.repos.d/adiscon.repo
    - watch_in:
      - service: rsyslog

rsyslog-mmjsonparse:
  pkg:
    - installed
    - require:
      - pkg: rsyslog
      - file: /etc/yum.repos.d/adiscon.repo
    - watch_in:
      - service: rsyslog

rsyslog-mongodb:
  pkg:
    - installed
    - require:
      - pkg: rsyslog
      - file: /etc/yum.repos.d/adiscon.repo
    - watch_in:
      - service: rsyslog
