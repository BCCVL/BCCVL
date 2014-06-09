{% import_yaml "variables.yml" as vars %}

collectd:
  network:
    host: {{ vars.collectd.network.host }}
    password: {{ vars.collectd.network.password }}
