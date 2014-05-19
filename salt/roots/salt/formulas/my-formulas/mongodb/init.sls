

mongodb:
  pkgrepo.managed:
    - humanname: MongoDB Redhat RPM Repository
    - baseurl: http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
    - comments:
        - '#http://docs.mongodb.org/manual/tutorial/install-mongodb-on-red-hat-centos-or-fedora-linux/'
    - gpgcheck: 0
    - enabled: 1

mongodb-org-server:
  pkg:
    - installed
    - require:
      - pkgrepo: mongodb

mongod:
  service:
    - running
    - enable: True
    - require:
      - pkg: mongodb-org-server
      - pkgrepo: mongodb
