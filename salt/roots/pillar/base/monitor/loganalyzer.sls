loganalyzer:

  DefaultSourceID: logs

  Sources:

    logs:
      Name: Local Logs
      ViewID: SYSLOG
      SourceType: SOURCE_MONGODB
      DBTableType: mongodb
      DBServer: localhost
      DBName: logs
      DBUser:
      DBPassword:
      DBTableName: syslog

    bccvl-dev:
      Name: BCCVL Dev Logs
      ViewID: SYSLOG
      SourceType: SOURCE_MONGODB
      DBTableType: mongodb
      DBServer: localhost
      DBName: dev-logs
      DBUser:
      DBPassword:
      DBTableName: syslog

    bccvl-qa:
      Name: BCCVL QA Logs
      ViewID: SYSLOG
      SourceType: SOURCE_MONGODB
      DBTableType: mongodb
      DBServer: localhost
      DBName: qa-logs
      DBUser:
      DBPassword:
      DBTableName: syslog

    bccvl-prod:
      Name: BCCVL Prod Logs
      ViewID: SYSLOG
      SourceType: SOURCE_MONGODB
      DBTableType: mongodb
      DBServer: localhost
      DBName: prod-logs
      DBUser:
      DBPassword:
      DBTableName: syslog
