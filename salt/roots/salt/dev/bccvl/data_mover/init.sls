{% set user = salt['pillar.get']('data_mover:user', 'data_mover') %}

include:
  - supervisord
  - git
  - gcc
  - python27

# TODO: enable proper updating of sources and build script
#       (e.g. trigger rebuild if new source is available)

# Requirements

libyaml:
  pkg.installed

libyaml-devel:
  pkg.installed

# PyCrypto
gmp-devel:
  pkg.installed


# Create data_mover user
{{ user }}:
  user.present:
    - fullname: Data Mover
    - shell: /bin/bash
    - createhome: true
    - gid_from_name: true
    - system: true
  ssh_known_hosts.present:
    - names:
      - localhost
      - 127.0.0.1
    - user: {{ user }}
    - require:
      - user: {{ user }}

/home/{{ user }}/.ssh/id_dsa:
  file.managed:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 0600
    - contents_pillar: data_mover:ssh_privkey
    - require:
      - user: {{ user }}

/home/{{ user }}/.ssh/id_dsa.pub:
  file.managed:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 0600
    - contents_pillar: data_mover:ssh_pubkey
    - require:
      - user: {{ user }}

# Clone Data Mover repo
/home/{{ user }}/bccvl_data_mover:
  git.latest:
    - name: https://github.com/BCCVL/bccvl_data_mover.git
    - rev: develop
    - target: /home/{{ user }}/bccvl_data_mover
    - user: {{ user }}
    - group: {{ user }}
    - require:
      - user: {{ user }}
      - pkg: git

/home/{{ user }}/bccvl_data_mover/data_mover:
   virtualenv.managed:
    - venv_bin: /usr/local/bin/python27-virtualenv
    - user: {{ user }}
    - runas: {{ user }}
    - cwd: /home/{{ user }}/bccvl_data_mover
    - require:
      - pkg: python27-python-virtualenv
      - file: /usr/local/bin/python27-virtualenv
      - git: /home/{{ user }}/bccvl_data_mover

# TODO: can I find all workers via mine or similar?
/home/{{ user }}/bccvl_data_mover/data_mover/data_mover/destination_config.json:
  file.managed:
    - source:
      - salt://bccvl/data_mover/data_mover_destination_config.json
    - template: jinja
    - user: {{ user }}
    - group: {{ user }}
    - mode: 640
    - require:
      - git: /home/{{ user }}/bccvl_data_mover

/home/{{ user }}/bccvl_data_mover/data_mover/data_mover_buildout.cfg:
  file.managed:
    - source:
      - salt://bccvl/data_mover/data_mover_buildout.cfg
    - template: jinja
    - user: {{ user }}
    - group: {{ user }}
    - mode: 640
    - require:
      - git: /home/{{ user }}/bccvl_data_mover

/home/{{ user }}/bccvl_data_mover/data_mover/bin/buildout:
  cmd.run:
    - cwd: /home/{{ user }}/bccvl_data_mover/data_mover/
    - name: scl enable python27 ". bin/activate; python2.7 bootstrap.py -c data_mover_buildout.cfg"
    - user: {{ user }}
    - group: {{ user }}
    - unless: test -x /home/{{ user }}/bccvl_data_mover/data_mover/bin/buildout
    - require:
      - file: /home/{{ user }}/bccvl_data_mover/data_mover/data_mover_buildout.cfg
      - git: /home/{{ user }}/bccvl_data_mover
      - pkg: python27-python
      - virtualenv: /home/{{ user }}/bccvl_data_mover/data_mover

/home/{{ user }}/bccvl_data_mover/data_mover/bin/pserve:
  cmd.run:
    - cwd: /home/{{ user }}/bccvl_data_mover/data_mover/
    - name: scl enable python27 ". bin/activate; ./bin/buildout  -c data_mover_buildout.cfg"
    - user: {{ user }}
    - group: {{ user }}
    - unless: test -x /home/{{ user }}/bccvl_data_mover/data_mover/bin/pserve
    - require:
      - cmd: /home/{{ user }}/bccvl_data_mover/data_mover/bin/buildout
      - pkg: gcc
      - pkg: libyaml-devel
      - pkg: python27-python-devel
      - pkg: gmp-devel

/home/{{ user }}/bccvl_data_mover/data_mover/production.sqlite:
  cmd.run:
    - cwd: /home/{{ user }}/bccvl_data_mover/data_mover/
    - user: {{ user }}
    - group: {{ user }}
    - name: scl enable python27 ". bin/activate; ./bin/initialize_data_mover_db production.ini"
    - unless: test -f /home/{{ user }}/bccvl_data_mover/data_mover/production.sqlite
    - watch:
      - cmd: /home/{{ user }}/bccvl_data_mover/data_mover/bin/pserve

/home/{{ user }}/bccvl_data_mover/data_mover/data_mover.ini:
  file.managed:
    - source:
      - salt://bccvl/data_mover/data_mover.ini
    - template: jinja
    - user: {{ user }}
    - group: {{ user }}
    - mode: 640
    - require:
      - git: /home/{{ user }}/bccvl_data_mover
    - watch_in:
      - service: supervisord

/etc/supervisord.d/data_mover.ini:
  file.managed:
    - source: salt://bccvl/data_mover/data_mover_supervisord.ini
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: supervisor
      - cmd: /home/{{ user }}/bccvl_data_mover/data_mover/production.sqlite
      - file: /home/{{ user }}/bccvl_data_mover/data_mover/data_mover.ini
      - file: /home/{{ user }}/bccvl_data_mover/data_mover/data_mover/destination_config.json
    - watch_in:
      - service: supervisord
