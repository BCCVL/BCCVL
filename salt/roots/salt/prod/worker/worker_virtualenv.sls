{% set user = salt['pillar.get']('worker:user', {'name': 'bccvl'}) %}
{% set version = '1.6.0' %}

## install editable version of tool
##  ... run this step if the above git clone reports changes
worker_virtualenv:
  cmd.run:
    - name: scl enable python27 ". bin/activate; pip install -U https://github.com/BCCVL/org.bccvl.tasks/archive/{{ version }}.tar.gz#egg=org.bccvl.tasks-{{ version }}"
    - cwd: /home/{{ user.name }}/worker
    - user: {{ user.name }}
    - require:
      - pkg: python27-python-devel
      - pkg: python27-python-virtualenv
      - virtualenv: /home/{{ user.name }}/worker
