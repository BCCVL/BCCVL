include:
  - pgdg

{% set postgres = {
       'pkg': 'postgresql94-server',
       'service': 'postgresql-9.4',
       'data_dir': salt['pillar.get']('postgres:data_dir', '/mnt/pgsql/9.4/data'),
       'pgstartup_log': salt['pillar.get']('postgres:pgstartup.log', '/mnt/pgsql/9.4/pgstartup.log')
    }
%}


{{ postgres.pkg }}:
  pkg:
    - installed
    - require:
      - pkg: pgdg-release


/etc/sysconfig/pgsql/{{ postgres.service }}:
  file.managed:
    - source: salt://postgres/{{ postgres.service }}.sysconfig
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - defaults:
        postgres:
          data_dir: {{ postgres.data_dir }}
          pgstartup_log: {{ postgres.pgstartup_log }}
    - require:
      - pkg: {{ postgres.pkg }}
    - watch_in:
      - service: {{ postgres.service }}


{{ postgres.service }}-initdb:
  cmd.run:
    - cwd: /
    - user: root
    - name: service {{ postgres.service }} initdb
    - unless: test -f {{ postgres.data_dir }}/postgresql.conf
    - env:
      LC_ALL: C.UTF-8
    - require:
      - pkg: {{ postgres.pkg }}
      - file: /etc/sysconfig/pgsql/{{ postgres.service }}


{% if 'postgresql.conf' in pillar.get('postgres', {}) %}
{{ postgres.data_dir }}/postgresql.conf:
  file.blockreplace:
      - marker_start: "# Managed by SaltStack: listen_addresses: please do not edit"
      - marker_end: "# Managed by SaltStack: end of salt managed zone --"
      - content: {{ salt['pillar.get']('postgres:postgresql.conf') }}
      - show_changes: True
      - append_if_not_found: True
      - require:
        - pkg: {{ postgres.pkg }}
        - cmd: {{ postgres.service }}-initdb
      - watch_in:
         - service: {{ postgres.service }}
{% endif %}


{% if 'pg_hba.conf' in pillar.get('postgres', {}) %}
{{ postgres.data_dir }}/pg_hba.conf:
  file.managed:
    - source: {{ salt['pillar.get']('postgres:pg_hba.conf', 'salt://postgres/pg_hba.conf') }}
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 600
    - require:
      - pkg: {{ postgres.pkg }}
      - cmd: {{ postgres.service }}-initdb
    - watch_in:
      - service: {{ postgres.service }}
{% endif %}


{{ postgres.service }}:
  service:
    - running
    - enable: True
    - require:
      - pkg: {{ postgres.pkg }}
      - file: /etc/sysconfig/pgsql/{{ postgres.service }}
      - cmd: {{ postgres.service }}-initdb


{% if 'users' in pillar.get('postgres', {}) %}
{% for name in salt['pillar.get']('postgres:users') %}
postgres-user-{{ name }}:
  postgres_user.present:
    - name: {{ name }}
    - createdb: {{ salt['pillar.get']('postgres:users:' + name + ':createdb', False) }}
    - password: {{ salt['pillar.get']('postgres:users:' + name + ':password', name) }}
    - user: postgres
    - require:
      - service: {{ postgres.service }}
{% endfor%}
{% endif %}


{% if 'databases' in pillar.get('postgres', {}) %}
{% for name, db in salt['pillar.get']('postgres:databases').items()  %}
postgres-db-{{ name }}:
  postgres_database.present:
    - name: {{ name }}
    - encoding: {{ salt['pillar.get']('postgres:databases:'+ name +':encoding', 'UTF8') }}
    - lc_ctype: {{ salt['pillar.get']('postgres:databases:'+ name +':lc_ctype', 'en_US.UTF8') }}
    - lc_collate: {{ salt['pillar.get']('postgres:databases:'+ name +':lc_collate', 'en_US.UTF8') }}
    - template: {{ salt['pillar.get']('postgres:databases:'+ name +':template', 'template0') }}
    {% if salt['pillar.get']('postgres:databases:'+ name +':owner') %}
    - owner: {{ salt['pillar.get']('postgres:databases:'+ name +':owner') }}
    {% endif %}
    - user: {{ salt['pillar.get']('postgres:databases:'+ name +':runas', 'postgres') }}
    - require:
        - service: {{ postgres.service }}
        {% if salt['pillar.get']('postgres:databases:'+ name +':user') %}
        - postgres_user: postgres-user-{{ salt['pillar.get']('postgres:databases:'+ name +':user') }}
        {% endif %}
{% endfor %}
{% endif %}

