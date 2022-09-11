create procedure usp_requests_upsert (
	@id int = null,
	@timestamp datetime = null
) as begin
	if @id is null begin
		insert into requests (
			timestamp
		) values (
			@timestamp
		)
		select scope_identity()
	end else begin
		update requests set
			timestamp = isnull(@timestamp, timestamp)
		where id = @id
		select @id
	end
end
go
create procedure usp_clans_upsert (
	@request_id int = null,
	@tag nvarchar(16) = null,
	@name nvarchar(256) = null,
	@description nvarchar(max) = null,
	@location_id int = null,
	@location_name nvarchar(256) = null,
	@location_is_country bit = null,
	@location_country_code nvarchar(8) = null,
	@badge_urls_small nvarchar(256) = null,
	@badge_urls_large nvarchar(256) = null,
	@badge_urls_medium nvarchar(256) = null,
	@clan_level int = null,
	@clan_points int = null,
	@clan_versus_points int = null,
	@required_trophies int = null,
	@war_frequency nvarchar(256) = null,
	@war_win_streak int = null,
	@war_wins int = null,
	@war_ties int = null,
	@war_losses int = null,
	@is_war_log_public bit = null,
	@war_league_id int = null,
	@war_league_name nvarchar(256) = null,
	@members int = null,
	@chat_language_id int = null,
	@chat_language_name nvarchar(256) = null,
	@chat_language_language_code nvarchar(8) = null,
	@required_versus_trophies int = null,
	@required_townhall_level int = null
) as begin
	declare @id int = null
	select @id = id from clans where request_id = @request_id and tag = @tag
	if @id is null begin
		insert into clans (
			request_id,
			tag,
			name,
			description,
			location_id,
			location_name,
			location_is_country,
			location_country_code,
			badge_urls_small,
			badge_urls_large,
			badge_urls_medium,
			clan_level,
			clan_points,
			clan_versus_points,
			required_trophies,
			war_frequency,
			war_win_streak,
			war_wins,
			war_ties,
			war_losses,
			is_war_log_public,
			war_league_id,
			war_league_name,
			members,
			chat_language_id,
			chat_language_name,
			chat_language_language_code,
			required_versus_trophies,
			required_townhall_level
		) values (
			@request_id,
			@tag,
			@name,
			@description,
			@location_id,
			@location_name,
			@location_is_country,
			@location_country_code,
			@badge_urls_small,
			@badge_urls_large,
			@badge_urls_medium,
			@clan_level,
			@clan_points,
			@clan_versus_points,
			@required_trophies,
			@war_frequency,
			@war_win_streak,
			@war_wins,
			@war_ties,
			@war_losses,
			@is_war_log_public,
			@war_league_id,
			@war_league_name,
			@members,
			@chat_language_id,
			@chat_language_name,
			@chat_language_language_code,
			@required_versus_trophies,
			@required_townhall_level
		)
		select scope_identity()
	end else begin
		update clans set
			request_id = isnull(@request_id, request_id),
			tag = isnull(@tag, tag),
			name = isnull(@name, name),
			description = isnull(@description, description),
			location_id = isnull(@location_id, location_id),
			location_name = isnull(@location_name, location_name),
			location_is_country = isnull(@location_is_country, location_is_country),
			location_country_code = isnull(@location_country_code, location_country_code),
			badge_urls_small = isnull(@badge_urls_small, badge_urls_small),
			badge_urls_large = isnull(@badge_urls_large, badge_urls_large),
			badge_urls_medium = isnull(@badge_urls_medium, badge_urls_medium),
			clan_level = isnull(@clan_level, clan_level),
			clan_points = isnull(@clan_points, clan_points),
			clan_versus_points = isnull(@clan_versus_points, clan_versus_points),
			required_trophies = isnull(@required_trophies, required_trophies),
			war_frequency = isnull(@war_frequency, war_frequency),
			war_win_streak = isnull(@war_win_streak, war_win_streak),
			war_wins = isnull(@war_wins, war_wins),
			war_ties = isnull(@war_ties, war_ties),
			war_losses = isnull(@war_losses, war_losses),
			is_war_log_public = isnull(@is_war_log_public, is_war_log_public),
			war_league_id = isnull(@war_league_id, war_league_id),
			war_league_name = isnull(@war_league_name, war_league_name),
			members = isnull(@members, members),
			chat_language_id = isnull(@chat_language_id, chat_language_id),
			chat_language_name = isnull(@chat_language_name, chat_language_name),
			chat_language_language_code = isnull(@chat_language_language_code, chat_language_language_code),
			required_versus_trophies = isnull(@required_versus_trophies, required_versus_trophies),
			required_townhall_level = isnull(@required_townhall_level, required_townhall_level)
		where id = @id
		select @id
	end
