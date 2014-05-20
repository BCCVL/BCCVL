{% import 'keys/data_mover.id_dsa' as data_mover_id_dsa_priv %}
{% import 'keys/data_mover.id_dsa.pub' as data_mover_id_dsa_pub %}

data_mover:

  host: 127.0.0.1
  port: 10700

  user: data_mover

  ssh_privkey: {{ data_mover_id_dsa_priv|string|json }}
  ssh_pubkey: {{ data_mover_id_dsa_pub|string|json }}
