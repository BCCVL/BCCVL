{% import_yaml "variables.yml" as vars %}

apache:
  servername: {{ vars.bccvl.hostname }}
  serveradmin: g.weis@griffith.edu.au

  shibboleth: false

  certfile: /etc/pki/tls/bccvl.crt.pem
  keyfile: /etc/pki/tls/private/bccvl.key.pem
