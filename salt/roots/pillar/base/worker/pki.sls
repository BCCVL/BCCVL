{% import "certs/bccvlca.crt.pem" as bccvlca_crt %}
{% import "certs/bccvllogger.crt.pem" as bccvllogger_sslcert %}
{% import "certs/bccvllogger.key.pem" as bccvllogger_sslkey %}

pki:
  # bundle:
  #   <bundlename>:
  #       - list of cert names or file names?
  #   <system>: add list to system bundle?
  cert:
    bccvlca: {{ bccvlca_crt|string|json }}
    bccvllogger: {{ bccvllogger_sslcert|string|json }}

  key:
    bccvllogger: {{ bccvllogger_sslkey|string|json }}
