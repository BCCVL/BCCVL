include:
  - SCL

python27-python:
  pkg:
    - installed
    - require:
      - pkg: centos-release-SCL

# Required to build c-extensions
python27-python-devel:
  pkg:
    - installed
    - require:
      - pkg: centos-release-SCL

python27-python-virtualenv:
  pkg:
    - installed
    - require:
      - pkg: centos-release-SCL
