{% import "certs/bccvlca.crt.pem" as bccvlca_crt %}
{% import "certs/monitor.crt.pem" as monitor_sslcert %}
{% import "certs/monitor.key.pem" as monitor_sslkey %}


pki:
  # bundle:
  #   <bundlename>:
  #       - list of cert names or file names?
  #   <system>: add list to system bundle?
  cert:
    bccvlca: {{ bccvlca_crt|string|json }}
    monitor: {{ monitor_sslcert|string|json }}
  key:
    monitor: {{ monitor_sslkey|string|json }}
