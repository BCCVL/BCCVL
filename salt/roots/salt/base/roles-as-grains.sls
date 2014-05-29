{% set roles = salt['pillar.get']('roles', []) %}
{% if roles %}
roles-as-grains:
  grains:
    - present
    - order: 1
    - value:
{% for role in roles %}
      - {{ role }}
{% endfor %}
{% endif %}
