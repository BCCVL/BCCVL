{% set user = salt['pillar.get']('worker:user', 'bccvl') %}


include:
  - pki
  - rsyslog
  - R
  - supervisord
  - git
  - python27
  - worker.rlibs
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


{{ user }}:
  user.present:
    - fullname: BCCVL Worker
    - shell: /bin/bash
    - createhome: true
    - gid_from_name: true
    - system: true
  ssh_auth:
    - present
    - user: {{ user }}
    - comment: data_mover
    - name: {{ salt['pillar.get']('worker:data_mover_ssh_pubkey') }}


worker_virtualenv:
  cmd.run:
    - name: |
        scl enable python27 "virtualenv worker"
        cd worker
        scl enable python27 ". bin/activate; pip install -U https://github.com/BCCVL/org.bccvl.tasks/archive/develop.tar.gz#egg=org.bccvl.tasks"
    - cwd: /home/{{ user }}
    - creates: /home/{{ user }}/worker/bin/celery
    # - unless: test -x /home/{{ user }}/worker/bin/celery
    - require:
      - pkg: git
      - pkg: python27-python-devel
      - pkg: python27-python-virtualenv
      - user: {{ user }}

/home/{{ user }}/worker/celery.json:
  file.managed:
    - source: salt://worker/worker_celery.json
    - user: {{ user }}
    - group: {{ user }}
    - mode: 640
    - template: jinja
    - require:
      - cmd: worker_virtualenv

/etc/supervisord.d/worker.ini:
  file.managed:
    - source: salt://worker/worker_supervisor.ini
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: supervisor
      - file: /home/{{ user }}/worker/celery.json
      - user: {{ user }}
    - watch_in:
      - service: supervisord

/home/{{ user }}/worker/worker.crt.pem:
  file.managed:
    - contents_pillar: worker:sslcert
    - user: {{ user }}
    - group: {{ user }}
    - mode: 400
    - require:
      - cmd: worker_virtualenv

/home/{{ user }}/worker/worker.key.pem:
  file.managed:
    - contents_pillar: worker:sslkey
    - user: {{ user }}
    - group: {{ user }}
    - mode: 400
    - require:
      - cmd: worker_virtualenv
