{% import_yaml "variables.yml" as vars %}

rabbitmq:

  runas: rabbitmq
  plugins:
    - rabbitmq_management
  rootusers:
    - name: {{ vars.rabbitmq.users.admin.name }}
      password: {{ vars.rabbitmq.users.admin.pass }}
      force: True
      tags: administrator
      perms:
        - '/':
          - '.*'
          - '.*'
          - '.*'
  vhosts:
    - name: bccvl
      owner: {{ vars.rabbitmq.users.admin.name }}
      conf: '.*'
      write: '.*'
      read: '.*'
  users:
    - name: {{ vars.rabbitmq.users.bccvl.name }}
      password: {{ vars.rabbitmq.users.bccvl.pass }}
      force: True
      tags: user
      perms:
        - 'bccvl':
          - '.*'
          - '.*'
          - '.*'
    - name: {{ vars.rabbitmq.users.flower.name }}
      password: {{ vars.rabbitmq.users.flower.pass }}
      force: True
      tags: monitoring
      perms:
        - 'bccvl':
          - '.*'
          - '.*'
          - '.*'
    - name: {{ vars.rabbitmq.users.worker.name }}
      password: {{ vars.rabbitmq.users.worker.pass }}
      force: True
      tags: user
      perms:
        - 'bccvl':
          - '.*'
          - '.*'
          - '.*'
  absent:
    users:
      - guest
