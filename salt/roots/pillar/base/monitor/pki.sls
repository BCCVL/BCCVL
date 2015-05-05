{% import "certs/bccvlca.crt.pem" as bccvlca_crt %}
{% import "certs/monitor.crt.pem" as monitor_sslcrt %}
{% import "certs/monitor.key.pem" as monitor_sslkey %}
{% import "certs/rsyslog.crt.pem" as rsyslog_sslcrt %}
{% import "certs/rsyslog.key.pem" as rsyslog_sslkey %}
{% import "certs/quovadisrootca.crt.pem" as quovadisrootca_crt %}

pki:
  # bundle:
  #   <bundlename>:
  #       - list of cert names or file names?
  #   <system>: add list to system bundle?
  cert:
    bccvlca: {{ bccvlca_crt|string|json }}
    monitor: {{ monitor_sslcrt|string|json }}
    rsyslog: {{ rsyslog_sslcrt|string|json }}
    quovadisrootca: {{ quovadisrootca_crt|string|json }}
  key:
    monitor: {{ monitor_sslkey|string|json }}
    rsyslog: {{ rsyslog_sslkey|string|json }}
