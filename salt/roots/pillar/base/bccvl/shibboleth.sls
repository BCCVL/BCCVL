{% import "certs/shibboleth-sp.crt.pem" as sp_crt %}
{% import "certs/shibboleth-sp.key.pem" as sp_key %}

shibboleth:
  entityID: https://{{ saltenv }}.bccvl.org.au/shibboleth

  supportContact: support@bccvl.org.au

  sp_crt: {{ sp_crt|string|json }}
  sp_key: {{ sp_key|string|json }}
