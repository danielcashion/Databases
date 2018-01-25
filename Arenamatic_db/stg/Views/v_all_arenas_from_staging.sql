CREATE VIEW stg.v_all_arenas_from_staging
AS 
	SELECT DISTINCT venue_name, 
					venue_city, 
					venue_state, 
					Upper(venue_id) AS venue_id, 
					'MLB'           AS league 
	FROM   [arenamatic_ref_utils].[stg].[v_mlb_venues] 
	WHERE  venue_name NOT IN ( 'AL City', 'NL City' ) 
		   AND venue_city IS NOT NULL 
	UNION 
	SELECT DISTINCT venue_name, 
					venue_city, 
					venue_state, 
					Upper(venue_id) AS venue_id, 
					'NCAA FB' 
	FROM   [arenamatic_ref_utils].[stg].[v_ncaafb_season_schedule] 
	WHERE  venue_name IS NOT NULL 
		   AND venue_city IS NOT NULL 
		   AND venue_id IS NOT NULL 
	UNION 
	SELECT DISTINCT venue_name, 
					venue_city, 
					venue_state, 
					Upper(venue_id) AS venue_id, 
					'NFL' 
	FROM   [arenamatic_ref_utils].[stg].[v_nfl_game_schedule] 
	WHERE  venue_name IS NOT NULL 
		   AND venue_city IS NOT NULL 
		   AND venue_id IS NOT NULL 
	UNION 
	SELECT DISTINCT venue_name, 
					venue_city, 
					venue_state, 
					Upper(venue_id) AS venue_id, 
					'NBA' 
	FROM   [arenamatic_ref_utils].[stg].[v_nba_season_schedule] 
	WHERE  venue_name IS NOT NULL 
		   AND venue_city IS NOT NULL 
		   AND venue_id IS NOT NULL 
