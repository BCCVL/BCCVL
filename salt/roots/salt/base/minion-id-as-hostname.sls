

minion-id-as-hostname:
  network.system:
    - order: 1
    - enabled: True
    - hostname: {{ grains.id }}
    - nozeroconf: True
