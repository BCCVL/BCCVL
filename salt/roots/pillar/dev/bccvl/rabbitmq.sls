
rabbitmq:

  runas: rabbitmq
  plugins:
    - rabbitmq_management
  vhosts:
    - name: bccvl
      owner: admin
      conf: '.*'
      write: '.*'
      read: '.*'
  users:
    - name: admin
      password: admin
      # force: True
      tags: administrator
      perms:
        - '/':
          - '.*'
          - '.*'
          - '.*'
    - name: bccvl
      # force: True
      perms:
        - 'bccvl':
          - '.*'
          - '.*'
          - '.*'
    - name: flower
      # force: True
      perms:
        - 'bccvl':
          - '.*'
          - '.*'
          - '.*'
    - name: worker
      # force: True
      perms:
        - 'bccvl':
          - '.*'
          - '.*'
          - '.*'
  absent:
    users:
      - guest
