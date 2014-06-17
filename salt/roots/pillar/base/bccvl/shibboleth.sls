{% import_yaml "variables.yml" as vars %}
{% if vars.shibboleth.enabled %}
{% import "certs/shibboleth-sp.crt.pem" as sp_crt %}
{% import "certs/shibboleth-sp.key.pem" as sp_key %}
{% endif %}

shibboleth:
  enabled: {{ vars.shibboleth.enabled }}
  entityID: https://{{ vars.bccvl.hostname }}/shibboleth

  supportContact: support@bccvl.org.au

{% if vars.shibboleth.enabled %}
  sp_crt: {{ sp_crt|string|json }}
  sp_key: {{ sp_key|string|json }}
{% endif %}
