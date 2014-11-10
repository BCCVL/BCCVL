{% set user = salt['pillar.get']('worker:user', {'name': 'bccvl'}) %}

/home/{{ user.name }}/worker/org.bccvl.tasks:
  git.latest:
    - name: https://github.com/BCCVL/org.bccvl.tasks.git
    - target: /home/{{ user.name }}/worker/org.bccvl.tasks
    - rev: develop
    - user: {{ user.name }}
    - require:
      - user: {{ user.name }}
      - pkg: git
      - file: /home/{{ user.name }}/worker
    - watch_in:
      - cmd: worker_virtualenv
