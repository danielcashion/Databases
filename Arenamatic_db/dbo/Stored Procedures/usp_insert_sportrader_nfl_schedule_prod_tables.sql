



CREATE PROCEDURE [dbo].[usp_insert_sportrader_nfl_schedule_prod_tables]
AS BEGIN
	/*	DATE		EDITOR		NOTES
		8/3/2017	dcashion	creation

		PURPOSE:	INSERT ROWS INTO PRODUCTION TABLES FOR THE SPORTRADAR DATA
		SAMPLE EXE:	EXEC usp_populate_sportrader_prod_tables
	*/

/*	FIRST: nfl_season 
	logic; insert into table appropriate value where the game_id does not exist and log in HOQ */
IF EXISTS (SELECT 1 FROM [arenamatic_ref_utils].stg.[v_nfl_game_schedule]
					WHERE game_id NOT IN 
						(SELECT game_id FROM [arenamatic_ref].[data].[nfl_season] )
			)

	BEGIN
		INSERT INTO [arenamatic_ref].[data].[nfl_season] ([season_id], [season_year], [season_type], [season_name], [week_id],	[week_sequence], [week_title], [game_id], [game_status], [game_reference], [game_number], [game_scheduled], 
			[game_attendance], [game_utc_offset], [game_entry_mode], [game_weather], [venue_id], [venue_name], 
			[venue_city], [venue_state], [venue_country], [venue_zip], [venue_address], [venue_capacity], 
			[venue_surface], [venue_roof_type], [home_id], [home_name], [home_alias], [home_game_number], 
			[away_id], [away_name], [away_alias], [away_game_number], [broadcast_network], 
			[broadcast_satellite], [broadcast_internet])
			SELECT 
					CAST([season_id]		AS UNIQUEIDENTIFIER) , 
					CAST([season_year]		AS INT) , 
					CAST([season_type]		AS VARCHAR) , 
					CAST([season_name]		AS VARCHAR) , 
					CAST([week_id]			AS UNIQUEIDENTIFIER) , 
					CAST([week_sequence]	AS INT) , 
					CAST([week_title]		AS INT) , 
					CAST([game_id]			AS UNIQUEIDENTIFIER) , 
					CAST([game_status]		AS VARCHAR) , 
					CAST([game_reference]	AS INT) , 
					CAST([game_number]		AS INT) , 
					CAST([game_scheduled]	AS DATETIME2) , 
					NULL AS game_attendance,--CAST([game_attendance]	AS INT) , 
					NULL AS game_utc_offset, --CAST([game_utc_offset]	AS INT) , 
					CAST([game_entry_mode]	AS VARCHAR) , 
					NULL AS game_weather, --CAST([game_weather]		AS VARCHAR) , 
					CAST([venue_id]			AS UNIQUEIDENTIFIER) , 
					CAST([venue_name]		AS VARCHAR) , 
					CAST([venue_city]		AS VARCHAR) , 
					CAST([venue_state]		AS VARCHAR) , 
					CAST([venue_country]	AS VARCHAR) , 
					CAST([venue_zip]		AS VARCHAR) , 
					CAST([venue_address]	AS VARCHAR) , 
					CAST([venue_capacity]	AS INT) , 
					CAST([venue_surface]	AS VARCHAR) , 
					CAST([venue_roof_type]	AS VARCHAR) , 
					CAST([home_id]			AS UNIQUEIDENTIFIER) , 
					CAST([home_name]		AS VARCHAR) , 
					CAST([home_alias]		AS VARCHAR) , 
					CAST([home_game_number] AS INT) , 
					CAST([away_id]			AS UNIQUEIDENTIFIER) , 
					CAST([away_name]		AS VARCHAR) , 
					CAST([away_alias]		AS VARCHAR) , 
					CAST([away_game_number] AS INT) , 
					CAST([broadcast_network] AS VARCHAR) , 
					CAST([broadcast_satellite] AS VARCHAR) , 
					CAST([broadcast_internet] AS VARCHAR) 
			FROM [arenamatic_ref_utils].stg.[v_nfl_game_schedule]
				-- We might want to pull from v_nfl_weekly_schedule but at the time of dev, the data are different even while the views look the same
				-- one pulls from [nfl_weekly_schedule_season] (14 rows) whereas v_nfl_game_schedule pulls from [stg].[nfl_game_schedule_season]
					WHERE game_id NOT IN 
							(SELECT game_id FROM [arenamatic_ref].[data].[nfl_season])
		SELECT CAST(@@ROWCOUNT AS VARCHAR) + ' rows inserted for the NFL games.'	
			-- INSERT INTO how.hoq_message with the @@ROWCOUNT for the number of inserts
	END

