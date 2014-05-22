include:
  - supervisord
  - git
  - virtualenv
  - bccvl.data_mover

/home/data_mover/worker:
   virtualenv.managed:
    - user: data_mover
    - cwd: /home/data_mover
    - requirements: salt://bccvl/data_mover_worker/data_mover_worker_requirements.txt
    - require:
      - user: data_mover
      - pkg: git
      - pkg: virtualenv

/home/data_mover/worker/celery.json:
  file.managed:
    - source: salt://bccvl/data_mover_worker/data_mover_worker.json
    - user: data_mover
    - group: data_mover
    - mode: 640
    - template: jinja
    - require:
      - virtualenv: /home/data_mover/worker

/home/data_mover/worker/worker.crt.pem:
  file.managed:
    - contents_pillar: data_mover_worker:sslcert
    - user: data_mover
    - group: data_mover
    - mode: 400
    - require:
      - virtualenv: /home/data_mover/worker

/home/data_mover/worker/worker.key.pem:
  file.managed:
    - contents_pillar: data_mover_worker:sslkey
    - user: data_mover
    - group: data_mover
    - mode: 400
    - require:
      - virtualenv: /home/data_mover/worker

/etc/supervisord.d/data_mover_worker.ini:
  file.managed:
    - source: salt://bccvl/data_mover_worker/data_mover_worker_supervisord.ini
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: supervisor
      - file: /home/data_mover/worker/celery.json
      - user: data_mover
    - watch_in:
      - service: supervisord
