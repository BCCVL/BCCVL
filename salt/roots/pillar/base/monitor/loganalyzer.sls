loganalyzer:

  DefaultSourceID: logs

  Sources:

    logs:
      Name: Local Logs
      ViewID: SYSLOG
      SourceType: SOURCE_PDO
      DBType: DB_PGSQL
      DBTableType: monitorware
      DBServer: localhost
      DBName: logs
      DBUser: loganalyzer
      DBPassword: loganalyzer
      DBTableName: SystemEvents
      DBEnableRowCounting: false

    bccvl-dev:
      Name: BCCVL Dev Logs
      ViewID: SYSLOG
      SourceType: SOURCE_PDO
      DBType: DB_PGSQL
      DBTableType: monitorware
      DBServer: localhost
      DBName: dev-logs
      DBUser: loganalyzer
      DBPassword: loganalyzer
      DBTableName: SystemEvents
      DBEnableRowCounting: false

    bccvl-qa:
      Name: BCCVL QA Logs
      ViewID: SYSLOG
      SourceType: SOURCE_PDO
      DBType: DB_PGSQL
      DBTableType: monitorware
      DBServer: localhost
      DBName: qa-logs
      DBUser: loganalyzer
      DBPassword: loganalyzer
      DBTableName: SystemEvents
      DBEnableRowCounting: false

    bccvl-test:
      Name: BCCVL Test Logs
      ViewID: SYSLOG
      SourceType: SOURCE_PDO
      DBType: DB_PGSQL
      DBTableType: monitorware
      DBServer: localhost
      DBName: test-logs
      DBUser: loganalyzer
      DBPassword: loganalyzer
      DBTableName: SystemEvents
      DBEnableRowCounting: false

    bccvl-prod:
      Name: BCCVL Prod Logs
      ViewID: SYSLOG
      SourceType: SOURCE_PDO
      DBType: DB_PGSQL
      DBTableType: monitorware
      DBServer: localhost
      DBName: prod-logs
      DBUser: loganalyzer
      DBPassword: loganalyzer
      DBTableName: SystemEvents
      DBEnableRowCounting: false