end
go
create procedure usp_members_upsert (
	@clan_id int = null,
	@tag nvarchar(16) = null,
	@name nvarchar(256) = null,
	@role nvarchar(16) = null,
	@exp_level int = null,
	@league_id int = null,
	@league_name nvarchar(16) = null,
	@league_icon_urls_small nvarchar(256) = null,
	@league_icon_urls_tiny nvarchar(256) = null,
	@trophies int = null,
	@versus_trophies int = null,
	@clan_rank int = null,
	@previous_clan_rank int = null,
	@donations int = null,
	@donations_received int = null
) as begin
	declare @id int = null
	select @id = id from members where clan_id = @clan_id and tag = @tag
	if @id is null begin
		insert into members (
			clan_id,
			tag,
			name,
			role,
			exp_level,
			league_id,
			league_name,
			league_icon_urls_small,
			league_icon_urls_tiny,
			trophies,
			versus_trophies,
			clan_rank,
			previous_clan_rank,
			donations,
			donations_received
		) values (
			@clan_id,
			@tag,
			@name,
			@role,
			@exp_level,
			@league_id,
			@league_name,
			@league_icon_urls_small,
			@league_icon_urls_tiny,
			@trophies,
			@versus_trophies,
			@clan_rank,
			@previous_clan_rank,
			@donations,
			@donations_received
		)
		select scope_identity()
	end else begin
		update members set
			clan_id = isnull(@clan_id, clan_id),
			tag = isnull(@tag, tag),
			name = isnull(@name, name),
			role = isnull(@role, role),
			exp_level = isnull(@exp_level, exp_level),
			league_id = isnull(@league_id, league_id),
			league_name = isnull(@league_name, league_name),
			league_icon_urls_small = isnull(@league_icon_urls_small, league_icon_urls_small),
			league_icon_urls_tiny = isnull(@league_icon_urls_tiny, league_icon_urls_tiny),
			trophies = isnull(@trophies, trophies),
			versus_trophies = isnull(@versus_trophies, versus_trophies),
			clan_rank = isnull(@clan_rank, clan_rank),
			previous_clan_rank = isnull(@previous_clan_rank, previous_clan_rank),
			donations = isnull(@donations, donations),
			donations_received = isnull(@donations_received, donations_received)
		where id = @id
		select @id
	end
end
go
create procedure usp_league_groups_upsert (
	@request_id int = null,
	@state nvarchar(16) = null,
	@season nvarchar(16) = null
) as begin
	declare @id int = null
	select @id = id from league_groups where season = @season
	if @id is null begin
		insert into league_groups (
			request_id,
			state,
			season
		) values (
			@request_id,
			@state,
			@season
		)
		select scope_identity()
	end else begin
		update league_groups set
			request_id = isnull(@request_id, request_id),
			state = isnull(@state, state),
			season = isnull(@season, season)
		where id = @id
		select @id
	end
end
go
create procedure usp_league_group_clans_upsert (
	@league_group_id int = null,
	@tag nvarchar(16) = null,
	@name nvarchar(256) = null,
	@clan_level int = null,
	@badge_urls_small nvarchar(256) = null,
	@badge_urls_large nvarchar(256) = null,
	@badge_urls_medium nvarchar(256) = null
) as begin
	declare @id int = null
	select @id = id from league_group_clans where league_group_id = @league_group_id and tag = @tag
	if @id is null begin
		insert into league_group_clans (
			league_group_id,
			tag,
			name,
			clan_level,
			badge_urls_small,
			badge_urls_large,
			badge_urls_medium
		) values (
			@league_group_id,
			@tag,
			@name,
			@clan_level,
			@badge_urls_small,
			@badge_urls_large,
			@badge_urls_medium
		)
		select scope_identity()
	end else begin
		update league_group_clans set
			league_group_id = isnull(@league_group_id, league_group_id),
			tag = isnull(@tag, tag),
			name = isnull(@name, name),
			clan_level = isnull(@clan_level, clan_level),
			badge_urls_small = isnull(@badge_urls_small, badge_urls_small),
			badge_urls_large = isnull(@badge_urls_large, badge_urls_large),
			badge_urls_medium = isnull(@badge_urls_medium, badge_urls_medium)
		where id = @id
		select @id
	end
