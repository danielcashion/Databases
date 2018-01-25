CREATE TABLE [meta].[file_providers] (
    [provider_id]      INT            NOT NULL,
    [provider_name]    NVARCHAR (100) NOT NULL,
    [step_id]          INT            NOT NULL,
    [step_description] NVARCHAR (200) NOT NULL,
    [is_active]        BIT            DEFAULT ((1)) NOT NULL,
    [created_by]       NVARCHAR (40)  DEFAULT (suser_name()) NOT NULL,
    [created_datetime] DATETIME2 (7)  DEFAULT (getdate()) NOT NULL
);

