{% set user = salt['pillar.get']('data_mover:user', {'name': 'data_mover'}) %}

/home/{{ user.name }}/worker/org.bccvl.tasks:
  git.latest:
    - name: https://github.com/BCCVL/org.bccvl.tasks.git
    - target: /home/{{ user.name }}/worker/org.bccvl.tasks
    - rev: {{ pillar['versions']['org.bccvl.tasks'] }}
    - user: {{ user.name }}
    - require:
      - user: {{ user.name }}
      - pkg: git
      - file: /home/{{ user.name }}/worker
    - require_in:
      - cmd: data_mover_worker_virtualenv

/home/{{ user.name }}/worker/org.bccvl.movelib:
  git.latest:
    - name: https://github.com/BCCVL/org.bccvl.movelib.git
    - target: /home/{{ user.name }}/worker/org.bccvl.movelib
    - rev: {{ pillar['versions']['org.bccvl.movelib'] }}
    - user: {{ user.name }}
    - require:
      - user: {{ user.name }}
      - pkg: git
      - file: /home/{{ user.name }}/worker
    - require_in:
      - cmd: data_mover_worker_virtualenv
