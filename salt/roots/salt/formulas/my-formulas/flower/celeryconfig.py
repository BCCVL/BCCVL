{% set cabundle = salt['pillar.get']('flower:cabundle', '/etc/pki/tls/cert.pem') %}
{% set broker = salt['pillar.get']('flower:broker', {}) %}

{% set cred = broker.get('user', 'guest') +  ':' +  broker.get('pass', 'guest') %}
{% set hostport = broker.get('host', '127.0.0.1') + ':' + broker.get('amqpport', '5671') %}
{% set vhost = broker.get('vhost', '') %}

{% set brokerurl = 'amqp://' + cred + '@' + hostport + '/' + vhost %}

import ssl

BROKER_URL = "{{ brokerurl }}"

BROKER_USE_SSL = {
    'ca_certs': '{{ cabundle }}',
    'keyfile':  '/home/flower/etc/flower.key.pem',
    'certfile':  '/home/flower/etc/flower.crt.pem',
    'cert_reqs': ssl.CERT_REQUIRED
}
