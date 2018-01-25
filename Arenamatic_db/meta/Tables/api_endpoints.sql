CREATE TABLE [meta].[api_endpoints] (
    [api_id]           INT            NOT NULL,
    [provider_id]      INT            NOT NULL,
    [view_name]        VARCHAR (50)   NOT NULL,
    [base_url]         NVARCHAR (100) NOT NULL,
    [api_endpoint]     NVARCHAR (200) NOT NULL,
    [priority]         TINYINT        NOT NULL,
    [is_active]        BIT            DEFAULT ((1)) NOT NULL,
    [created_datetime] DATETIME2 (7)  DEFAULT (getdate()) NOT NULL,
    [created_by]       NVARCHAR (40)  DEFAULT (suser_name()) NOT NULL,
    PRIMARY KEY CLUSTERED ([api_id] ASC)
);

