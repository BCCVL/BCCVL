

# pki:
#   root:
#    - name: value
#   cert:
#    - name: value
#   key:
#    - name: value

{# if var is mapping ... test if var is dict #}
{# if var is string, none, defined, ... #}

{# TODO: do bundle #}

{% set certlist = salt['pillar.get']('pki:cert', []) %}
{% for name in certlist %}
/etc/pki/tls/{{ name }}.crt.pem:
  file.managed:
    - user: root
    - group: root
    - mode: 444
    - contents_pillar: pki:cert:{{ name }}
{% endfor %}


{% set keylist = salt['pillar.get']('pki:key', []) %}
{% for name in keylist %}
/etc/pki/tls/private/{{ name }}.key.pem:
  file.managed:
    - user: root
    - group: root
    - mode: 400
    - contents_pillar: pki:key:{{ name }}
{% endfor %}
