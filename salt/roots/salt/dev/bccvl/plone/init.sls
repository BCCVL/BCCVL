{% set user = salt['pillar.get']('plone:user', {'name': 'plone'}) %}

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
{{ user.name }}:
  user.present:
    {% if 'uid' in user %}
    - uid: {{ user.uid }}
    {% endif %}
    {% if 'gid' in user %}
    - gid: {{ user.gid }}
    {% endif %}
    {% if 'fullname' in user %}
    - fullname: {{ user.fullname }}
    {% endif %}
    - shell: /bin/bash
    - createhome: true
    - gid_from_name: true
    - system: true
  ssh_auth:
    - present
    - user: {{ user.name }}
    - comment: data_mover
    - name: {{ salt['pillar.get']('data_mover:ssh_pubkey') }}

/home/{{ user.name }}/.ssh/id_dsa:
  file.managed:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 0600
    - contents_pillar: {{ user.name }}:ssh_privkey
    - require:
      - user: {{ user.name }}

/home/{{ user.name }}/.ssh/id_dsa.pub:
  file.managed:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 0600
    - contents_pillar: {{ user.name }}:ssh_pubkey
    - require:
      - user: {{ user.name }}


# TODO: Dev only
# TODO: work around this here by moving src folder one level up ->
#       change mr.developer config
# clone buildout repo
/home/{{ user.name }}/bccvl_buildout:
  # TODO: Dev only
  file.directory:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 750
    - require:
      - user: {{ user.name }}
  # TODO: Dev only
  cmd.run:
    - name: |
        git init .
        git remote add -f origin https://github.com/BCCVL/bccvl_buildout.git
        git checkout {{ pillar['plone']['buildout']['branch'] }}
    - cwd: /home/{{ user.name }}/bccvl_buildout/
    - user: {{ user.name }}
    - group: {{ user.name }}
    - unless: test -d /home/{{ user.name }}/bccvl_buildout/.git
    - require:
      - user: {{ user.name }}
      - pkg: git
      - file: /home/{{ user.name }}/bccvl_buildout
  # TODO: Dev only
  git.latest:
    - name: https://github.com/BCCVL/bccvl_buildout.git
    - rev: {{ pillar['plone']['buildout']['branch'] }}
    - target: /home/{{ user.name }}/bccvl_buildout
    - user: {{ user.name }}
    - require:
      - user: {{ user.name }}
      - pkg: git
      - cmd: /home/{{ user.name }}/bccvl_buildout
  virtualenv.managed:
    - venv_bin: /usr/local/bin/python27-virtualenv
    - user: {{ user.name }}
    - cwd: /home/{{ user.name }}
    - require:
      - user: {{ user.name }}
      - git: /home/{{ user.name }}/bccvl_buildout
      - pkg: python27-python-virtualenv
      - file: /usr/local/bin/python27-virtualenv

/home/{{ user.name }}/bccvl_buildout/etc:
  file.directory:
    - user: {{ user.name }}
    - group: {{ user.name }}
    # TODO: Dev only: mode can only be set when not on synced folder
    #- mode: 750
    - require:
      - git: /home/{{ user.name }}/bccvl_buildout

# plone worker celery settings
/home/{{ user.name }}/bccvl_buildout/etc/bccvl_celery.json:
  file.managed:
    - source: salt://bccvl/plone/plone_worker.json
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - template: jinja
    - require:
      - file: /home/{{ user.name }}/bccvl_buildout/etc

/home/{{ user.name }}/bccvl_buildout/buildout.cfg:
  file.managed:
    - source: salt://bccvl/plone/plone_buildout.cfg
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 440
    - template: jinja
    - require:
      - git: /home/{{ user.name }}/bccvl_buildout

# create storage if necessary
{% if pillar['plone'].get('storage', false) %}
{{ pillar['plone']['storage']['root'] }}:
  file.directory:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 750
    - makedirs: True
    - require_in:
        - cmd: /home/{{ user.name }}/bccvl_buildout/bin/buildout
{% endif %}

/home/{{ user.name }}/bccvl_buildout/bin/buildout:
  cmd.run:
    - name: scl enable python27 ". ./bin/activate; python2.7 bootstrap.py"
    - cwd: /home/{{ user.name }}/bccvl_buildout
    - user: {{ user.name }}
    - group: {{ user.name }}
    - unless: test -x /home/{{ user.name }}/bccvl_buildout/bin/buildout
    - require:
      - file: /home/{{ user.name }}/bccvl_buildout/buildout.cfg
      - virtualenv: /home/{{ user.name }}/bccvl_buildout
      - pkg: gcc
      - pkg: gcc-c++
      - pkg: make
      - pkg: mercurial
      - pkg: zlib-devel
      - pkg: libjpeg-turbo-devel
      - pkg: freetype-devel
      - pkg: libtiff-devel

/home/{{ user.name }}/bccvl_buildout/bin/instance-debug:
  cmd.run:
    - name: scl enable python27 ". ./bin/activate; ./bin/buildout"
    - cwd: /home/{{ user.name }}/bccvl_buildout
    - user: {{ user.name }}
    - group: {{ user.name }}
    - unless: test -x /home/{{ user.name }}/bccvl_buildout/bin/instance-debug
    - require:
      - cmd: /home/{{ user.name }}/bccvl_buildout/bin/buildout
      - file: /home/{{ user.name }}/bccvl_buildout/etc/bccvl_celery.json
      - service: 4store
    - watch:
      - git: /home/{{ user.name }}/bccvl_buildout
      - file: /home/{{ user.name }}/bccvl_buildout/buildout.cfg

/etc/supervisord.d/plone.ini:
  file.managed:
    - source: salt://bccvl/plone/plone_supervisord.ini
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: supervisor
      - cmd: /home/{{ user.name }}/bccvl_buildout/bin/instance-debug
      - file: /home/{{ user.name }}/bccvl_buildout/etc/bccvl_celery.json
    - watch_in:
      - service: supervisord

/home/{{ user.name }}/bccvl_buildout/etc/plone.crt.pem:
  file.managed:
    - contents_pillar: plone:worker:sslcert
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 400
    - require:
      - cmd: /home/{{ user.name }}/bccvl_buildout/bin/instance-debug

/home/{{ user.name }}/bccvl_buildout/etc/plone.key.pem:
  file.managed:
    - contents_pillar: plone:worker:sslkey
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 400
    - require:
      - cmd: /home/{{ user.name }}/bccvl_buildout/bin/instance-debug

/etc/supervisord.d/plone_worker.ini:
  file.managed:
    - source: salt://bccvl/plone/plone_worker_supervisord.ini
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: supervisor
      - cmd: /home/{{ user.name }}/bccvl_buildout/bin/instance-debug
      - file: /home/{{ user.name }}/bccvl_buildout/etc/bccvl_celery.json
    - watch_in:
      - service: supervisord
