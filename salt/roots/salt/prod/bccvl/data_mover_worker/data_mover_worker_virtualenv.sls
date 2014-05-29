{% set user = salt['pillar.get']('data_mover:user', {'name': 'data_mover'}) %}

## install editable version of tool
##  ... run this step if the above git clone reports changes
data_mover_worker_virtualenv:
  cmd.run:
    - name: scl enable python27 ". bin/activate; pip install -U https://github.com/BCCVL/org.bccvl.tasks/archive/master.tar.gz#egg=org.bccvl.tasks"
    - cwd: /home/{{ user.name }}/worker
    - user: {{ user.name }}
    - require:
      - pkg: python27-python-devel
      - pkg: python27-python-virtualenv
      - virtualenv: /home/{{ user.name }}/worker
