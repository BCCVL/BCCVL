{% set broker = salt['pillar.get']('flower:broker', {}) %}

{% set cred = broker.get('user', 'guest') +  ':' +  broker.get('pass', 'guest') %}
{% set hostport = broker.get('host', '127.0.0.1') + ':' + broker.get('httpport', '15671') %}

{% set brokerapi = 'https://' + cred + '@' + hostport + '/api/' %}

broker_api = "{{ brokerapi }}"

address = "127.0.0.1"
persistent = True
port = 5555
url_prefix = "flower"
xheaders = True
