{% set user = salt['pillar.get']('worker:user', {'name': 'bccvl'}) %}
{% set versions = salt['pillar.get']('versions') %}

include:
  - pki
  - rsyslog
  - R
  - supervisord
  - gdal
  - exempi
  - libyaml
  - libffi-devel
  - git
  - python27
  - worker.rlibs
  - worker.maxent
  - worker.biodiverse

/etc/sysconfig/iptables:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - source:
      - salt://worker/iptables
      #- salt://roles/{{ grains.get('role') }}/etc/sysconfig/iptables
      #- salt://hosts/{{ grains.host }}/etc/sysconfig/iptables
      #- salt://defaults/etc/sysconfig/iptables
{% if salt['cmd.retcode']('service iptables status') == 0 %}
service iptables restart:
  cmd.wait:
    - watch:
      - file: /etc/sysconfig/iptables
{% endif %}


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
    - groups:
      - bccvl_user
    - require:
      - group: bccvl_user
  ssh_auth:
    - present
    - user: {{ user.name }}
    - comment: data_mover
    - name: {{ salt['pillar.get']('worker:data_mover_ssh_pubkey') }}

/home/{{ user.name }}:
  file.directory:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 750
    - require:
      - user: {{ user.name }}

/home/{{ user.name }}/worker:
  file.directory:
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 750
    - require:
      - user: {{ user.name }}
      - file: /home/{{ user.name }}
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
    - source: salt://worker/worker_requirements.txt
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - template: jinja
    - require:
      - file: /home/{{ user.name }}/worker

worker_virtualenv_upgrade_pip:
  cmd.run:
    - name: scl enable python27 ". bin/activate; pip install pip=={{ versions.pip }} setuptools==17.1"
    - cwd: /home/{{ user.name }}/worker
    - unless: scl enable python27 ". bin/activate; pip -V | grep 'pip {{ versions.pip }} '"
    - user: {{ user.name }}
    - require:
      - virtualenv: /home/{{ user.name }}/worker

worker_virtualenv:
  cmd.wait:
    - name: scl enable python27 ". bin/activate; pip install -r requirements.txt"
    - cwd: /home/{{ user.name }}/worker
    - user: {{ user.name }}
    - require:
      - pkg: python27-python-devel
      - pkg: python27-python-virtualenv
      - virtualenv: /home/{{ user.name }}/worker
      - cmd: worker_virtualenv_upgrade_pip
    - watch:
      - file: /home/{{ user.name }}/worker/requirements.txt

/home/{{ user.name }}/worker/celery.json:
  file.absent
  # file.managed:
  #   - source: salt://worker/worker_celery.json
  #   - user: {{ user.name }}
  #   - group: {{ user.name }}
  #   - mode: 640
  #   - template: jinja
  #   - require:
  #     - file: /home/{{ user.name }}/worker

/home/{{ user.name }}/worker/celeryconfig.py:
  file.managed:
    - source: salt://worker/worker.py
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - template: jinja
    - require:
      - file: /home/{{ user.name }}/worker

/home/{{ user.name }}/worker/bccvl.ini:
  file.managed:
    - source: salt://worker/worker.ini
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 640
    - template: jinja
    - require:
      - file: /home/{{ user.name }}/worker


/mnt/workdir:
  file.directory:
    - user: bccvl
    - group: bccvl
    - mode: 700

/etc/supervisord.d/worker.ini:
  file.managed:
    - source: salt://worker/worker_supervisor.ini
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: supervisor
      - file: /home/{{ user.name }}/worker/celeryconfig.py
      - file: /home/{{ user.name }}/worker/bccvl.ini
      - user: {{ user.name }}
      - cmd: worker_virtualenv
      - file: /mnt/workdir
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