end
go
create procedure usp_league_group_clan_members_upsert (
	@league_group_clan_id int = null,
	@tag nvarchar(16) = null,
	@name nvarchar(256) = null,
	@town_hall_level int = null
) as begin
	declare @id int = null
	select @id = id from league_group_clan_members where league_group_clan_id = @league_group_clan_id and tag = @tag
	if @id is null begin
		insert into league_group_clan_members (
			league_group_clan_id,
			tag,
			name,
			town_hall_level
		) values (
			@league_group_clan_id,
			@tag,
			@name,
			@town_hall_level
		)
		select scope_identity()
	end else begin
		update league_group_clan_members set
			league_group_clan_id = isnull(@league_group_clan_id, league_group_clan_id),
			tag = isnull(@tag, tag),
			name = isnull(@name, name),
			town_hall_level = isnull(@town_hall_level, town_hall_level)
		where id = @id
		select @id
	end
end
go
create procedure usp_league_group_rounds_upsert (
	@league_group_id int = null,
	@day_number int = null
) as begin
	declare @id int = null
	select @id = id from league_group_rounds where league_group_id = @league_group_id and day_number = @day_number
	if @id is null begin
		insert into league_group_rounds (
			league_group_id,
			day_number
		) values (
			@league_group_id,
			@day_number
		)
		select scope_identity()
	end else begin
		update league_group_rounds set
			league_group_id = isnull(@league_group_id, league_group_id),
			day_number = isnull(@day_number, day_number)
		where id = @id
		select @id
	end
end
go
create procedure usp_league_wars_upsert (
	@league_group_round_id int = null,
	@war_tag nvarchar(16) = null
) as begin
	declare @id int = null
	select @id = id from league_wars where league_group_round_id = @league_group_round_id and war_tag = @war_tag
	if @id is null begin
		insert into league_wars (
			league_group_round_id,
			war_tag
		) values (
			@league_group_round_id,
			@war_tag
		)
		select scope_identity()
	end else begin
		update league_wars set
			league_group_round_id = isnull(@league_group_round_id, league_group_round_id),
			war_tag = isnull(@war_tag, war_tag)
		where id = @id
		select @id
	end
end
go
create procedure usp_league_war_details_upsert (
	@league_war_id int = null,
	@state nvarchar(16) = null,
	@team_size int = null,
	@preparation_start_time datetime = null,
	@start_time datetime = null,
	@end_time datetime = null,
	@war_start_time datetime = null
) as begin
	declare @id int = null
	select @id = id from league_war_details where league_war_id = @league_war_id
	if @id is null begin
		insert into league_war_details (
			league_war_id,
			state,
			team_size,
			preparation_start_time,
			start_time,
			end_time,
			war_start_time
		) values (
			@league_war_id,
			@state,
			@team_size,
			@preparation_start_time,
			@start_time,
			@end_time,
			@war_start_time
		)
		select scope_identity()
	end else begin
		update league_war_details set
			league_war_id = isnull(@league_war_id, league_war_id),
			state = isnull(@state, state),
			team_size = isnull(@team_size, team_size),
			preparation_start_time = isnull(@preparation_start_time, preparation_start_time),
			start_time = isnull(@start_time, start_time),
			end_time = isnull(@end_time, end_time),
			war_start_time = isnull(@war_start_time, war_start_time)
		where id = @id
		select @id
	end
