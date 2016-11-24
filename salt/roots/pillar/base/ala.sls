{% import_yaml "variables.yml" as vars %}

ala:
{% for key in vars.ala %}
{% if vars.ala[key] %}
  {{ key }}: {{ vars.ala[key] }}
{% endif %}
{% endfor %}
