CREATE TABLE [data].[participants] (
    [team_id]          UNIQUEIDENTIFIER NOT NULL,
    [team_name]        VARCHAR (100)    NOT NULL,
    [team_alias]       VARCHAR (40)     NOT NULL,
    [event_type_id]    INT              NULL,
    [team_notes_1]     VARCHAR (100)    NULL,
    [team_notes_2]     VARCHAR (100)    NULL,
    [created_by]       VARCHAR (40)     DEFAULT (suser_name()) NOT NULL,
    [created_datatime] DATETIME2 (7)    DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([team_id] ASC)
);

