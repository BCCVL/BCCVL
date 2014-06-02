{% import_yaml "variables.yml" as vars %}
{% import 'keys/data_mover.id_dsa.pub' as data_mover_id_dsa_pub %}

{% import "certs/worker.crt.pem" as worker_sslcert %}
{% import "certs/worker.key.pem" as worker_sslkey %}

include:
  - worker.pki
  - worker.rsyslog

worker:

  user:
    name: bccvl
    fullname: BCCVL Worker
    uid: 401
    gid: 401

  sslcert: {{ worker_sslcert|string|json }}
  sslkey: {{ worker_sslkey|string|json }}

  rabbitmq:
    host: {{ vars.rabbitmq.host }}
    port: '5671'
    vhost: bccvl
    user: {{ vars.rabbitmq.users.worker.name }}
    pass: {{ vars.rabbitmq.users.worker.pass }}

  data_mover_ssh_pubkey: {{ data_mover_id_dsa_pub|string|json }}
  data_mover: {{ vars.bccvl.hostname }}
