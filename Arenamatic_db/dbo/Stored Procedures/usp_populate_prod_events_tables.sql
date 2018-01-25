


CREATE PROC [dbo].[usp_populate_prod_events_tables] (@event_type_name	VARCHAR(40), 
													@event_type_level1	VARCHAR(20))
AS 
BEGIN
/*		SAMPLE = EXEC [dbo].[usp_populate_prod_events_tables] 'Baseball', 'MLB'		*/
/*		CURRENTLY SCOPED FOR NFL, MLB, and NCAAFB DATA ONLY										*/

/*		FIRST DEFINE THE EVENT TYPE		*/
		DECLARE @event_type_id INT 	--, @event_type_name VARCHAR(40), @event_type_level1 VARCHAR(20)
									--	SET		@event_type_name	= 'Baseball'
									--	SET		@event_type_level1	= 'MLB'
		DECLARE @message VARCHAR(1000)

		-- ERROR HANDLING
		DECLARE @unique_string	VARCHAR(100)
		SET		@unique_string	= ISNULL(@event_type_level1,'') + ISNULL(@event_type_name,'')
		IF		@unique_string	NOT IN ('NFLFootball', 'MLBBaseball','NCAAFootball') -- Add to this IN statement accordingly
				BEGIN TRY
					PRINT 'Sorry, only NFL Football, NCAA Football, and MLB Baseball have been implemented.'
					RETURN
				END TRY
			
				BEGIN CATCH
				SET @message='ISSUE: '+ ERROR_MESSAGE();
			END CATCH

/*		HOQ process should start here, I am just too busy to write the code and the rule 9/26/2017		*/
/*		But first, hit the NFL tables		*/

	IF @event_type_name = 'Football' AND @event_type_level1 = 'NFL' 
		BEGIN
			IF EXISTS (	SELECT 1 FROM   arenamatic_ref_utils.stg.v_nfl_game_schedule 
								WHERE	1 = 1
									AND		game_id NOT IN (SELECT event_id 
														   FROM   [data].[arena_events])
						)
			BEGIN
				SELECT	@event_type_id = event_type_id FROM arenamatic_ref.data.arenas_event_types
									WHERE	event_type_name		= @event_type_name
										AND event_type_level1	= @event_type_level1

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

					SELECT CAST(@@ROWCOUNT AS VARCHAR) + ' events loaded for NFL Football'
				COMMIT TRAN 
			END
	
			/* STEP 2 - Ensure NFL Event participants is populated
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
					SELECT CAST(@@ROWCOUNT AS VARCHAR) as ' participants loaded for the NFL participants data.'
				COMMIT TRAN 
				/* LASTLY MAKE SURE THAT NFL ARENAS ARE IN THE ARENAS TABLE		*/
			IF EXISTS (SELECT 1 FROM [arenamatic_ref_utils].[stg].[v_nfl_hierarchy]
						WHERE venue_id NOT IN (select arena_id FROM arenamatic_ref.data.arenas))
				BEGIN		
					INSERT INTO [data].[arenas]
							   ([arena_id],[arena_name]
							   ,[arena_city],[arena_state]
							   ,[arena_country],[arena_zip]
							   ,[arena_address],[arena_capacity]
							   ,[arena_surface], [arena_is_active]
							   ,[created_by],[created_datetime]
					)
						 SELECT DISTINCT venue_id, venue_name
							   ,venue_city, venue_state
							   ,venue_country,venue_zip
							   ,venue_address, venue_capacity
							   ,venue_surface, 1
							   ,SUSER_NAME(),GETDATE()
							FROM [arenamatic_ref_utils].[stg].[v_nfl_hierarchy]
									where venue_id NOT IN (SELECT [arena_id] FROM [arenamatic_ref].[data].[arenas])
					SELECT CAST(@@rowcount AS VARCHAR) + ' Arenas added for the NFL'
				END
			END
		END
