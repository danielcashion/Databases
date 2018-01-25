CREATE TABLE [data].[multi_arenas] (
    [arena_id]         UNIQUEIDENTIFIER NOT NULL,
    [arena_name]       VARCHAR (50)     NOT NULL,
    [arena_city]       VARCHAR (30)     NULL,
    [arena_state]      VARCHAR (4)      NULL,
    [league]           VARCHAR (10)     NULL,
    [is_primary]       BIT              DEFAULT ((0)) NOT NULL,
    [created_by]       VARCHAR (40)     DEFAULT (suser_name()) NOT NULL,
    [created_datetime] DATETIME2 (7)    DEFAULT (getutcdate()) NULL,
    PRIMARY KEY CLUSTERED ([arena_id] ASC)
);

