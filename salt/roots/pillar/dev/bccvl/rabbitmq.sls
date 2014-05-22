
rabbitmq:

  runas: rabbitmq
  plugins:
    - rabbitmq_management
  rootusers:
    - name: admin
      password: admin
      # force: True
      tags: administrator
      perms:
        - '/':
          - '.*'
          - '.*'
          - '.*'
  vhosts:
    - name: bccvl
      owner: admin
      conf: '.*'
      write: '.*'
      read: '.*'
  users:
    - name: bccvl
      password: bccvl
      # force: True
      perms:
        - 'bccvl':
          - '.*'
          - '.*'
          - '.*'
    - name: flower
      password: flower
      # force: True
      tags: monitoring
      perms:
        - 'bccvl':
          - '.*'
          - '.*'
          - '.*'
    - name: worker
      password: worker
      # force: True
      perms:
        - 'bccvl':
          - '.*'
          - '.*'
          - '.*'
  absent:
    users:
      - guest
