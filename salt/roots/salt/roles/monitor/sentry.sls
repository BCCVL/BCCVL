include:
  - supervisord

###### install sentry
# 1. create flower user

sentry_user:
  user.present:
    - name: sentry
    - fullname: Sentry User
    - gid_from_name: True
    - system: True

# 3. setup virtualenv and install flower
sentry_virtualenv:
  virtualenv.managed:
    - name: /home/sentry
    - cwd: /home/sentry
    - requirements: salt://monitor/sentry_requirements.txt
    - require:
      - pkg: python-virtualenv
      - pkg: libffi-devel
      - pkg: openssl-devel

/home/sentry/.sentry/sentry.conf.py:
  file.managed:
    - source: salt://monitor/sentry.conf.py
    - user: sentry
    - group: sentry
    - mode: 640
    - require:
      - user: sentry_user

/etc/supervisord.d/sentry.ini:
  file.managed:
    - source: salt://monitor/sentry_supervisord.ini
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: supervisor
      - virtualenv: sentry_virtualenv
      - file: /home/sentry/.sentry/sentry.conf.py
    - watch_in:
      - service: supervisord
