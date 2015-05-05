
mongodb-purge:
  pkgrepo.absent:
    - name: mongodb

mongodb-org-server-purge:
  pkg.purged:
    - name: mongodb-org-server
    - require:
      - service: mongod-dead

mongod-dead:
  service.dead:
    - name: mongod
    - enable: False

# TODO: clean out mongo storage?
