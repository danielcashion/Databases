CREATE TABLE [data].[ncaafb_teams] (
    [team_id]                 UNIQUEIDENTIFIER DEFAULT (newsequentialid()) NOT NULL,
    [team_name]               VARCHAR (50)     NOT NULL,
    [team_nickname]           VARCHAR (50)     NULL,
    [team_alt_id]             VARCHAR (10)     NOT NULL,
    [team_division_id]        VARCHAR (5)      NULL,
    [team_conference_level_1] VARCHAR (20)     NULL,
    [team_conference_level_2] VARCHAR (20)     NULL,
    [team_conference_level_3] VARCHAR (20)     NULL,
    [created_by]              VARCHAR (40)     DEFAULT (suser_name()) NOT NULL,
    [created_datetime]        DATETIME2 (7)    DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([team_id] ASC)
);

