
CREATE PROC [dbo].[usp_populate_nfl_prod_calendar_view] (@event_type VARCHAR(40))
AS 
BEGIN
/*		FIRST ENTER THE EVENTS		*/
--		select top 1 * from [data].[arena_events]
		DECLARE @event_type_id INT --	, @event_type VARCHAR(40)
		SET		@event_type = 'Baseball'

/*		HOQ process should start here, I am just too busy to write the code and the rule 9/26/2017		*/
IF @event_type = 'Football' 
	BEGIN
		IF EXISTS (	SELECT 1 FROM   arenamatic_ref_utils.stg.v_nfl_game_schedule 
							WHERE	1 = 1
								AND		game_id NOT IN (SELECT event_id 
													   FROM   [data].[arena_events])
					)
		BEGIN
			SELECT	@event_type_id = event_type_id FROM arenamatic_ref.data.arenas_event_types
								WHERE event_type_name = @event_type

				BEGIN TRAN 
				INSERT INTO [data].[arena_events] 
							([arena_id], 
							 [event_id], 
							 [event_type_id], 
							 [event_startdatetime_utc], 
							 [event_enddatetime_utc], 
							 [utc_offset], 
							 [created_by], 
							 [created_datetime]) 
				SELECT CAST(venue_id		AS UNIQUEIDENTIFIER), 
					   CAST(game_id			AS UNIQUEIDENTIFIER), 
					   @event_type_id, 
					   CAST(game_scheduled	AS DATETIME2), 
					   NULL, 
					   CAST(game_utc_offset	AS INT), 
					   SUSER_NAME(), 
					   GETDATE() 
				FROM   arenamatic_ref_utils.stg.v_nfl_game_schedule 
				WHERE	1 = 1
					AND		game_id IN (SELECT event_id 
									   FROM   [data].[arena_events])

				SELECT @@ROWCOUNT 
			COMMIT TRAN 
		END
	
		/* STEP 2 - NFL Event participants
				select top 1 * from arenamatic_ref.data.arenas_events_participants
		*/
		IF EXISTS (SELECT 1 FROM arenamatic_ref_utils.stg.v_nfl_game_schedule 
 							WHERE  game_id NOT IN (SELECT arena_events_id 
												   FROM   [arenamatic_ref].[data].[arenas_events_participants])
					)
		BEGIN
			 BEGIN TRAN
				INSERT INTO [data].[arenas_events_participants]
						   ([arena_events_id]
						   ,[home_team_id]
						   ,[away_team_id]
						   ,[is_active]
						   ,[created_by]
						   ,[created_datetime])
					 SELECT 
							game_id AS arena_events_id,
							home_id AS home_team_id,
							away_id AS away_team_id,
							1 as is_active,
							SUSER_NAME() AS created_by,
							GETDATE() AS created_datetime
						FROM arenamatic_ref_utils.stg.v_nfl_game_schedule 
 							WHERE  game_id NOT IN (SELECT arena_events_id 
												   FROM   [arenamatic_ref].[data].[arenas_events_participants])
				SELECT @@ROWCOUNT 
			COMMIT TRAN 
		END
	END
END
