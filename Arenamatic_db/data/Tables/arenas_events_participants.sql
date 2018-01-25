CREATE TABLE [data].[arenas_events_participants] (
    [event_calendar_id] INT              IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [arena_events_id]   UNIQUEIDENTIFIER NOT NULL,
    [home_team_id]      UNIQUEIDENTIFIER NOT NULL,
    [away_team_id]      UNIQUEIDENTIFIER NULL,
    [is_active]         BIT              DEFAULT ((1)) NOT NULL,
    [created_by]        VARCHAR (40)     DEFAULT (suser_name()) NOT NULL,
    [created_datetime]  DATETIME2 (7)    DEFAULT (getdate()) NOT NULL,
    [updated_by]        VARCHAR (40)     NULL,
    [updated_datetime]  DATETIME2 (7)    NULL,
    PRIMARY KEY CLUSTERED ([arena_events_id] ASC)
);

