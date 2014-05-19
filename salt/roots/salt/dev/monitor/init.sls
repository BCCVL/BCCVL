include:
  - pki
  - nginx
  - mongodb
  - rsyslog
  - erpel
  - supervisord
  - virtualenv
  - flower
  - monitor.loganalyzer
  - monitor.elasticsearch

# TODO: this wolud be better to use the iptables state, but as it is
#       broken in salt <= 2014.1.3, we have to use cmd.run
allow_salt_master:
  cmd.run:
    - name: |
       # insert -s
       iptables -I INPUT 1 -m state -m multiport -m tcp -p tcp --state NEW --dports 4505,4506 -j ACCEPT
       service iptables save
    - unless: grep 'dports 4505,4506.*ACCEPT' /etc/sysconfig/iptables

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

######### configure loganalyzer
/var/www/loganalyzer/config.php:
  file.managed:
    - user: nginx
    - group: nginx
    - file_mode: 600
    - source: salt://monitor/loganalyzer_config.php
    - require:
      - cmd: /var/www/loganalyzer
      - pkg: nginx

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
