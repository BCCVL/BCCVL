{% set user = salt['pillar.get']('plone:user', {'name': 'plone'}) %}

plone_virtualenv:
  file.directory:
    - name: /home/{{ user.name }}/bccvl_buildout
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 750
    - require:
      - user: {{ user.name }}
  git.latest:
    - name: https://github.com/BCCVL/bccvl_buildout.git
    - rev: {{ pillar['plone']['buildout']['branch'] }}
    - target: /home/{{ user.name }}/bccvl_buildout
    - user: {{ user.name }}
    - require:
      - user: {{ user.name }}
      - pkg: git
  virtualenv.managed:
    - venv_bin: /usr/local/bin/python27-virtualenv
    - user: {{ user.name }}
    - cwd: /home/{{ user.name }}
    - require:
      - user: {{ user.name }}
      - git: plone_virtualenv
      - pkg: python27-python-virtualenv
      - file: /usr/local/bin/python27-virtualenv
      - file: /mnt/plone_var
