include:
  - erpel

4store:
  pkg.installed:
    - require:
      - pkgrepo: erpel
  service:
    - running
    - enable: True
    - require:
      - pkg: 4store
      - file: /etc/4store.conf
      {% for store in pillar['4store']['stores'] %}
      - cmd: 4store create {{ store }}
      - file: 4store sysconfig {{ store }}
      {% endfor %}

/etc/sysconfig/4store:
  file.managed:
    - source: salt://4store/4store.sysconfig
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - require:
      - pkg: 4store
    - watch_in:
      - service: 4store

{% for store in pillar['4store']['stores'] %}
{%   set segments = salt['pillar.get']('4store:stores:' + store +':segments') %}
{%   if not segments %}
{%     set segments = pillar['4store']['segments'] %}
{%   endif %}
4store create {{ store }}:
  cmd.run:
    - name: 4s-backend-setup --segments {{ segments }} {{ store }}
    - user: fourstore
    - group: fourstore
    - unless: test -d /var/lib/4store/{{ store }}
    - require:
      - pkg: 4store

4store sysconfig {{ store }}:
  file.append:
    - name: /etc/4store.conf
    - text: |
        [{{ store }}]
        port = {{ pillar['4store']['stores'][store]['port'] }}
        soft-lmit = 0
    - require:
      - pkg: 4store
    - watch_in:
      - service: 4store

{% endfor %}
