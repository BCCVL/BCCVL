
{% import "certs/flower.crt.pem" as flower_sslcert %}
{% import "certs/flower.key.pem" as flower_sslkey %}


flower:

  cabundle: /etc/pki/tls/bccvlca.crt.pem
  # auth: email@domain|email2@domain .. or any other regexp
  # auth: g.weis@griffith.edu.au

  # client cert and key to auth with rabbit
  sslcert: {{ flower_sslcert|string|json }}
  sslkey: {{ flower_sslkey|string|json }}

  broker:
    user: flower
    pass: flower
    host: 192.168.100.200
    httpport: "15671"
    amqpport: "5671"
    vhost: bccvl
