{% import "certs/plone.crt.pem" as plone_sslcert %}
{% import "certs/plone.key.pem" as plone_sslkey %}


data_mover_worker:

  sslcert: {{ plone_sslcert|string|json }}
  sslkey: {{ plone_sslkey|string|json }}

  rabbitmq:
    host: 192.168.100.200
    port: '5671'
    vhost: bccvl
    user: bccvl
    pass: bccvl
