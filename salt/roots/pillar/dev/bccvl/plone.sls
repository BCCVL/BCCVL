{% import_yaml "variables.yml" as vars %}
# load key files
{% import 'keys/plone.id_dsa' as plone_id_dsa_priv %}
{% import 'keys/plone.id_dsa.pub' as plone_id_dsa_pub %}
{% import "certs/plone.crt.pem" as plone_sslcert %}
{% import "certs/plone.key.pem" as plone_sslkey %}


plone:

  user:
    name: plone
    fullname: BCCVL Plone
    uid: 402
    gid: 403

  hostname: {{ vars.bccvl.hostname }}

  admin: {{ vars.plone.admin }}
  password: {{ vars.plone.password }}

  siteid: bccvl

  storage:
    root: /mnt/plone_var

  mr_developer_always_checkout: false
  site_replace: false

  # instances to build
  instances:
    instance1:
      host: 127.0.0.1
      port: 8401
    instance2:
      host: 127.0.0.1
      port: 8402
    instance-debug:
      host: 127.0.0.1
      port: 8499
      debug: true

  rabbitmq:
    user: {{ vars.rabbitmq.users.bccvl.name }}
    pass: {{ vars.rabbitmq.users.bccvl.pass }}
    host: {{ vars.rabbitmq.host }}
    port: 5671
    vhost: bccvl

  worker:
    sslcert: {{ plone_sslcert|string|json }}
    sslkey: {{ plone_sslkey|string|json }}


# TODO: not yet used
  zeomonitor:
    host: 127.0.0.1
    port: 8502
