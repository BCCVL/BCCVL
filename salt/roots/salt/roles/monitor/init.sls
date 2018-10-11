include:
  - pki
  - nginx
  - mongodb.purge
  - postgres
  - rsyslog
  - rsyslog.mongodb
  - rsyslog.pgsql
  - supervisord
  - virtualenv
  - flower
  - monitor.loganalyzer


/etc/sysconfig/iptables:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - source:
      - salt://monitor/iptables
      #- salt://roles/{{ grains.get('role') }}/etc/sysconfig/iptables
      #- salt://hosts/{{ grains.host }}/etc/sysconfig/iptables
      #- salt://defaults/etc/sysconfig/iptables
{% if salt['cmd.retcode']('service iptables status') == 0 %}
service iptables restart:
  cmd.wait:
    - watch:
      - file: /etc/sysconfig/iptables
{% endif %}


####### setup rsyslog
/etc/rsyslog.d/monitor.conf:
  file.managed:
    - source: salt://monitor/rsyslog_monitor.conf
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog

/tmp/log_tables.sql:
  file.managed:
    - source: salt://monitor/log_tables.sql
    - user: root
    - group: root
    - mode: 644
    - template: jinja

{% if 'databases' in pillar.get('postgres', {}) %}
rsyslog-initdb:
  cmd.run:
    - name: |
        {% for name, db in salt['pillar.get']('postgres:databases').items()  %}
        psql -d {{ name }} -f /tmp/log_tables.sql
        {% endfor %}
    - user: postgres
    - group: postgres
    - requires:
      - service: postgres-9.4
      - file: /tmp/log_tables.sql
{% endif %}

######### configure loganalyzer
/var/www/loganalyzer/config.php:
  file.managed:
    - user: nginx
    - group: nginx
    - file_mode: 600
    - source: salt://monitor/loganalyzer_config.php
    - template: jinja
    - require:
      - cmd: /var/www/loganalyzer
      - pkg: nginx
    - watch_in:
      - service: php-fpm

###### configure nginx

/etc/nginx/conf.d/monitor.conf:
  file.managed:
    - source: salt://monitor/nginx_monitor.conf
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - pkg: supervisor
    - watch_in:
      - service: nginx

# provides htpasswd
httpd-tools:
  pkg.installed

/etc/nginx/.htpasswd:
  file.managed:
    - user: nginx
    - group: nginx
    - mode: 600
    - require:
      - pkg: nginx

nginx_user_admin:
  module.run:
    - name: webutil.useradd
    - user: {{ salt['pillar.get']('monitor:admin:user', 'admin') }}
    - password: {{ salt['pillar.get']('monitor:admin:pass', 'admin') }}
    - pwfile: /etc/nginx/.htpasswd
    - opts: s
    - require:
      - pkg: httpd-tools
      - file: /etc/nginx/.htpasswd

/usr/local/bin/check_errorlog.sh:
  file.managed:
    - source: salt://monitor/check_errorlog.sh
    - user: root
    - group: root
    - mode: 755
  cron.present:
    - name: /usr/local/bin/check_errorlog.sh >/dev/null 2>&1
    - identifier: CRON_LOG_ALERT
    - minute: '*/5'

/usr/local/bin/get_errorlog.sh:
  file.managed:
    - source: salt://monitor/get_errorlog.sh
    - user: root
    - group: root
    - mode: 755
