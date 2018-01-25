CREATE TABLE [data].[fileload_log] (
    [load_id]        UNIQUEIDENTIFIER NOT NULL,
    [provider_id]    INT              NOT NULL,
    [job_id]         INT              NULL,
    [step_id]        INT              NOT NULL,
    [status_id]      INT              NOT NULL,
    [start_datetime] DATETIME2 (7)    DEFAULT (getdate()) NOT NULL,
    [end_datetime]   DATETIME2 (7)    DEFAULT (getdate()) NULL,
    [notes]          VARCHAR (150)    NULL,
    [created_by]     VARCHAR (40)     DEFAULT (suser_name()) NOT NULL,
    [modified_by]    VARCHAR (40)     NULL
);

