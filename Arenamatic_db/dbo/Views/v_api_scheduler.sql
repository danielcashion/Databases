CREATE VIEW v_api_scheduler 
AS

SELECT  P.provider_name, 
		E.view_name, 
		E.base_url, 
		E.api_endpoint, 
		E.[priority], 
		E.is_active AS endpoints_is_active,
		S.job_id,
		S.scheduled_datetime,
		S.parameter_order,
		S.parameter_name,
		S.parameter_value, 
		S.is_active AS scheduler_is_active
 FROM [meta].[api_endpoints] AS E
		JOIN [data].[api_providers] AS P
			ON E.provider_id	= p.provider_id
		JOIN [data].[api_scheduler] AS S
			ON E.api_id			= S.api_id