-------------------------------------------------------------------------------------------------------
/*		NEXT, hit the MLB tables		*/
	IF @event_type_name = 'Baseball' AND @event_type_level1 = 'MLB'
		BEGIN
			IF EXISTS (	SELECT 1 
								FROM   arenamatic_ref_utils.[stg].[v_mlb_league_schedule]
								WHERE	1 = 1
									AND		game_status IN ('if-necessary', 'scheduled')
									AND		game_id		NOT IN (SELECT event_id 
																FROM   [data].[arena_events])
						)
			BEGIN
				SELECT	@event_type_id = event_type_id FROM arenamatic_ref.data.arenas_event_types
									WHERE event_type_name = @event_type_name
									AND event_type_level1 = @event_type_level1

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
						   NULL AS game_utc_offset,	 -- THERE IS NO UTC OFFSET IN THE MLB DATASETCAST(game_utc_offset	AS INT), 
						   SUSER_NAME(), 
						   GETDATE() 
					FROM   arenamatic_ref_utils.stg.v_mlb_league_schedule 
					WHERE	1 = 1
						AND		game_status IN ('if-necessary', 'scheduled')
						AND		game_id		NOT IN (SELECT event_id 
													FROM   [data].[arena_events])

					SELECT CAST(@@ROWCOUNT AS VARCHAR) + ' events added for ' + @event_type_level1 + ' ' + @event_type_name + '.'
				COMMIT TRAN 
			END
	
			/* STEP 2 - MLB Event participants
					select top 1 * from arenamatic_ref.data.arenas_events_participants
			*/
			IF EXISTS (SELECT 1 FROM arenamatic_ref_utils.stg.v_mlb_league_schedule  
 								WHERE  game_id NOT IN (SELECT arena_events_id 
													   FROM   [arenamatic_ref].[data].[arenas_events_participants])
						)
			BEGIN
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
							FROM arenamatic_ref_utils.stg.v_mlb_league_schedule 
 								WHERE	1 = 1
								AND		game_status IN ('if-necessary', 'scheduled') 
								AND		game_id		NOT IN (SELECT arena_events_id 
															FROM   [arenamatic_ref].[data].[arenas_events_participants])
					
					SELECT CAST(@@ROWCOUNT AS VARCHAR) + ' participants added for ' + @event_type_level1 + ' ' + @event_type_name + '.'
				
			/* DOUBLE CHECK ARENAS TO MAKE SURE THAT THEY ARE IN THE ARENAS TABLE		*/
			IF EXISTS (SELECT 1 FROM [arenamatic_ref_utils].[stg].[v_mlb_venues]
						WHERE venue_id NOT IN (select arena_id FROM arenamatic_ref.data.arenas))
				BEGIN		
					INSERT INTO [data].[arenas]
							   ([arena_id],[arena_name]
							   ,[arena_city],[arena_state]
							   ,[arena_country],[arena_zip]
							   ,[arena_address],[arena_capacity]
							   ,[arena_surface], [arena_is_active]
							   ,[created_by],[created_datetime]
					)
						 SELECT venue_id, venue_name
							   ,venue_city, venue_state
							   ,venue_country,venue_zip
							   ,venue_address, venue_capacity
							   ,venue_surface, 1
							   ,SUSER_NAME(),GETDATE()
							FROM [arenamatic_ref_utils].[stg].[v_mlb_venues]
									where venue_id NOT IN (SELECT [arena_id] FROM [arenamatic_ref].[data].[arenas])
					SELECT CAST(@@ROWCOUNT AS VARCHAR) + ' arenas added for ' + @event_type_level1 + ' ' + @event_type_name + '.'
				END
			END
		END
