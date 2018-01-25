CREATE TABLE [meta].[api_parameter] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [param_name]       NVARCHAR (100) NULL,
    [table_name]       NVARCHAR (100) NULL,
    [column_name]      NVARCHAR (100) NULL,
    [api_id]           INT            NOT NULL,
    [is_active]        BIT            DEFAULT ((1)) NOT NULL,
    [created_datetime] DATETIME2 (7)  DEFAULT (getdate()) NOT NULL,
    [created_by]       NVARCHAR (40)  DEFAULT (suser_name()) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