end
go
create procedure usp_league_war_clans_upsert (
	@league_war_id int = null,
	@tag nvarchar(16) = null,
	@name nvarchar(256) = null,
	@badge_urls_small nvarchar(256) = null,
	@badge_urls_large nvarchar(256) = null,
	@badge_urls_medium nvarchar(256) = null,
	@clan_level int = null,
	@attacks int = null,
	@stars int = null,
	@destruction_percentage float = null
) as begin
	declare @id int = null
	select @id = id from league_war_clans where league_war_id = @league_war_id and tag = @tag
	if @id is null begin
		insert into league_war_clans (
			league_war_id,
			tag,
			name,
			badge_urls_small,
			badge_urls_large,
			badge_urls_medium,
			clan_level,
			attacks,
			stars,
			destruction_percentage
		) values (
			@league_war_id,
			@tag,
			@name,
			@badge_urls_small,
			@badge_urls_large,
			@badge_urls_medium,
			@clan_level,
			@attacks,
			@stars,
			@destruction_percentage
		)
		select scope_identity()
	end else begin
		update league_war_clans set
			league_war_id = isnull(@league_war_id, league_war_id),
			tag = isnull(@tag, tag),
			name = isnull(@name, name),
			badge_urls_small = isnull(@badge_urls_small, badge_urls_small),
			badge_urls_large = isnull(@badge_urls_large, badge_urls_large),
			badge_urls_medium = isnull(@badge_urls_medium, badge_urls_medium),
			clan_level = isnull(@clan_level, clan_level),
			attacks = isnull(@attacks, attacks),
			stars = isnull(@stars, stars),
			destruction_percentage = isnull(@destruction_percentage, destruction_percentage)
		where id = @id
		select @id
	end
end
go
create procedure usp_league_war_clan_members_upsert (
	@league_war_clan_id int = null,
	@tag nvarchar(16) = null,
	@name nvarchar(256) = null,
	@town_hall_level int = null,
	@map_position int = null,
	@opponent_attacks int = null,
	@best_opponent_attack_attacker_tag nvarchar(16) = null,
	@best_opponent_attack_defender_tag nvarchar(16) = null,
	@best_opponent_attack_stars int = null,
	@best_opponent_attack_destruction_percentage int = null,
	@best_opponent_attack_order int = null,
	@best_opponent_attack_duration int = null,
	@attack_attacker_tag nvarchar(16) = null,
	@attack_defender_tag nvarchar(16) = null,
	@attack_stars int = null,
	@attack_destruction_percentage int = null,
	@attack_order int = null,
	@attack_duration int = null
) as begin
	declare @id int = null
	select @id = id from league_war_clan_members where league_war_clan_id = @league_war_clan_id and tag = @tag
	if @id is null begin
		insert into league_war_clan_members (
			league_war_clan_id,
			tag,
			name,
			town_hall_level,
			map_position,
			opponent_attacks,
			best_opponent_attack_attacker_tag,
			best_opponent_attack_defender_tag,
			best_opponent_attack_stars,
			best_opponent_attack_destruction_percentage,
			best_opponent_attack_order,
			best_opponent_attack_duration,
			attack_attacker_tag,
			attack_defender_tag,
			attack_stars,
			attack_destruction_percentage,
			attack_order,
			attack_duration
		) values (
			@league_war_clan_id,
			@tag,
			@name,
			@town_hall_level,
			@map_position,
			@opponent_attacks,
			@best_opponent_attack_attacker_tag,
			@best_opponent_attack_defender_tag,
			@best_opponent_attack_stars,
			@best_opponent_attack_destruction_percentage,
			@best_opponent_attack_order,
			@best_opponent_attack_duration,
			@attack_attacker_tag,
			@attack_defender_tag,
			@attack_stars,
			@attack_destruction_percentage,
			@attack_order,
			@attack_duration
		)
		select scope_identity()
	end else begin
		update league_war_clan_members set
			league_war_clan_id = isnull(@league_war_clan_id, league_war_clan_id),
			tag = isnull(@tag, tag),
			name = isnull(@name, name),
			town_hall_level = isnull(@town_hall_level, town_hall_level),
			map_position = isnull(@map_position, map_position),
			opponent_attacks = isnull(@opponent_attacks, opponent_attacks),
			best_opponent_attack_attacker_tag = isnull(@best_opponent_attack_attacker_tag, best_opponent_attack_attacker_tag),
			best_opponent_attack_defender_tag = isnull(@best_opponent_attack_defender_tag, best_opponent_attack_defender_tag),
			best_opponent_attack_stars = isnull(@best_opponent_attack_stars, best_opponent_attack_stars),
			best_opponent_attack_destruction_percentage = isnull(@best_opponent_attack_destruction_percentage, best_opponent_attack_destruction_percentage),
			best_opponent_attack_order = isnull(@best_opponent_attack_order, best_opponent_attack_order),
			best_opponent_attack_duration = isnull(@best_opponent_attack_duration, best_opponent_attack_duration),
			attack_attacker_tag = isnull(@attack_attacker_tag, attack_attacker_tag),
			attack_defender_tag = isnull(@attack_defender_tag, attack_defender_tag),
			attack_stars = isnull(@attack_stars, attack_stars),
			attack_destruction_percentage = isnull(@attack_destruction_percentage, attack_destruction_percentage),
			attack_order = isnull(@attack_order, attack_order),
			attack_duration = isnull(@attack_duration, attack_duration)
		where id = @id
		select @id
	end
