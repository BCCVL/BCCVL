CREATE TABLE IF NOT EXISTS SystemEvents
(
        ID serial not null primary key,
        CustomerID bigint,
        ReceivedAt timestamp without time zone NULL,
        DeviceReportedTime timestamp without time zone NULL,
        Facility smallint NULL,
        Priority smallint NULL,
        FromHost varchar(60) NULL,
        Message text,
        NTSeverity int NULL,
        Importance int NULL,
        EventSource varchar(60),
        EventUser varchar(60) NULL,
        EventCategory int NULL,
        EventID int NULL,
        EventBinaryData text NULL,
        MaxAvailable int NULL,
        CurrUsage int NULL,
        MinUsage int NULL,
        MaxUsage int NULL,
        InfoUnitID int NULL ,
        SysLogTag varchar(60),
        EventLogType varchar(60),
        GenericFileName VarChar(60),
        SystemID int NULL,
        ProcessID varchar(60),
        checksum int DEFAULT 0 NOT NULL
);

CREATE TABLE IF NOT EXISTS SystemEventsProperties
(
        ID serial not null primary key,
        SystemEventID int NULL ,
        ParamName varchar(255) NULL ,
        ParamValue text NULL
);

GRANT ALL ON TABLE SystemEvents, SystemEventsProperties TO rsyslog;
GRANT ALL ON SEQUENCE SystemEvents_id_seq, SystemEventsProperties_id_seq TO rsyslog;

GRANT ALL ON TABLE SystemEvents, SystemEventsProperties TO loganalyzer;
GRANT ALL ON SEQUENCE SystemEvents_id_seq, SystemEventsProperties_id_seq TO loganalyzer;
