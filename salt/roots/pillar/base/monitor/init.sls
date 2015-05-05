{% import_yaml "variables.yml" as vars %}

include:
  - monitor.roles
  - monitor.pki
  - monitor.rsyslog
  - monitor.loganalyzer
  - monitor.flower
  - monitor.postgres


monitor:

  hostname: {{ vars.monitor.hostname }}

  admin:
    user: {{ vars.monitor.admin.user }}
    pass: {{ vars.monitor.admin.pass }}
