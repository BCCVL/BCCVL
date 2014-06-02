{% import "certs/bccvlca.crt.pem" as bccvlca_crt %}
{% import "certs/bccvllogger.crt.pem" as bccvllogger_sslcert %}
{% import "certs/bccvllogger.key.pem" as bccvllogger_sslkey %}
{% import "certs/rabbitmq.crt.pem" as rabbitmq_sslcert %}
{% import "certs/rabbitmq.key.pem" as rabbitmq_sslkey %}
{% import "certs/bccvl.crt.pem" as bccvl_sslcert %}
{% import "certs/bccvl.key.pem" as bccvl_sslkey %}


pki:
  # bundle:
  #   <bundlename>:
  #       - list of cert names or file names?
  #   <system>: add list to system bundle?
  cert:
    bccvlca: {{ bccvlca_crt|string|json }}
    bccvllogger: {{ bccvllogger_sslcert|string|json }}
    rabbitmq: {{ rabbitmq_sslcert|string|json }}
    bccvl: {{ bccvl_sslcert|string|json }}
    rabbitweb: {{ bccvl_sslcert|string|json }}
  key:
    bccvllogger: {{ bccvllogger_sslkey|string|json }}
    bccvl: {{ bccvl_sslkey|string|json }}

  manual:
    key:
      rabbitmq: {{ rabbitmq_sslkey|string|json }}
      rabbitweb: {{ bccvl_sslkey|string|json }}
