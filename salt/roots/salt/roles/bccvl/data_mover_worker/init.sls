{% set user = salt['pillar.get']('data_mover:user', {'name': 'data_mover'}) %}
{% set versions = salt['pillar.get']('versions') %}
{% set private = salt['pillar.get']('private') %}

include:
  - gdal
  - proj4
  - exempi
  - supervisord
  - git
  - libffi-devel
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

/home/{{ user.name }}/worker/requirements.txt:
  file.managed:
    - source: salt://bccvl/data_mover_worker/data_mover_worker_requirements.txt
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - template: jinja
    - require:
      - file: /home/{{ user.name }}/worker

data_mover_worker_virtualenv_upgrade_pip:
  cmd.run:
    - name: scl enable python27 ". bin/activate; pip install --index-url {{ private.pypi_index_url }} --upgrade six packaging appdirs pip=={{ versions.pip }}; pip install --index-url {{ private.pypi_index_url }} --upgrade setuptools=={{ versions.setuptools }}"
    - cwd: /home/{{ user.name }}/worker
    - unless: scl enable python27 ". bin/activate; pip -V | grep 'pip {{ versions.pip }} '"
    - user: {{ user.name }}
    - require:
      - virtualenv: /home/{{ user.name }}/worker

data_mover_worker_virtualenv:
  cmd.wait:
    - name: scl enable python27 ". bin/activate; pip install --index-url {{ private.pypi_index_url }} guscmversion; pip install --index-url {{ private.pypi_index_url }} -r requirements.txt"
    - cwd: /home/{{ user.name }}/worker
    - user: {{ user.name }}
    - require:
      - pkg: python27-python-devel
      - pkg: python27-python-virtualenv
      - virtualenv: /home/{{ user.name }}/worker
      - cmd: data_mover_worker_virtualenv_upgrade_pip
    - watch:
      - file: /home/{{ user.name }}/worker/requirements.txt

/home/{{ user.name }}/worker/celery.json:
  file.absent
  # file.managed:
  #   - source: salt://bccvl/data_mover_worker/data_mover_worker.json
  #   - user: {{ user.name }}
  #   - group: {{ user.name }}
  #   - mode: 640
  #   - template: jinja
  #   - require:
  #     - file: /home/{{ user.name }}/worker

/home/{{ user.name }}/worker/celeryconfig.py:
  file.managed:
    - source: salt://bccvl/data_mover_worker/data_mover_worker.py
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - template: jinja
    - require:
      - file: /home/{{ user.name }}/worker

/home/{{ user.name }}/worker/bccvl.ini:
  file.managed:
    - source: salt://bccvl/data_mover_worker/data_mover_worker.ini
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
      - file: /home/{{ user.name }}/worker/celeryconfig.py
      - file: /home/{{ user.name }}/worker/bccvl.ini
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
