{% set user = salt['pillar.get']('visualiser:user', 'visualiser') %}

include:
  - gdal
  - proj4
  - geos
  - virtualenv
  - git
  - openssl-devel
  - python27
  - gcc
  - subversion
  - libpng
  - zlib
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


{{ user }}:
  user.present:
    - fullname: Visualiser
    - shell: /bin/bash
    - createhome: true
    - gid_from_name: true
    - system: true
  ssh_auth:
    - present
    - user: visualiser
    - names:
      - {{ pillar['data_mover']['ssh_pubkey'] }}

/home/visualiser/.ssh:
  file.directory:
    - user: visualiser
    - group: visualiser
    - mode: 0700
    - require:
      - user: visualiser

/home/visualiser/.ssh/id_rsa:
  file.managed:
    - user: visualiser
    - group: visualiser
    - mode: 0400
    - contents_pillar: visualiser:ssh_privkey
    - require:
      - file: /home/visualiser/.ssh

/home/visualiser/.ssh/id_rsa.pub:
  file.managed:
    - user: visualiser
    - group: visualiser
    - mode: 0400
    - contents_pillar: visualiser:ssh_pubkey
    - require:
      - file: /home/visualiser/.ssh

Visualiser Clone:
  git.latest:
    - name: https://github.com/BCCVL/BCCVL_Visualiser.git
    - rev: master
    - target: /home/visualiser/BCCVL_Visualiser
    - runas: visualiser
    - require:
      - user: visualiser
      - pkg: git

# TODO: move Requirements one up
Visualiser Virtualenv:
   virtualenv.managed:
    - name: /home/visualiser/BCCVL_Visualiser/env
    - venv_bin: /usr/local/bin/python27-virtualenv
    - user: visualiser
    - runas: visualiser
    - cwd: /home/visualiser/BCCVL_Visualiser/BCCVL_Visualiser/
    - require:
      - user: visualiser
      - pkg: python27-python-virtualenv
      - file: /usr/local/bin/python27-virtualenv

Visualiser Virtualenv Numpy:
  cmd.run:
    - name: scl enable python27 "/home/visualiser/BCCVL_Visualiser/env/bin/pip install numpy"
    - unless: scl enable python27 "/home/visualiser/BCCVL_Visualiser/env/bin/pip show numpy | grep -q 'Version:'"
    - user: visualiser
    - group: visualiser
    - require:
      - virtualenv: Visualiser Virtualenv

Visualiser Virtualenv Matplotlib:
  cmd.run:
    - name: scl enable python27 "/home/visualiser/BCCVL_Visualiser/env/bin/pip install matplotlib"
    - unless: scl enable python27 "/home/visualiser/BCCVL_Visualiser/env/bin/pip show matplotlib | grep -q 'Version:'"
    - user: visualiser
    - group: visualiser
    - require:
      - cmd: Visualiser Virtualenv Numpy

Visualiser Buildout Config:
  file.managed:
    - name: /home/visualiser/BCCVL_Visualiser/BCCVL_Visualiser/buildout.cfg
    - source:
      - salt://bccvl/visualiser/visualiser_buildout.cfg
    - user: visualiser
    - group: visualiser
    - mode: 640
    - template: jinja
    - defaults:
        site_hostname: {{ pillar['visualiser']['hostname'] }}
    - require:
      - git: Visualiser Clone

Visualiser Bootstrap Buildout:
  cmd.run:
    - cwd: /home/visualiser/BCCVL_Visualiser/BCCVL_Visualiser
    - user: visualiser
    - group: visualiser
    - name: scl enable python27 "../env/bin/python bootstrap.py"
    - unless: test -x /home/visualiser/BCCVL_Visualiser/BCCVL_Visualiser/bin/buildout
    - require:
      - cmd: Visualiser Virtualenv Matplotlib
      - file: Visualiser Buildout Config

Visualiser Buildout:
  cmd.run:
    - cwd: /home/visualiser/BCCVL_Visualiser/BCCVL_Visualiser
    - user: visualiser
    - group: visualiser
    - name: scl enable python27 "./bin/buildout"
    - require:
      - cmd: Visualiser Bootstrap Buildout

/etc/supervisord.d/visualiser.ini:
  file.managed:
    - user: root
    - group: root
    - mode: 440
    - source: salt://bccvl/visualiser/visualiser_supervisord.ini
    - template: jinja
    - require:
      - pkg: supervisor
    - watch_in:
      - service: supervisord

/home/visualiser/BCCVL_Visualiser/BCCVL_Visualiser/var/log:
# run  this only if requirements are fine otherwise a subsequent git
# clone will fail because of directory exists
  file.directory:
    - user: visualiser
    - group: visualiser
    - makedirs: True
    - require:
      - git: Visualiser Clone
    - require_in:
      - service: supervisord
