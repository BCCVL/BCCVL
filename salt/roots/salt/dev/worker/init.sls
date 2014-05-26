{% set user = salt['pillar.get']('worker:user', 'bccvl') %}

include:
  - pki
  - rsyslog
  - R
  - supervisord
  - git
  - python27
  - worker.rlibs
  - worker.maxent
  - worker.biodiverse


####### setup rsyslog
/etc/rsyslog.d/bccvl.conf:
  file.managed:
    - source: salt://worker/rsyslog_bccvl.conf
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog


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
    - name: {{ salt['pillar.get']('worker:data_mover_ssh_pubkey') }}


/home/{{ user.name }}/worker:
  file.directory:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 750
    - require:
      - user: {{ user.name }}
  virtualenv.managed:
    - venv_bin: /usr/local/bin/python27-virtualenv
    - user: {{ user.name }}
    - cwd: /home/{{ user.name }}
    - require:
      - user: {{ user.name }}
      - pkg: python27-python-virtualenv
      - file: /home/{{ user.name }}/worker
      - file: /usr/local/bin/python27-virtualenv

### TODO: dev only:
##  how do we manage different sources for git?
/home/{{ user.name }}/worker/org.bccvl.tasks:
  git.latest:
    - name: https://github.com/BCCVL/org.bccvl.tasks.git
    - target: /home/{{ user.name }}/worker/org.bccvl.tasks
    - rev: develop
    - runas: {{ user.name }}
    - require:
      - user: {{ user.name }}
      - pkg: git
      - file: /home/{{ user.name }}/worker

#### TODO: Dev only:
## install editable version of tool
##  ... run this step if the above git clone reports changes
worker_virtualenv:
  cmd.wait:
    - name: scl enable python27 ". bin/activate; pip install -e org.bccvl.tasks"
    - cwd: /home/{{ user.name }}/worker
    - user: {{ user.name }}
    - require:
      - pkg: python27-python-devel
      - pkg: python27-python-virtualenv
      - virtualenv: /home/{{ user.name }}/worker
    - watch:
      - git: /home/{{ user.name }}/worker/org.bccvl.tasks

### TODO: Prod only ...
### build virtualenv:
# worker_virtualenv:
#   cmd.run:
#     - name: scl enable python27 ". bin/activate; pip install -U https://github.com/BCCVL/org.bccvl.tasks/archive/develop.tar.gz#egg=org.bccvl.tasks"
#     - cwd: /home/{{ user.name }}
#     - user: {{ user.name }}
#     - require:
#       - pkg: python27-python-devel
#       - pkg: python27-python-virtualenv
#       - virtualenv: /home/{{ user.name }}/worker

/home/{{ user.name }}/worker/celery.json:
  file.managed:
    - source: salt://worker/worker_celery.json
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - template: jinja
    - require:
      - file: /home/{{ user.name }}/worker

/etc/supervisord.d/worker.ini:
  file.managed:
    - source: salt://worker/worker_supervisor.ini
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: supervisor
      - file: /home/{{ user.name }}/worker/celery.json
      - user: {{ user.name }}
    - watch_in:
      - service: supervisord

/home/{{ user.name }}/worker/worker.crt.pem:
  file.managed:
    - contents_pillar: worker:sslcert
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 400
    - require:
      - file: /home/{{ user.name }}/worker

/home/{{ user.name }}/worker/worker.key.pem:
  file.managed:
    - contents_pillar: worker:sslkey
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 400
    - require:
      - file: /home/{{ user.name }}/worker
