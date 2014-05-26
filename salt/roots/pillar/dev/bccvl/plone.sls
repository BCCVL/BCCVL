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

  hostname: 192.168.100.100

  admin: admin
  password: admin

  siteid: bccvl

  # storage:
  #   root:

  mr_developer_always_checkout: true
  site_replace: false

  buildout:
    branch: feature/remove_zc_async  # develop  # which branch to build

  # instances to build
  instances:
    instance1:
      host: 127.0.0.1
      port: 8401
    instance-debug:
      host: 127.0.0.1
      port: 8499
      debug: true

  rabbitmq:
    user: bccvl
    pass: bccvl
    host: 192.168.100.200
    port: 5671
    vhost: bccvl

  worker:
    sslcert: {{ plone_sslcert|string|json }}
    sslkey: {{ plone_sslkey|string|json }}


# TODO: not yet used
  zeomonitor:
    host: 127.0.0.1
    port: 8502



# Salt Jinja Filters:
# yaml, json, python, load_yaml, load_json,
# Salt Jinja Tags:
# load_yaml, load_json, import_yaml, import_json

# Merge Key:
# mapping:
#   name: Joe
#   job: Accountant
#   <<:
#     age: 38

# forcing string:
# date string: !str 2001-08-01
# number string: !str 192

# Null:
# date of next season: ~

# Preserve newlines:
# this: |
#     Foo
#     Bar
# |+ preserves all newline at end of block
# |- strip newlines at end of block


# TODO: can salt yaml include access the values included?
