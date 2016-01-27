{% import_yaml "variables.yml" as vars %}

oauth:
{% for key in vars.oauth %}
{% if vars.oauth[key] %}
  {{ key }}:
{% for opt in vars.oauth[key] %}
{% if vars.oauth[key][opt] %}
    {{ opt }}: {{ vars.oauth[key][opt] }}
{% endif %}
{% endfor %}
{% endif %}
{% endfor %}

