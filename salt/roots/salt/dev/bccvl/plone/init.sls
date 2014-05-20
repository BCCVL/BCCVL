{% set user = salt['pillar.get']('plone:user', 'plone') %}

include:
  - git
  - gcc
  - make
  - subversion
  - mercurial
  - zlib
  - libjpeg-turbo
  - python27
  - 4store
  - supervisord

freetype-devel:
  pkg.installed

libtiff-devel:
  pkg.installed

# TODO: make sure things get rebuilt when sources change

# Create plone user
{{ user }}:
  user.present:
    - fullname: Plone
    - shell: /bin/bash
    - createhome: true
    - gid_from_name: true
    - system: true
  ssh_auth:
    - present
    - user: {{ user }}
    - comment: allow data_mover
    - name: {{ salt['pillar.get']('data_mover:ssh_pubkey') }}

/home/{{ user }}/.ssh/id_dsa:
  file.managed:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 0600
    - contents_pillar: {{ user }}:ssh_privkey
    - require:
      - user: {{ user }}

/home/{{ user }}/.ssh/id_dsa.pub:
  file.managed:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 0600
    - contents_pillar: {{ user }}:ssh_pubkey
    - require:
      - user: {{ user }}

# clone buildout repo
/home/{{ user }}/bccvl_buildout:
  git.latest:
    - name: https://github.com/BCCVL/bccvl_buildout.git
    - rev: {{ pillar['plone']['buildout']['branch'] }}
    - target: /home/{{ user }}/bccvl_buildout
    - runas: {{ user }}
    - require:
      - user: {{ user }}
      - pkg: git
  virtualenv.managed:
    - venv_bin: /usr/local/bin/python27-virtualenv
    - user: {{ user }}
    - cwd: /home/{{ user }}
    - require:
      - user: {{ user }}
      - git: /home/{{ user }}/bccvl_buildout
      - pkg: python27-python-virtualenv
      - file: /usr/local/bin/python27-virtualenv

/home/{{ user }}/bccvl_buildout/etc:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 750
    - require:
      - git: /home/{{ user }}/bccvl_buildout

# plone worker celery settings
/home/{{ user }}/bccvl_buildout/etc/bccvl_celery.json:
  file.managed:
    - source: salt://bccvl/plone_worker.json
    - user: {{ user }}
    - group: {{ user }}
    - mode: 640
    - template: jinja
    - require:
      - file: /home/{{ user }}/bccvl_buildout/etc

/home/{{ user }}/bccvl_buildout/buildout.cfg:
  file.managed:
    - source: salt://bccvl/plone/plone_buildout.cfg
    - user: {{ user }}
    - group: {{ user }}
    - mode: 440
    - template: jinja
    - require:
      - git: /home/{{ user }}/bccvl_buildout

# create storage if necessary
{% if pillar['plone'].get('storage', false) %}
{{ pillar['plone']['storage']['root'] }}:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 750
    - makedirs: True
    - require_in:
        - cmd: /home/{{ user }}/bccvl_buildout/bin/buildout
{% endif %}

/home/{{ user }}/bccvl_buildout/bin/buildout:
  cmd.run:
    - name: scl enable python27 ". ./bin/activate; python2.7 bootstrap.py"
    - cwd: /home/{{ user }}/bccvl_buildout
    - user: {{ user }}
    - group: {{ user }}
    - unless: test -x /home/{{ user }}/bccvl_buildout/bin/buildout
    - require:
      - file: /home/{{ user }}/bccvl_buildout/buildout.cfg
      - virtualenv: /home/{{ user }}/bccvl_buildout
      - pkg: gcc
      - pkg: gcc-c++
      - pkg: make
      - pkg: mercurial
      - pkg: zlib-devel
      - pkg: libjpeg-turbo-devel
      - pkg: freetype-devel
      - pkg: libtiff-devel

/home/{{ user }}/bccvl_buildout/bin/instance-debug:
  cmd.run:
    - name: scl enable python27 ". ./bin/activate; ./bin/buildout"
    - cwd: /home/{{ user }}/bccvl_buildout
    - user: {{ user }}
    - group: {{ user }}
    - unless: test -x /home/{{ user }}/bccvl_buildout/bin/instance-debug
    - require:
      - cmd: /home/{{ user }}/bccvl_buildout/bin/buildout
      - file: /home/{{ user }}/bccvl_buildout/etc/bccvl_celery.json
      - service: 4store
    - watch:
      - git: /home/{{ user }}/bccvl_buildout
      - file: /home/{{ user }}/bccvl_buildout/buildout.cfg

/etc/supervisord.d/plone.ini:
  file.managed:
    - source: salt://bccvl/plone/plone_supervisord.ini
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: supervisor
      - cmd: /home/{{ user }}/bccvl_buildout/bin/instance-debug
      - file: /home/{{ user }}/bccvl_buildout/etc/bccvl_celery.json
    - watch_in:
      - service: supervisord

/home/{{ user }}/bccvl_buildout/etc/plone.crt.pem:
  file.managed:
    - contents_pillar: plone:worker:sslcert
    - user: {{ user }}
    - group: {{ user }}
    - mode: 400
    - require:
      - cmd: /home/{{ user }}/bccvl_buildout/bin/instance-debug

/home/{{ user }}/bccvl_buildout/etc/plone.key.pem:
  file.managed:
    - contents_pillar: plone:worker:sslkey
    - user: {{ user }}
    - group: {{ user }}
    - mode: 400
    - require:
      - cmd: /home/{{ user }}/bccvl_buildout/bin/instance-debug

/etc/supervisord.d/plone_worker.ini:
  file.managed:
    - source: salt://bccvl/plone/plone_worker_supervisord.ini
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: supervisor
      - cmd: /home/{{ user }}/bccvl_buildout/bin/instance-debug
      - file: /home/{{ user }}/bccvl_buildout/etc/bccvl_celery.json
    - watch_in:
      - service: supervisord