end
go
create procedure usp_league_war_state_get (
	@war_tag nvarchar(16)
) as begin
	select
		lwd.state
	from
		league_wars lw
		join league_war_details lwd on lwd.league_war_id = lw.id
	where
		lw.war_tag = @war_tag
end
go
create procedure usp_league_group_state_get (
	@season nvarchar(16)
) as begin
	select
		state
	from
		league_groups
	where
		season = @season
end
go
create procedure usp_wars_upsert (
	@request_id int = null,
	@state nvarchar(16) = null,
	@team_size int = null,
	@attacks_per_member int = null,
	@preparation_start_time datetime = null,
	@start_time datetime = null,
	@end_time datetime = null
) as begin
	declare @id int = null
	select @id = id from wars where start_time = @start_time
	if @id is null begin
		insert into wars (
			request_id,
			state,
			team_size,
			attacks_per_member,
			preparation_start_time,
			start_time,
			end_time
		) values (
			@request_id,
			@state,
			@team_size,
			@attacks_per_member,
			@preparation_start_time,
			@start_time,
			@end_time
		)
		select scope_identity()
	end else begin
		update wars set
			request_id = isnull(@request_id, request_id),
			state = isnull(@state, state),
			team_size = isnull(@team_size, team_size),
			attacks_per_member = isnull(@attacks_per_member, attacks_per_member),
			preparation_start_time = isnull(@preparation_start_time, preparation_start_time),
			start_time = isnull(@start_time, start_time),
			end_time = isnull(@end_time, end_time)
		where id = @id
		select @id
	end
end
go
create procedure usp_war_clans_upsert (
	@war_id int = null,
	@tag nvarchar(16) = null,
	@name nvarchar(256) = null,
	@badge_urls_small nvarchar(256) = null,
	@badge_urls_large nvarchar(256) = null,
	@badge_urls_medium nvarchar(256) = null,
	@clan_level int = null,
	@attacks int = null,
	@stars int = null,
	@destruction_percentage float = null
) as begin
	declare @id int = null
	select @id = id from war_clans where war_id = @war_id and tag = @tag
	if @id is null begin
		insert into war_clans (
			war_id,
			tag,
			name,
			badge_urls_small,
			badge_urls_large,
			badge_urls_medium,
			clan_level,
			attacks,
			stars,
			destruction_percentage
		) values (
			@war_id,
			@tag,
			@name,
			@badge_urls_small,
			@badge_urls_large,
			@badge_urls_medium,
			@clan_level,
			@attacks,
			@stars,
			@destruction_percentage
		)
		select scope_identity()
	end else begin
		update war_clans set
			war_id = isnull(@war_id, war_id),
			tag = isnull(@tag, tag),
			name = isnull(@name, name),
			badge_urls_small = isnull(@badge_urls_small, badge_urls_small),
			badge_urls_large = isnull(@badge_urls_large, badge_urls_large),
			badge_urls_medium = isnull(@badge_urls_medium, badge_urls_medium),
			clan_level = isnull(@clan_level, clan_level),
			attacks = isnull(@attacks, attacks),
			stars = isnull(@stars, stars),
			destruction_percentage = isnull(@destruction_percentage, destruction_percentage)
		where id = @id
		select @id
	end
