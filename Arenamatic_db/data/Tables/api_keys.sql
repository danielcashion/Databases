CREATE TABLE [data].[api_keys] (
    [column_id]         INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [provider_id]       INT           NOT NULL,
    [key_value]         VARCHAR (200) NOT NULL,
    [created_by]        VARCHAR (50)  DEFAULT (suser_name()) NOT NULL,
    [created_datetime]  DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [modified_by]       VARCHAR (50)  NULL,
    [modified_datetime] DATETIME2 (7) NULL,
    PRIMARY KEY CLUSTERED ([column_id] ASC)
);

