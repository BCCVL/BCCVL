{% set user = salt['pillar.get']('data_mover:user', {'name': 'data_mover'}) %}

include:
  - supervisord
  - git
  - gcc
  - python27

# TODO: enable proper updating of sources and build script
#       (e.g. trigger rebuild if new source is available)
# TODO: also need known_host keys for worker(s) etc...
# TODO: manage destinations_config.json here as well?

# Requirements

libyaml:
  pkg.installed

libyaml-devel:
  pkg.installed

# PyCrypto
gmp-devel:
  pkg.installed


# Create data_mover user
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
  ssh_known_hosts.present:
    - names:
      - localhost
      - 127.0.0.1
    - user: {{ user.name }}
    - require:
      - user: {{ user.name }}

/home/{{ user.name }}/.ssh/id_dsa:
  file.managed:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 0600
    - contents_pillar: data_mover:ssh_privkey
    - require:
      - user: {{ user.name }}
      - ssh_known_hosts: {{ user.name }}

/home/{{ user.name }}/.ssh/id_dsa.pub:
  file.managed:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 0600
    - contents_pillar: data_mover:ssh_pubkey
    - require:
      - user: {{ user.name }}
      - ssh_known_hosts: {{ user.name }}

# Clone Data Mover repo
/home/{{ user.name }}/bccvl_data_mover:
  file.directory:
    - user: {{ user.name }}
    - group: {{ user.name }}
    # TODO: Dev only: mode can only be set if not synced folder
    #- mode: 750
    - require:
      - user: {{ user.name }}
  git.latest:
    - name: https://github.com/BCCVL/bccvl_data_mover.git
    - rev: develop
    - target: /home/{{ user.name }}/bccvl_data_mover
    - user: {{ user.name }}
    - group: {{ user.name }}
    - require:
      - user: {{ user.name }}
      - file: /home/{{ user.name }}/bccvl_data_mover
      - pkg: git

/home/{{ user.name }}/bccvl_data_mover/data_mover:
   virtualenv.managed:
    - venv_bin: /usr/local/bin/python27-virtualenv
    - user: {{ user.name }}
    - cwd: /home/{{ user.name }}/bccvl_data_mover
    - require:
      - pkg: python27-python-virtualenv
      - file: /usr/local/bin/python27-virtualenv
      - git: /home/{{ user.name }}/bccvl_data_mover

# TODO: can I find all workers via mine or similar?
/home/{{ user.name }}/bccvl_data_mover/data_mover/data_mover/destination_config.json:
  file.managed:
    - source:
      - salt://bccvl/data_mover/data_mover_destination_config.json
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - require:
      - git: /home/{{ user.name }}/bccvl_data_mover

/home/{{ user.name }}/bccvl_data_mover/data_mover/data_mover_buildout.cfg:
  file.managed:
    - source:
      - salt://bccvl/data_mover/data_mover_buildout.cfg
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - require:
      - git: /home/{{ user.name }}/bccvl_data_mover

/home/{{ user.name }}/bccvl_data_mover/data_mover/bin/buildout:
  cmd.run:
    - cwd: /home/{{ user.name }}/bccvl_data_mover/data_mover/
    - name: scl enable python27 ". bin/activate; python2.7 bootstrap.py -c data_mover_buildout.cfg"
    - user: {{ user.name }}
    - group: {{ user.name }}
    - unless: test -x /home/{{ user.name }}/bccvl_data_mover/data_mover/bin/buildout
    - require:
      - file: /home/{{ user.name }}/bccvl_data_mover/data_mover/data_mover_buildout.cfg
      - git: /home/{{ user.name }}/bccvl_data_mover
      - pkg: python27-python
      - virtualenv: /home/{{ user.name }}/bccvl_data_mover/data_mover

/home/{{ user.name }}/bccvl_data_mover/data_mover/bin/pserve:
  cmd.run:
    - cwd: /home/{{ user.name }}/bccvl_data_mover/data_mover/
    - name: scl enable python27 ". bin/activate; ./bin/buildout  -c data_mover_buildout.cfg"
    - user: {{ user.name }}
    - group: {{ user.name }}
    - require:
      - cmd: /home/{{ user.name }}/bccvl_data_mover/data_mover/bin/buildout
      - pkg: gcc
      - pkg: libyaml-devel
      - pkg: python27-python-devel
      - pkg: gmp-devel
    - watch:
      - git: /home/{{ user.name }}/bccvl_data_mover

/home/{{ user.name }}/bccvl_data_mover/data_mover/production.sqlite:
  cmd.run:
    - cwd: /home/{{ user.name }}/bccvl_data_mover/data_mover/
    - user: {{ user.name }}
    - group: {{ user.name }}
    - name: scl enable python27 ". bin/activate; ./bin/initialize_data_mover_db production.ini"
    - unless: test -f /home/{{ user.name }}/bccvl_data_mover/data_mover/production.sqlite
    - watch:
      - cmd: /home/{{ user.name }}/bccvl_data_mover/data_mover/bin/pserve

/home/{{ user.name }}/bccvl_data_mover/data_mover/data_mover.ini:
  file.managed:
    - source:
      - salt://bccvl/data_mover/data_mover.ini
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - require:
      - git: /home/{{ user.name }}/bccvl_data_mover
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
      - cmd: /home/{{ user.name }}/bccvl_data_mover/data_mover/production.sqlite
      - file: /home/{{ user.name }}/bccvl_data_mover/data_mover/data_mover.ini
      - file: /home/{{ user.name }}/bccvl_data_mover/data_mover/data_mover/destination_config.json
    - watch_in:
      - service: supervisord
