include:
  - epel
  - nginx
  - supervisord

python-whisper:
  pkg.installed:
    - require:
      - file: enable_epel

python-carbon:
  pkg.installed:
    - require:
      - file: enable_epel

graphite-web:
  pkg.installed:
    - require:
      - file: enable_epel

python-pip:
  pkg.installed

## TODO: move some of this stuff into uwsgi formula
uwsgi:
  pip.installed:
    - require:
      - pkg: python-pip

/etc/uwsgi/graphite.ini:
  file.managed:
    - source: salt://monitor/graphite_uwsgi.ini
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - pip: uwsgi

# TODO: need /var/www as well?
/etc/uwsgi:
  file.directory:
    - user: root
    - group: root
    - mode: 700

/var/log/uwsgi:
  file.directory:
    - user: root
    - group: root
    - mode: 700



/etc/graphite-web/local_settings.py:
  file.managed:
    - source: salt://monitor/graphite_local_settings.py
    - user: root
    - group: apache
    - mode: 640
    - template: jinja
    - require:
      - pkg: graphite-web

/etc/nginx/conf.d/graphite.conf:
  file.managed:
    - source: salt://monitor/nginx_graphite.conf
    - user: root
    - group: apache
    - mode: 640
    - template: jinja
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx

# add missing build-index.sh
/usr/share/graphite/bin/build-index.sh:
  file.managed:
    - source:
      - salt://monitor/graphite_build_index.sh
      - https://raw.githubusercontent.com/graphite-project/graphite-web/0.9.12/bin/build-index.sh
    - makedirs: True
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: graphite-web

carbon-cache:
  service.running:
    - enable: True
    - require:
      - pkg: python-carbon


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


# TODO: start all services: uwsgi (supervisor?)
#       check /etc/carbon/* for configuration?
