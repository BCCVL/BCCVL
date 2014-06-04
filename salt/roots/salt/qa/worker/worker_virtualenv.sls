{% set user = salt['pillar.get']('worker:user', {'name': 'bccvl'}) %}

## install editable version of tool
##  ... run this step if the above git clone reports changes
worker_virtualenv:
  cmd.run:
    - name: scl enable python27 ". bin/activate; pip install -U https://github.com/BCCVL/org.bccvl.tasks/archive/develop.tar.gz#egg=org.bccvl.tasks"
    - cwd: /home/{{ user.name }}/worker
    - user: {{ user.name }}
    - require:
      - pkg: python27-python-devel
      - pkg: python27-python-virtualenv
      - virtualenv: /home/{{ user.name }}/worker


# install Datamover SSL Cert chain
/etc/pki/tls/certs/AusCert.crt.pem:
  file.managed:
    - source: salt://worker/AusCert.crt.pem
    - user: root
    - group: root
    - mode: 644
    - require_in:
      - service: supervisord
