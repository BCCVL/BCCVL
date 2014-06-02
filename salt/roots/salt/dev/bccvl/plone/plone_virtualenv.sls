{% set user = salt['pillar.get']('plone:user', {'name': 'plone'}) %}

# TODO: work around this here by moving src folder one level up ->
#       change mr.developer config (or move eggs folder and possibly
#       other buildout generated subfolders (eggs, parts, var) what
#       about etc?)
# clone buildout repo
plone_virtualenv:
  file.directory:
    - name: /home/{{ user.name }}/bccvl_buildout
    - user: {{ user.name }}
    - group: {{ user.name }}
    - mode: 750
    - require:
      - user: {{ user.name }}
  cmd.run:
    - name: |
        git init .
        git remote add -f origin https://github.com/BCCVL/bccvl_buildout.git
        git checkout {{ pillar['plone']['buildout']['branch'] }}
    - cwd: /home/{{ user.name }}/bccvl_buildout/
    - user: {{ user.name }}
    - group: {{ user.name }}
    - unless: test -d /home/{{ user.name }}/bccvl_buildout/.git
    - require:
      - user: {{ user.name }}
      - pkg: git
      - file: plone_virtualenv
  git.latest:
    - name: https://github.com/BCCVL/bccvl_buildout.git
    - rev: {{ pillar['plone']['buildout']['branch'] }}
    - target: /home/{{ user.name }}/bccvl_buildout
    - user: {{ user.name }}
    - require:
      - user: {{ user.name }}
      - pkg: git
      - cmd: plone_virtualenv
  virtualenv.managed:
    - name: /home/{{ user.name }}/bccvl_buildout
    - venv_bin: /usr/local/bin/python27-virtualenv
    - user: {{ user.name }}
    - cwd: /home/{{ user.name }}
    - require:
      - user: {{ user.name }}
      - git: plone_virtualenv
      - pkg: python27-python-virtualenv
      - file: /usr/local/bin/python27-virtualenv
