CREATE TABLE [data].[arenas_event_types] (
    [event_type_id]     INT           NOT NULL,
    [event_type_name]   VARCHAR (100) NOT NULL,
    [event_type_level1] VARCHAR (100) NOT NULL,
    [event_type_level2] VARCHAR (100) NULL,
    [event_type_level3] VARCHAR (100) NULL,
    [created_by]        VARCHAR (40)  DEFAULT (suser_name()) NOT NULL,
    [created_datetime]  DATETIME2 (7) DEFAULT (sysdatetime()) NOT NULL,
    PRIMARY KEY CLUSTERED ([event_type_id] ASC)
);

