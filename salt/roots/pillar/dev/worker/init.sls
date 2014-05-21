{% import 'keys/data_mover.id_dsa.pub' as data_mover_id_dsa_pub %}

{% import "certs/worker.crt.pem" as worker_sslcert %}
{% import "certs/worker.key.pem" as worker_sslkey %}

include:
  - worker.pki
  - worker.rsyslog

worker:

  user: bccvl

  sslcert: {{ worker_sslcert|string|json }}
  sslkey: {{ worker_sslkey|string|json }}

  rabbitmq:
    host: 192.168.100.200
    port: '5671'
    vhost: bccvl
    user: worker
    pass: worker

  data_mover_ssh_pubkey: {{ data_mover_id_dsa_pub|string|json }}
