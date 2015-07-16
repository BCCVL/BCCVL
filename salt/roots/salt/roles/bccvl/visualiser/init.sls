{% set user = salt['pillar.get']('visualiser:user', {'name': 'visualiser'}) %}
{% set visualiser = salt['pillar.get']('visualiser', {}) %}

include:
  - gdal
  - proj4
  - geos
  - git
  - openssl-devel
  - python27
  - gcc
  - subversion
  - libpng
  - zlib
  - libcurl
  - libjpeg-turbo
  - blas
  - lapack
  - atlas
  - openjdk
  - libxml2
  - readline
  - gd
  - giflib
  - bzip2
  - patch
  - ncurses
  - tk
  - wget


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
    - names:
      - {{ pillar['data_mover']['ssh_pubkey'] }}

/home/{{ user.name }}/.ssh:
  file.directory:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 0700
    - require:
      - user: {{ user.name }}

/home/{{ user.name }}/.ssh/id_rsa:
  file.managed:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 0400
    - contents_pillar: visualiser:ssh_privkey
    - require:
      - file: /home/{{ user.name }}/.ssh

/home/{{ user.name }}/.ssh/id_rsa.pub:
  file.managed:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 0400
    - contents_pillar: visualiser:ssh_pubkey
    - require:
      - file: /home/{{ user.name }}/.ssh

Visualiser Clone:
  git.latest:
    - name: https://github.com/BCCVL/BCCVL_Visualiser.git
    - rev: {{ pillar['versions']['visualiser'] }}
    - target: /home/{{ user.name }}/BCCVL_Visualiser
    - user: {{ user.name }}
    - require:
      - user: {{ user.name }}
      - pkg: git

# TODO: move Requirements one up
Visualiser Virtualenv:
   virtualenv.managed:
    - name: /home/{{ user.name }}/BCCVL_Visualiser/env
    - venv_bin: /usr/local/bin/python27-virtualenv
    - user: {{ user.name }}
    - cwd: /home/{{ user.name }}/BCCVL_Visualiser/BCCVL_Visualiser/
    - require:
      - user: {{ user.name }}
      - pkg: python27-python-virtualenv
      - file: /usr/local/bin/python27-virtualenv

Visualiser Virtualenv Nose:
  cmd.run:
    - name: scl enable python27 "/home/{{ user.name }}/BCCVL_Visualiser/env/bin/pip install nose=={{ pillar['versions']['nose'] }}"
    - unless: scl enable python27 "/home/{{ user.name }}/BCCVL_Visualiser/env/bin/pip show nose | grep -q 'Version:'"
    - user: {{ user.name }}
    - group: {{ user.name }}
    - require:
      - virtualenv: Visualiser Virtualenv

Visualiser Virtualenv Numpy:
  cmd.run:
    - name: scl enable python27 "/home/{{ user.name }}/BCCVL_Visualiser/env/bin/pip install numpy=={{ pillar['versions']['numpy'] }}"
    - unless: scl enable python27 "/home/{{ user.name }}/BCCVL_Visualiser/env/bin/pip show numpy | grep -q 'Version:'"
    - user: {{ user.name }}
    - group: {{ user.name }}
    - require:
      - virtualenv: Visualiser Virtualenv

Visualiser Virtualenv Mock:
  cmd.run:
    - name: scl enable python27 "/home/{{ user.name }}/BCCVL_Visualiser/env/bin/pip install mock=={{ pillar['versions']['mock'] }}"
    - unless: scl enable python27 "/home/{{ user.name }}/BCCVL_Visualiser/env/bin/pip show mock | grep -q 'Version:'"
    - user: {{ user.name }}
    - group: {{ user.name }}
    - require:
      - virtualenv: Visualiser Virtualenv

Visualiser Virtualenv Matplotlib:
  cmd.run:
    - name: scl enable python27 "/home/{{ user.name }}/BCCVL_Visualiser/env/bin/pip install matplotlib=={{ pillar['versions']['matplotlib'] }}"
    - unless: scl enable python27 "/home/{{ user.name }}/BCCVL_Visualiser/env/bin/pip show matplotlib | grep -q 'Version:'"
    - user: {{ user.name }}
    - group: {{ user.name }}
    - require:
      - cmd: Visualiser Virtualenv Numpy
      - cmd: Visualiser Virtualenv Nose
      - cmd: Visualiser Virtualenv Mock

Visualiser Buildout Config:
  file.managed:
    - name: /home/{{ user.name }}/BCCVL_Visualiser/BCCVL_Visualiser/buildout.cfg
    - source:
      - salt://bccvl/visualiser/visualiser_buildout.cfg
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - template: jinja
    - defaults:
        site_hostname: {{ pillar['visualiser']['hostname'] }}
    - require:
      - git: Visualiser Clone

Visualiser Production INI:
  file.managed:
    - name: /home/{{ user.name }}/BCCVL_Visualiser/BCCVL_Visualiser/bccvl_production.ini
    - source: salt://bccvl/visualiser/visualiser_production.ini
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - template: jinja
    - require:
      - git: Visualiser Clone

Visualiser Bootstrap Buildout:
  cmd.run:
    - cwd: /home/{{ user.name }}/BCCVL_Visualiser/BCCVL_Visualiser
    - user: {{ user.name }}
    - group: {{ user.name }}
    - name: scl enable python27 "../env/bin/python bootstrap.py -v {{ pillar['versions']['zc.buildout'] }}"
    - unless: test -x /home/{{ user.name }}/BCCVL_Visualiser/BCCVL_Visualiser/bin/buildout
    - require:
      - cmd: Visualiser Virtualenv Matplotlib
      - file: Visualiser Buildout Config

Visualiser Buildout:
  cmd.run:
    - cwd: /home/{{ user.name }}/BCCVL_Visualiser/BCCVL_Visualiser
    - user: {{ user.name }}
    - group: {{ user.name }}
    - name: scl enable python27 "./bin/buildout"
    - require:
      - cmd: Visualiser Bootstrap Buildout

Visualiser Files Root:
  file.directory:
    - name: {{ visualiser.get('tmp', '/tmp') }}/bccvl
    - user: {{ user.name }}
    - group: {{ user.name }}
    - makedirs: True
    - mode: 750

Visualiser Public Dir:
  file.directory:
    - name: {{ visualiser.get('tmp', '/tmp') }}/visualiser_public
    - user: {{ user.name }}
    - group: {{ user.name }}
    - makedirs: True
    - mode: 750

/etc/supervisord.d/visualiser.ini:
  file.managed:
    - user: root
    - group: root
    - mode: 440
    - source: salt://bccvl/visualiser/visualiser_supervisord.ini
    - template: jinja
    - require:
      - file: Visualiser Files Root
      - file: Visualiser Public Dir
      - file: Visualiser Production INI
      - pkg: supervisor
    - watch_in:
      - service: supervisord

/home/{{ user.name }}/BCCVL_Visualiser/BCCVL_Visualiser/var/log:
# run  this only if requirements are fine otherwise a subsequent git
# clone will fail because of directory exists
  file.directory:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - makedirs: True
    - require:
      - git: Visualiser Clone
    - require_in:
      - service: supervisord
