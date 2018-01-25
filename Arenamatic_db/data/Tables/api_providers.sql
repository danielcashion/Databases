CREATE TABLE [data].[api_providers] (
    [provider_id]       INT           NOT NULL,
    [provider_name]     VARCHAR (100) NOT NULL,
    [created_by]        VARCHAR (50)  DEFAULT (suser_name()) NOT NULL,
    [created_datetime]  DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [modified_by]       VARCHAR (50)  NULL,
    [modified_datetime] DATETIME2 (7) NULL,
    CONSTRAINT [pk_api_providers] PRIMARY KEY CLUSTERED ([provider_name] ASC),
    CONSTRAINT [cont_api_providers_001] UNIQUE NONCLUSTERED ([provider_id] ASC)
);

