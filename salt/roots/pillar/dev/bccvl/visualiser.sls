{% import 'keys/visualiser.id_dsa' as visualiser_id_dsa_priv %}
{% import 'keys/visualiser.id_dsa.pub' as visualiser_id_dsa_pub %}


visualiser:

  user:
    name: visualiser
    fullname: BCCVL Visualiser
    uid: 404
    gid: 404

  hostname: 192.168.100.200

  host: 127.0.0.1
  port: 10600

  ssh_privkey: {{ visualiser_id_dsa_priv|string|json }}
  ssh_pubkey: {{ visualiser_id_dsa_pub|string|json }}
