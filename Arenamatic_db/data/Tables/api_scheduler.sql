CREATE TABLE [data].[api_scheduler] (
    [scheduler_id]       INT           IDENTITY (1, 1) NOT NULL,
    [job_id]             INT           NOT NULL,
    [provider_id]        INT           NOT NULL,
    [api_id]             INT           NOT NULL,
    [scheduled_datetime] DATETIME2 (7) DEFAULT (getdate()) NULL,
    [parameter_order]    INT           NOT NULL,
    [parameter_name]     VARCHAR (40)  NOT NULL,
    [parameter_value]    VARCHAR (100) NOT NULL,
    [is_active]          BIT           DEFAULT ((1)) NULL,
    [created_by]         NVARCHAR (40) NOT NULL,
    [created_datetime]   DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [updated_by]         NVARCHAR (40) NULL,
    [updated_datetime]   DATETIME2 (7) NULL,
    PRIMARY KEY CLUSTERED ([scheduler_id] ASC),
    CONSTRAINT [fk_api_scheduler_001] FOREIGN KEY ([provider_id]) REFERENCES [data].[api_providers] ([provider_id]),
    CONSTRAINT [fk_api_scheduler_002] FOREIGN KEY ([api_id]) REFERENCES [meta].[api_endpoints] ([api_id])
);