-------------------------------------------------------------------------------------------------------
/*		NEXT, hit the NCAA Football tables		*/
	IF @event_type_name = 'Football' AND @event_type_level1 = 'NCAA'
		BEGIN
			IF EXISTS (	SELECT 1 
								FROM   arenamatic_ref_utils.[stg].[v_ncaafb_season_schedule]
								WHERE	1 = 1
									AND		game_status IN ('if-necessary', 'scheduled','time-tbd')
									AND		game_id		NOT IN (SELECT event_id 
																FROM   [data].[arena_events])
						)
			BEGIN
				SELECT	@event_type_id = event_type_id FROM arenamatic_ref.data.arenas_event_types
									WHERE event_type_name = @event_type_name
									AND event_type_level1 = @event_type_level1
									-- AND event_type_level2 = 'D1'

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
					SELECT DISTINCT 
						   CAST(venue_id		AS UNIQUEIDENTIFIER), 
						   CAST(game_id			AS UNIQUEIDENTIFIER), 
						   NULL, --@event_type_id, 
						   CAST(game_scheduled	AS DATETIME2), 
						   NULL, 
						   NULL AS game_utc_offset,	 -- THERE IS NO UTC OFFSET IN THE NCAAFB, 
						   SUSER_NAME(), 
						   GETDATE() 
					FROM   arenamatic_ref_utils.stg.v_ncaafb_season_schedule 
					WHERE	1 = 1
						AND		game_status IN ('if-necessary', 'scheduled', 'time-tbd')
						AND		game_id		IS NOT NULL
						AND		game_id		NOT IN (SELECT event_id 
													FROM   [data].[arena_events])
						AND		(game_home	IN (SELECT id FROM 	arenamatic_ref_utils.[stg].[ncaafb_team_hierarchy_team])
								OR game_away IN (SELECT id FROM 	arenamatic_ref_utils.[stg].[ncaafb_team_hierarchy_team]))
								-- D1 only please...

					SELECT CAST(@@ROWCOUNT AS VARCHAR) + ' events added for ' + @event_type_level1 + ' ' + @event_type_name + '.'
				COMMIT TRAN 
			END
	
			/* STEP 2 - NCAA FB Event participants
					select top 1 * from arenamatic_ref.data.arenas_events_participants
			*/
			IF EXISTS (SELECT 1 FROM arenamatic_ref_utils.stg.v_ncaafb_season_schedule  
 								WHERE  game_id NOT IN (SELECT arena_events_id 
													   FROM   [arenamatic_ref].[data].[arenas_events_participants])
						)
			BEGIN
					INSERT INTO [data].[arenas_events_participants]
							   ([arena_events_id]
							   ,[home_team_id]
							   ,[away_team_id]
							   ,[is_active]
							   ,[created_by]
							   ,[created_datetime])
						 SELECT DISTINCT
								VNSS.game_id, 
								NTHT_h.team_id	AS home_team_id, 
								NTHT_a.team_id	AS away_team_id, 
								1				AS is_active,
								SUSER_NAME()	AS created_by,
								GETDATE()		AS created_datetime
							FROM [arenamatic_ref_utils].[stg].[v_ncaafb_season_schedule] AS VNSS
							  JOIN [arenamatic_ref_utils].[stg].[ncaafb_team_hierarchy_team] AS NTHT_h -- join for home
									ON vnss.game_home = NTHT_h.id
							  JOIN [arenamatic_ref_utils].[stg].[ncaafb_team_hierarchy_team] AS NTHT_a -- self join for away
									ON vnss.game_home = NTHT_a.id
							WHERE	1 = 1
								AND		VNSS.game_id		NOT IN (SELECT arena_events_id 
															FROM   [arenamatic_ref].[data].[arenas_events_participants])
					
					SELECT CAST(@@ROWCOUNT AS VARCHAR) + ' participants added for ' + @event_type_level1 + ' ' + @event_type_name + '.'
				
			/* DOUBLE CHECK ARENAS TO MAKE SURE THAT THEY ARE IN THE ARENAS TABLE		*/
			IF EXISTS (SELECT 1 FROM [arenamatic_ref_utils].[stg].[v_mlb_venues]
						WHERE venue_id NOT IN (select arena_id FROM arenamatic_ref.data.arenas))
				BEGIN		
					INSERT INTO [data].[arenas]
							   ([arena_id],[arena_name]
							   ,[arena_city],[arena_state]
							   ,[arena_country],[arena_zip]
							   ,[arena_address],[arena_capacity]
							   ,[arena_surface], [arena_is_active]
							   ,[created_by],[created_datetime]
					)
						 SELECT DISTINCT 
							    venue_id, venue_name
							   ,venue_city, venue_state
							   ,venue_country,venue_zip
							   ,venue_address, venue_capacity
							   ,venue_surface, 1
							   ,SUSER_NAME(),GETDATE()
							FROM [arenamatic_ref_utils].[stg].[v_ncaafb_season_schedule] 
									where venue_id NOT IN (SELECT [arena_id] FROM [arenamatic_ref].[data].[arenas])

					SELECT CAST(@@ROWCOUNT AS VARCHAR) + ' arenas added for ' + @event_type_level1 + ' ' + @event_type_name + '.'
				END
			END
		END

END
