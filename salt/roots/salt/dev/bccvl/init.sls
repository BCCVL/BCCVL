include:
  - pki
  - rsyslog
  - rabbitmq
  - apache
  - 4store
  - varnish
  - haproxy
  - bccvl.data_mover
  - bccvl.data_mover_worker
  - bccvl.visualiser
  - bccvl.plone


/etc/rsyslog.d/bccvl.conf:
  file.managed:
    - source: salt://bccvl/rsyslog_bccvl.conf
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog


/etc/rabbitmq/rabbitmq.config:
  file:
    - managed
    - source:
      - salt://bccvl/rabbitmq.config
    - user: rabbitmq
    - group: rabbitmq
    - mode: 600
    - require:
      - pkg: rabbitmq-server
    - watch_in:
      - service: rabbitmq-server


/etc/httpd/conf.d/bccvl.conf:
  file.managed:
    - source: salt://bccvl/apache_bccvl.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - require:
      - pkg: httpd
    - watch_in:
      - service: httpd


/etc/varnish/bccvl.vcl:
  file.managed:
    - source: salt://bccvl/varnish_bccvl.vcl
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: varnish
    - watch_in:
      - service: varnish


/etc/sysconfig/varnish:
  file.managed:
    - source: salt://bccvl/varnish.sysconfig
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: varnish
      - file: /etc/varnish/bccvl.vcl
    - watch_in:
      - service: varnish

/etc/haproxy/haproxy.cfg:
  file.managed:
    - source: salt://bccvl/haproxy.cfg
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - requires:
      - pkg: haproxy
    - watch_in:
      - service: haproxy
