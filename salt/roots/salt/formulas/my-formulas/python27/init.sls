include:
  - SCL

python27-python:
  pkg:
    - installed
    - require:
      - pkg: centos-release-scl

# Required to build c-extensions
python27-python-devel:
  pkg:
    - installed
    - require:
      - pkg: centos-release-scl

python27-python-virtualenv:
  pkg:
    - installed
    - require:
      - pkg: centos-release-scl


/usr/local/bin/python27-virtualenv:
  file.managed:
    - source: salt://python27/python27-virtualenv.sh
    - user: root
    - group: root
    - mode: 755
