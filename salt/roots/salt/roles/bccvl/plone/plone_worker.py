{% set user = salt['pillar.get']('plone:user', {'name': 'plone'}) %}
{% set rabbitmq = salt['pillar.get']('plone:rabbitmq',{}) %}

{% set cred = rabbitmq.get('user', 'guest') + ':' + rabbitmq.get('pass', 'guest') %}
{% set host = rabbitmq.get('host', '127.0.0.1') %}
{% set port = rabbitmq.get('port', '5671') %}
{% set vhost = rabbitmq.get('vhost', '') %}

BROKER_URL = "amqp://{{ cred }}@{{ host }}:{{ port }}/{{ vhost }}"
BROKER_USE_SSL = {
    "ca_certs": "/etc/pki/tls/certs/bccvlca.crt.pem",
    "keyfile": "/home/{{ user.name }}/bccvl_buildout/etc/plone.key.pem",
    "certfile": "/home/{{ user.name }}/bccvl_buildout/etc/plone.crt.pem",
    "cert_reqs": 2
}

ADMINS = ['y.liaw@griffith.edu.au']

CELERY_IMPORTS = [
    "org.bccvl.tasks.plone"
]
