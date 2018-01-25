CREATE FUNCTION [fn].[next_scheduler_job_id]()
RETURNS INT
AS BEGIN
		DECLARE @current_max INT, @next_job_id INT
		SELECT  @current_max = ISNULL(MAX(job_id),0) FROM [data].[api_scheduler]
		SET		@next_job_id = @current_max + 1

		RETURN	@next_job_id
	END