{% set user = salt['pillar.get']('data_mover:user', {'name': 'data_mover'}) %}

include:
  - supervisord
  - git
  - gcc
  - python27
  - bccvl.data_mover.data_mover_source

# TODO: enable proper updating of sources and build script
#       (e.g. trigger rebuild if new source is available)
# TODO: also need known_host keys for worker(s) etc...

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

/home/{{ user.name }}:
  file.directory:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 0750
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

/home/{{ user.name }}/bccvl_data_mover/data_mover:
   virtualenv.managed:
    - venv_bin: /usr/local/bin/python27-virtualenv
    - user: {{ user.name }}
    - cwd: /home/{{ user.name }}/bccvl_data_mover
    - require:
      - pkg: python27-python-virtualenv
      - file: /usr/local/bin/python27-virtualenv
      - git: data_mover_source

/home/{{ user.name }}/bccvl_data_mover/data_mover/buildout.cfg:
  file.managed:
    - source:
      - salt://bccvl/data_mover/data_mover_buildout.cfg
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - require:
      - git: data_mover_source

/home/{{ user.name }}/bccvl_data_mover/data_mover/bin/buildout:
  cmd.run:
    - cwd: /home/{{ user.name }}/bccvl_data_mover/data_mover/
    - name: scl enable python27 ". bin/activate; python2.7 bootstrap.py -v {{ pillar['versions']['zc.buildout'] }}"
    - user: {{ user.name }}
    - group: {{ user.name }}
    - unless: test -x /home/{{ user.name }}/bccvl_data_mover/data_mover/bin/buildout
    - require:
      - file: /home/{{ user.name }}/bccvl_data_mover/data_mover/buildout.cfg
      - git: data_mover_source
      - pkg: python27-python
      - virtualenv: /home/{{ user.name }}/bccvl_data_mover/data_mover

/home/{{ user.name }}/bccvl_data_mover/data_mover/bin/pserve:
  cmd.run:
    - cwd: /home/{{ user.name }}/bccvl_data_mover/data_mover/
    - name: scl enable python27 ". bin/activate; ./bin/buildout"
    - user: {{ user.name }}
    - group: {{ user.name }}
    - require:
      - cmd: /home/{{ user.name }}/bccvl_data_mover/data_mover/bin/buildout
      - pkg: gcc
      - pkg: libyaml-devel
      - pkg: python27-python-devel
      - pkg: gmp-devel
    - watch:
      - git: data_mover_source

/home/{{ user.name }}/bccvl_data_mover/data_mover/data_mover.ini:
  file.managed:
    - source:
      - salt://bccvl/data_mover/data_mover.ini
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - require:
      - git: data_mover_source
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
      - file: /home/{{ user.name }}/bccvl_data_mover/data_mover/data_mover.ini
    - watch_in:
      - service: supervisord
