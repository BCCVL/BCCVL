{% import_yaml "variables.yml" as vars %}

{% if 'private' in vars %}
private:
{% for key in vars.private %}
  {{ key }}: "{{ vars.private[key] }}"
{% endfor %}
{% endif %}