end
go
create procedure usp_war_clan_members_upsert (
	@war_clan_id int = null,
	@tag nvarchar(16) = null,
	@name nvarchar(256) = null,
	@town_hall_level int = null,
	@map_position int = null,
	@opponent_attacks int = null,
	@best_opponent_attack_attacker_tag nvarchar(16) = null,
	@best_opponent_attack_defender_tag nvarchar(16) = null,
	@best_opponent_attack_stars int = null,
	@best_opponent_attack_destruction_percentage int = null,
	@best_opponent_attack_order int = null,
	@best_opponent_attack_duration int = null
) as begin
	declare @id int = null
	select @id = id from war_clan_members where war_clan_id = @war_clan_id and tag = @tag
	if @id is null begin
		insert into war_clan_members (
			war_clan_id,
			tag,
			name,
			town_hall_level,
			map_position,
			opponent_attacks,
			best_opponent_attack_attacker_tag,
			best_opponent_attack_defender_tag,
			best_opponent_attack_stars,
			best_opponent_attack_destruction_percentage,
			best_opponent_attack_order,
			best_opponent_attack_duration
		) values (
			@war_clan_id,
			@tag,
			@name,
			@town_hall_level,
			@map_position,
			@opponent_attacks,
			@best_opponent_attack_attacker_tag,
			@best_opponent_attack_defender_tag,
			@best_opponent_attack_stars,
			@best_opponent_attack_destruction_percentage,
			@best_opponent_attack_order,
			@best_opponent_attack_duration
		)
		select scope_identity()
	end else begin
		update war_clan_members set
			war_clan_id = isnull(@war_clan_id, war_clan_id),
			tag = isnull(@tag, tag),
			name = isnull(@name, name),
			town_hall_level = isnull(@town_hall_level, town_hall_level),
			map_position = isnull(@map_position, map_position),
			opponent_attacks = isnull(@opponent_attacks, opponent_attacks),
			best_opponent_attack_attacker_tag = isnull(@best_opponent_attack_attacker_tag, best_opponent_attack_attacker_tag),
			best_opponent_attack_defender_tag = isnull(@best_opponent_attack_defender_tag, best_opponent_attack_defender_tag),
			best_opponent_attack_stars = isnull(@best_opponent_attack_stars, best_opponent_attack_stars),
			best_opponent_attack_destruction_percentage = isnull(@best_opponent_attack_destruction_percentage, best_opponent_attack_destruction_percentage),
			best_opponent_attack_order = isnull(@best_opponent_attack_order, best_opponent_attack_order),
			best_opponent_attack_duration = isnull(@best_opponent_attack_duration, best_opponent_attack_duration)
		where id = @id
		select @id
	end
end
go
create procedure usp_war_attacks_upsert (
	@war_clan_member_id int = null,
	@attacker_tag nvarchar(16) = null,
	@defender_tag nvarchar(16) = null,
	@stars int = null,
	@destruction_percentage int = null,
	@order int = null,
	@duration int = null
) as begin
	declare @id int = null
	select @id = id from war_attacks where war_clan_member_id = @war_clan_member_id and defender_tag = @defender_tag
	if @id is null begin
		insert into war_attacks (
			war_clan_member_id,
			attacker_tag,
			defender_tag,
			stars,
			destruction_percentage,
			[order],
			duration
		) values (
			@war_clan_member_id,
			@attacker_tag,
			@defender_tag,
			@stars,
			@destruction_percentage,
			@order,
			@duration
		)
		select scope_identity()
	end else begin
		update war_attacks set
			war_clan_member_id = isnull(@war_clan_member_id, war_clan_member_id),
			attacker_tag = isnull(@attacker_tag, attacker_tag),
			defender_tag = isnull(@defender_tag, defender_tag),
			stars = isnull(@stars, stars),
			destruction_percentage = isnull(@destruction_percentage, destruction_percentage),
			[order] = isnull(@order, [order]),
			duration = isnull(@duration, duration)
		where id = @id
		select @id
	end
end
go
create procedure usp_war_state_get (
	@start_time datetime
) as begin
	select
		state
	from
		wars
	where
		start_time = @start_time
end
go
create procedure usp_clan_capital_districts_upsert (
	@clan_id int = null,
	@district_id int = null,
	@name nvarchar(32) null,
	@district_hall_level int null
) as begin
	declare @id int = null
	select @id = id from clan_capital_districts where clan_id = @clan_id and district_id = @district_id
	if @id is null begin
		insert into clan_capital_districts (
			clan_id,
			district_id,
			name,
			district_hall_level
		) values (
			@clan_id,
			@district_id,
			@name,
			@district_hall_level
		)
		select scope_identity()
	end else begin
		update clan_capital_districts set
			clan_id = isnull(@clan_id, clan_id),
			district_id = isnull(@district_id, district_id),
			name = isnull(@name, name),
			district_hall_level = isnull(@district_hall_level, district_hall_level)
		where id = @id
		select @id
	end
