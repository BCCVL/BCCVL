{% import_yaml "variables.yml" as vars %}

nectar:
{% for key in vars.nectar %}
{% if vars.nectar[key] %}
  {{ key }}: {{ vars.nectar[key] }}
{% endif %}
{% endfor %}
