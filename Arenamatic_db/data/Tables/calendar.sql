CREATE TABLE [data].[calendar] (
    [calendar_date]                  DATETIME     NULL,
    [calendar_date_txt]              VARCHAR (25) NULL,
    [calendar_day_name]              VARCHAR (10) NULL,
    [day_of_week_num]                SMALLINT     NULL,
    [day_of_month_num]               SMALLINT     NULL,
    [day_of_year_num]                SMALLINT     NULL,
    [calendar_week_num]              SMALLINT     NULL,
    [calendar_month_num]             SMALLINT     NULL,
    [calendar_month_name]            VARCHAR (8)  NULL,
    [calendar_quarter_num]           SMALLINT     NULL,
    [calendar_year_quarter_num]      SMALLINT     NULL,
    [calendar_year_num]              SMALLINT     NULL,
    [calendar_year_month_num]        INT          NULL,
    [holiday_ind]                    SMALLINT     NULL,
    [business_date]                  DATETIME     NULL,
    [prior_business_date]            DATETIME     NULL,
    [accounting_report_date]         DATETIME     NULL,
    [prior_business_week_date]       DATETIME     NULL,
    [last_day_of_month_ind]          BIGINT       NULL,
    [last_business_day_of_month_ind] BINARY (1)   NULL,
    [next_business_date]             DATETIME     NULL
);