/*	NFL_Hierarchy 
	logic; insert into table appropriate value where the game_id does not exist */
IF EXISTS (SELECT 1 FROM [arenamatic_ref_utils].[stg].[v_nfl_hierarchy] 
				WHERE team_id NOT IN 
				(SELECT team_id FROM [arenamatic_ref].[data].[nfl_league_hierarchy])
			)
	BEGIN
		INSERT INTO [arenamatic_ref].[data].[nfl_league_hierarchy] 
			([team_id], [team_name], [team_market], [team_alias], [team_division_Id], [team_league_Id], [league_id], 
			[league_name], [league_alias], [league_Load_Id], [conference_id], [conference_name], [conference_alias], 
			[conference_league_Id], [division_id], [division_name], [division_alias], [division_conference_Id],[division_league_Id],[references_team_Id], [references_league_Id], [reference_id], [reference_origin], [reference_references_Id],[reference_league_Id], [venue_id], [venue_name], [venue_city], [venue_state], [venue_country], [venue_zip], [venue_address],[venue_capacity], [venue_surface], [venue_roof_type], [venue_team_Id], [venue_league_Id],[created_by],[created_datetime])
				SELECT TOP 100		-- it would be an obvious error if there were > 100 inserts
				CAST([team_id]				AS UNIQUEIDENTIFIER),
				CAST([team_name]			AS VARCHAR(60)),
				CAST([team_market]			AS VARCHAR(60)),
				CAST([team_alias]			AS VARCHAR(10)),
				CAST([team_division_Id]		AS UNIQUEIDENTIFIER),
				CAST([team_league_Id]		AS UNIQUEIDENTIFIER),
				CAST([league_id]			AS UNIQUEIDENTIFIER),
				CAST([league_name]			AS VARCHAR(60)),
				CAST([league_alias]			AS VARCHAR(10)),
				CAST([league_Load_Id]		AS UNIQUEIDENTIFIER),
				CAST([conference_id]		AS UNIQUEIDENTIFIER),
				CAST([conference_name]		AS VARCHAR(60)),
				CAST([conference_alias]		AS VARCHAR(10)),
				CAST([conference_league_Id] AS UNIQUEIDENTIFIER),
				CAST([division_id]			AS UNIQUEIDENTIFIER),
				CAST([division_name]		AS VARCHAR(60)),
				CAST([division_alias]		AS VARCHAR(10)),
				CAST([division_conference_Id] AS UNIQUEIDENTIFIER),
				CAST([division_league_Id]	AS UNIQUEIDENTIFIER),
				CAST([references_team_Id]	AS UNIQUEIDENTIFIER),
				CAST([references_league_Id] AS UNIQUEIDENTIFIER),
				CAST([reference_id]			AS VARCHAR(10)),
				CAST([reference_origin]		AS VARCHAR(10)),
				CAST([reference_references_Id] AS INT),
				CAST([reference_league_Id]	AS UNIQUEIDENTIFIER),
				CAST([venue_id]				AS UNIQUEIDENTIFIER),
				CAST([venue_name]			AS VARCHAR(40)),
				CAST([venue_city]			AS VARCHAR(40)),
				CAST([venue_state]			AS VARCHAR(20)),
				CAST([venue_country]		AS VARCHAR(20)),
				CAST([venue_zip]			AS INT),
				CAST([venue_address]		AS VARCHAR(60)),
				CAST([venue_capacity]		AS INT),
				CAST([venue_surface]		AS VARCHAR(20)),
				CAST([venue_roof_type]		AS VARCHAR(30)),
				CAST([venue_team_Id]		AS UNIQUEIDENTIFIER),
				CAST([venue_league_Id]		AS UNIQUEIDENTIFIER),
				SUSER_NAME(),
				GETDATE()
		FROM [arenamatic_ref_utils].[stg].[v_nfl_hierarchy] AS stg
				WHERE stg.team_id NOT IN 
								(SELECT team_id FROM [arenamatic_ref].[data].[nfl_league_hierarchy])
		--INSERT INTO hoq.hoq_message where @@rowcount is added
	END

END

