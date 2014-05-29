{% set user = salt['pillar.get']('data_mover:user', {'name': 'data_mover'}) %}

include:
  - supervisord
  - git
  - python27
  - bccvl.data_mover

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
    - user: {{ user.name }}
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
    - source: salt://bccvl/data_mover_worker/data_mover_worker.json
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - template: jinja
    - require:
      - file: /home/{{ user.name }}/worker

/etc/supervisord.d/data_mover_worker.ini:
  file.managed:
    - source: salt://bccvl/data_mover_worker/data_mover_worker_supervisord.ini
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
    - contents_pillar: data_mover_worker:sslcert
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 400
    - require:
      - file: /home/{{ user.name }}/worker

/home/{{ user.name }}/worker/worker.key.pem:
  file.managed:
    - contents_pillar: data_mover_worker:sslkey
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 400
    - require:
      - file: /home/{{ user.name }}/worker
