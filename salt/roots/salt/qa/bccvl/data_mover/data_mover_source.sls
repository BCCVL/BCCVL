{% set user = salt['pillar.get']('data_mover:user', {'name': 'data_mover'}) %}

# Clone Data Mover repo
data_mover_source:
  file.directory:
    - name: /home/{{ user.name }}/bccvl_data_mover
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 750
    - require:
      - user: {{ user.name }}
  git.latest:
    - name: https://github.com/BCCVL/bccvl_data_mover.git
    - rev: qa
    - target: /home/{{ user.name }}/bccvl_data_mover
    - user: {{ user.name }}
    - group: {{ user.name }}
    - require:
      - user: {{ user.name }}
      - file: data_mover_source
      - pkg: git
