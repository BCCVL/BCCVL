{% import_yaml "variables.yml" as vars %}

authtkt:
{% for key in vars.authtkt %}
{% if vars.authtkt[key] %}
  {{ key }}: {{ vars.authtkt[key] }}
{% endif %}
{% endfor %}

#  name: {{ vars.authtkt.name }}
#  domain: {{ vars.authtkt.domain }}
#  secret: {{ vars.authtkt.secret }}
