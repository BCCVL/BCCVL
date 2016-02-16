{% set user = salt['pillar.get']('worker:user', {'name': 'bccvl'}) %}
{% set rabbitmq = salt['pillar.get']('worker:rabbitmq',{}) %}

{% set cred = rabbitmq.get('user', 'guest') + ':' + rabbitmq.get('pass', 'guest') %}
{% set host = rabbitmq.get('host', '127.0.0.1') %}
{% set port = rabbitmq.get('port', '5671') %}
{% set vhost = rabbitmq.get('vhost', '') %}

BROKER_URL = "amqp://{{ cred }}@{{ host }}:{{ port }}/{{ vhost }}"
BROKER_USE_SSL = {
    "ca_certs": "/etc/pki/tls/certs/bccvlca.crt.pem",
    "keyfile": "/home/{{ user.name }}/worker/worker.key.pem",
    "certfile": "/home/{{ user.name }}/worker/worker.crt.pem",
    "cert_reqs": 2
}

ADMINS = ['g.weis@griffith.edu.au']

CELERY_IMPORTS = [
    "org.bccvl.tasks.compute"
]
