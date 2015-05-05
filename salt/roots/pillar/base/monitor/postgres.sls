postgres:
  pg_hba.conf: salt://postgres/pg_hba.conf

  users:
    rsyslog:
      password: 'rsyslog'
    loganalyzer:
      password: 'loganalyzer'

  # This section cover this ACL management of the pg_hba.conf file.
  # <type>, <database>, <user>, [host], <method>
  acls:
    - ['host', 'all', 'all', '127.0.0.1/32']
    - ['host', 'all', 'all', '::1/128']

  databases:
    logs:
      encoding: 'SQL_ASCII'
    dev-logs:
      encoding: 'SQL_ASCII'
    test-logs:
      encoding: 'SQL_ASCII'
    qa-logs:
      encoding: 'SQL_ASCII'
    prod-logs:
      encoding: 'SQL_ASCII'

  # This section will append your configuration to postgresql.conf.
  postgresql.conf: |
    listen_addresses = 'localhost'
