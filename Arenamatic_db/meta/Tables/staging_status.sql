CREATE TABLE [meta].[staging_status] (
    [status_id]        INT           NOT NULL,
    [status_value]     VARCHAR (40)  NOT NULL,
    [created_by]       VARCHAR (40)  DEFAULT (suser_name()) NOT NULL,
    [created_datetime] DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([status_id] ASC)
);

