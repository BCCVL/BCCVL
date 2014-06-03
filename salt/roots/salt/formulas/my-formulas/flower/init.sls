include:
  - gcc
  - virtualenv
  - supervisord
  - libffi-devel
  - openssl-devel

flower:
  user.present:
    - name: flower
    - fullname: Flower User
    - gid_from_name: True
    - system: True
    - shell: /bin/false

/home/flower:
  virtualenv.managed:
    - name: /home/flower
    - cwd: /home/flower
    - requirements: salt://flower/flower_requirements.txt
    - require:
      - pkg: python-virtualenv
      - pkg: libffi-devel
      - pkg: openssl-devel
      - pkg: gcc
      - user: flower

/home/flower/etc:
  file.directory:
    - user: flower
    - group: flower
    - mode: 500
    - require:
      - user: flower

/home/flower/etc/config:
  file.directory:
    - user: flower
    - group: flower
    - mode: 500
    - require:
      - user: flower
      - file: /home/flower/etc

/home/flower/etc/flower.crt.pem:
  file.managed:
    - contents_pillar: flower:sslcert
    - user: flower
    - group: flower
    - mode: 400
    - require:
      - file: /home/flower/etc

/home/flower/etc/flower.key.pem:
  file.managed:
    - contents_pillar: flower:sslkey
    - user: flower
    - group: flower
    - mode: 400
    - require:
      - file: /home/flower/etc

/home/flower/etc/config/celeryconfig.py:
  file.managed:
    - source: salt://flower/celeryconfig.py
    - user: root
    - group: flower
    - mode: 440
    - template: jinja
    - require:
      - file: /home/flower/etc/config
    - watch_in:
      - service: supervisord

/home/flower/flowerconfig.py:
  file.managed:
    - source: salt://flower/flowerconfig.py
    - user: root
    - group: flower
    - mode: 440
    - template: jinja
    - require:
      - user: flower
    - watch_in:
      - service: supervisord

/etc/supervisord.d/flower.ini:
  file.managed:
    - source: salt://flower/flower_supervisord.ini
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: supervisor
      - virtualenv: /home/flower
      - file: /home/flower/etc/flower.crt.pem
      - file: /home/flower/etc/flower.key.pem
      - file: /home/flower/flowerconfig.py
      - file: /home/flower/etc/config/celeryconfig.py
    - watch_in:
      - service: supervisord
