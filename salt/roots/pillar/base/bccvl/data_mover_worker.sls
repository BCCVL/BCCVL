{% import_yaml "variables.yml" as vars %}

{% import "certs/plone.crt.pem" as plone_sslcert %}
{% import "certs/plone.key.pem" as plone_sslkey %}


data_mover_worker:

  sslcert: {{ plone_sslcert|string|json }}
  sslkey: {{ plone_sslkey|string|json }}

  rabbitmq:
    host: {{ vars.rabbitmq.host }}
    port: '5671'
    vhost: bccvl
    user: {{ vars.rabbitmq.users.bccvl.name }}
    pass: {{ vars.rabbitmq.users.bccvl.pass }}

  ssl_verify: {{ vars.requests.ssl.verify }}
