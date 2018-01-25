

CREATE VIEW [dbo].[v_arena_calendar]
AS 		
/*		Created by			dcashion
		Created date		8/21/2017
		NOTES
			Can add to the columns, but this is a good reference
			Added UTC date relativity 9/26/2017
*/

	SELECT 
			ae.event_startdatetime_utc
		,	ae.event_enddatetime_utc
		,	a.arena_timezone_utc_offset
		,	DATEADD(HOUR, a.arena_timezone_utc_offset,ae.event_startdatetime_utc)
							AS startdatetime_local
		,   DATEDIFF(minute, GETUTCDATE(), ae.event_startdatetime_utc)	
							AS minutes_until_start
				
		,	aet.event_type_name
		,	aet.event_type_level1
		,	aet.event_type_level2
		,	aet.event_type_level3
		,	ae.arena_id
		,	ae.event_id
		,	a.arena_name
		,	a.arena_city
		,	a.arena_country
		,	a.arena_address
		,	a.arena_state
		,	a.arena_zip
		,	aep.home_team_id
		,	p1.team_name				AS home_team_name
		,	p1.team_alias				AS home_team_alias
		,	p1.team_notes_1				AS home_team_notes1
		,	aep.away_team_id
		,	p2.team_name				AS away_team_name
		,	p2.team_alias				AS away_team_alias
		,	p2.team_notes_1				AS away_team_notes1
		FROM [arenamatic_ref].[data].[arena_events]								AS ae
		JOIN [arenamatic_ref].[data].[arenas_event_types]						AS aet
				ON ae.event_type_id = aet.event_type_id
		LEFT OUTER JOIN [data].[arenas]											AS a
				ON a.arena_id = ae.arena_id
		LEFT OUTER JOIN [arenamatic_ref].[data].[arenas_events_participants]	AS aep
				ON aep.arena_events_id = ae.event_id
		LEFT OUTER JOIN [arenamatic_ref].[data].[participants]					AS p1
				ON aep.home_team_id = p1.team_id
		LEFT OUTER JOIN [arenamatic_ref].[data].[participants]					AS p2
				ON aep.away_team_id = p2.team_id



GO
GRANT SELECT
    ON OBJECT::[dbo].[v_arena_calendar] TO PUBLIC
    AS [dbo];

