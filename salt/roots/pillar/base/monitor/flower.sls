{% import_yaml "variables.yml" as vars %}

{% import "certs/flower.crt.pem" as flower_sslcert %}
{% import "certs/flower.key.pem" as flower_sslkey %}


flower:

  cabundle: /etc/pki/tls/certs/bccvlca.crt.pem
  # auth: email@domain|email2@domain .. or any other regexp
  # auth: g.weis@griffith.edu.au

  # client cert and key to auth with rabbit
  sslcert: {{ flower_sslcert|string|json }}
  sslkey: {{ flower_sslkey|string|json }}

  broker:
    user: {{ vars.rabbitmq.users.flower.name }}
    pass: {{ vars.rabbitmq.users.flower.pass }}
    host: {{ vars.rabbitmq.host }}
    httpport: "15671"
    amqpport: "5671"
    vhost: bccvl
