{% import_yaml "variables.yml" as vars %}

rsyslog:

  host: {{ vars.rsyslog.host }}
  port: 1514
