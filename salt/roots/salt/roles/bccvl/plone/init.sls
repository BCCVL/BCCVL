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
  - bccvl.plone.plone_virtualenv

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
    - groups:
      - bccvl_user
    - require:
      - group: bccvl_user
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

/home/{{ user.name }}/bccvl_buildout/etc:
  file.directory:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 750
    - require:
      - virtualenv: plone_virtualenv

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
      - virtualenv: plone_virtualenv

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
      - virtualenv: plone_virtualenv
      - pkg: gcc
      - pkg: gcc-c++
      - pkg: make
      - pkg: mercurial
      - pkg: zlib-devel
      - pkg: libjpeg-turbo-devel
      - pkg: freetype-devel
      - pkg: libtiff-devel

# TODO: will this run on update? (see watch) or would unless: override
# any watch state... wolud this be different with cmd.wait?
/home/{{ user.name }}/bccvl_buildout/bin/instance-debug:
  cmd.wait:
    - name: scl enable python27 ". ./bin/activate; ./bin/buildout"
    - cwd: /home/{{ user.name }}/bccvl_buildout
    - user: {{ user.name }}
    - group: {{ user.name }}
    - require:
      - cmd: /home/{{ user.name }}/bccvl_buildout/bin/buildout
      - file: /home/{{ user.name }}/bccvl_buildout/etc/bccvl_celery.json
      - service: 4store
    - watch:
      - git: plone_virtualenv
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
