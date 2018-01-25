CREATE TABLE [data].[arena_events] (
    [arena_events_id]         INT              IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [arena_id]                UNIQUEIDENTIFIER NOT NULL,
    [event_id]                UNIQUEIDENTIFIER NOT NULL,
    [event_type_id]           INT              NOT NULL,
    [event_startdatetime_utc] DATETIME2 (7)    NOT NULL,
    [event_enddatetime_utc]   DATETIME2 (7)    NULL,
    [utc_offset]              INT              NULL,
    [created_by]              VARCHAR (40)     DEFAULT (suser_name()) NOT NULL,
    [created_datetime]        DATETIME2 (7)    DEFAULT (sysdatetime()) NOT NULL,
    [updated_by]              VARCHAR (40)     NULL,
    [updated_datetime]        DATETIME2 (7)    NULL,
    PRIMARY KEY CLUSTERED ([arena_events_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_arena_events_001]
    ON [data].[arena_events]([event_type_id] ASC, [event_id] ASC)
    INCLUDE([arena_id], [event_startdatetime_utc], [event_enddatetime_utc]);


GO
CREATE NONCLUSTERED INDEX [IX_arena_events_event_002]
    ON [data].[arena_events]([event_id] ASC)
    INCLUDE([arena_id], [event_type_id], [event_startdatetime_utc], [event_enddatetime_utc]);


GO
CREATE NONCLUSTERED INDEX [IX_arena_events_003]
    ON [data].[arena_events]([event_type_id] ASC)
    INCLUDE([arena_id], [event_id], [event_startdatetime_utc], [event_enddatetime_utc]);