end
go
alter procedure usp_clans_upsert (
	@request_id int = null,
	@tag nvarchar(16) = null,
	@name nvarchar(256) = null,
	@description nvarchar(max) = null,
	@location_id int = null,
	@location_name nvarchar(256) = null,
	@location_is_country bit = null,
	@location_country_code nvarchar(8) = null,
	@badge_urls_small nvarchar(256) = null,
	@badge_urls_large nvarchar(256) = null,
	@badge_urls_medium nvarchar(256) = null,
	@clan_level int = null,
	@clan_points int = null,
	@clan_versus_points int = null,
	@required_trophies int = null,
	@war_frequency nvarchar(256) = null,
	@war_win_streak int = null,
	@war_wins int = null,
	@war_ties int = null,
	@war_losses int = null,
	@is_war_log_public bit = null,
	@war_league_id int = null,
	@war_league_name nvarchar(256) = null,
	@members int = null,
	@chat_language_id int = null,
	@chat_language_name nvarchar(256) = null,
	@chat_language_language_code nvarchar(8) = null,
	@required_versus_trophies int = null,
	@required_townhall_level int = null,
	@clan_capital_capital_hall_level int = null
) as begin
	declare @id int = null
	select @id = id from clans where request_id = @request_id and tag = @tag
	if @id is null begin
		insert into clans (
			request_id,
			tag,
			name,
			description,
			location_id,
			location_name,
			location_is_country,
			location_country_code,
			badge_urls_small,
			badge_urls_large,
			badge_urls_medium,
			clan_level,
			clan_points,
			clan_versus_points,
			required_trophies,
			war_frequency,
			war_win_streak,
			war_wins,
			war_ties,
			war_losses,
			is_war_log_public,
			war_league_id,
			war_league_name,
			members,
			chat_language_id,
			chat_language_name,
			chat_language_language_code,
			required_versus_trophies,
			required_townhall_level,
			clan_capital_capital_hall_level
		) values (
			@request_id,
			@tag,
			@name,
			@description,
			@location_id,
			@location_name,
			@location_is_country,
			@location_country_code,
			@badge_urls_small,
			@badge_urls_large,
			@badge_urls_medium,
			@clan_level,
			@clan_points,
			@clan_versus_points,
			@required_trophies,
			@war_frequency,
			@war_win_streak,
			@war_wins,
			@war_ties,
			@war_losses,
			@is_war_log_public,
			@war_league_id,
			@war_league_name,
			@members,
			@chat_language_id,
			@chat_language_name,
			@chat_language_language_code,
			@required_versus_trophies,
			@required_townhall_level,
			@clan_capital_capital_hall_level
		)
		select scope_identity()
	end else begin
		update clans set
			request_id = isnull(@request_id, request_id),
			tag = isnull(@tag, tag),
			name = isnull(@name, name),
			description = isnull(@description, description),
			location_id = isnull(@location_id, location_id),
			location_name = isnull(@location_name, location_name),
			location_is_country = isnull(@location_is_country, location_is_country),
			location_country_code = isnull(@location_country_code, location_country_code),
			badge_urls_small = isnull(@badge_urls_small, badge_urls_small),
			badge_urls_large = isnull(@badge_urls_large, badge_urls_large),
			badge_urls_medium = isnull(@badge_urls_medium, badge_urls_medium),
			clan_level = isnull(@clan_level, clan_level),
			clan_points = isnull(@clan_points, clan_points),
			clan_versus_points = isnull(@clan_versus_points, clan_versus_points),
			required_trophies = isnull(@required_trophies, required_trophies),
			war_frequency = isnull(@war_frequency, war_frequency),
			war_win_streak = isnull(@war_win_streak, war_win_streak),
			war_wins = isnull(@war_wins, war_wins),
			war_ties = isnull(@war_ties, war_ties),
			war_losses = isnull(@war_losses, war_losses),
			is_war_log_public = isnull(@is_war_log_public, is_war_log_public),
			war_league_id = isnull(@war_league_id, war_league_id),
			war_league_name = isnull(@war_league_name, war_league_name),
			members = isnull(@members, members),
			chat_language_id = isnull(@chat_language_id, chat_language_id),
			chat_language_name = isnull(@chat_language_name, chat_language_name),
			chat_language_language_code = isnull(@chat_language_language_code, chat_language_language_code),
			required_versus_trophies = isnull(@required_versus_trophies, required_versus_trophies),
			required_townhall_level = isnull(@required_townhall_level, required_townhall_level),
			clan_capital_capital_hall_level = isnull(@clan_capital_capital_hall_level, clan_capital_capital_hall_level)
		where id = @id
		select @id
	end
end