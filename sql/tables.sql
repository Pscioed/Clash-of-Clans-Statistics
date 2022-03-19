create table requests (
	id int identity(1, 1) primary key,
	timestamp datetime not null
)
create table clans (
	id int identity(1, 1) primary key,
	request_id int not null foreign key references requests(id),
	tag nvarchar(16) not null,
	name nvarchar(256) not null,
	description nvarchar(max) not null,
	location_id int not null,
	location_name nvarchar(256) not null,
	location_is_country bit not null,
	location_country_code nvarchar(8) not null,
	badge_urls_small nvarchar(256) not null,
	badge_urls_large nvarchar(256) not null,
	badge_urls_medium nvarchar(256) not null,
	clan_level int not null,
	clan_points int not null,
	clan_versus_points int not null,
	required_trophies int not null,
	war_frequency nvarchar(256) not null,
	war_win_streak int not null,
	war_wins int not null,
	war_ties int not null,
	war_losses int not null,
	is_war_log_public bit not null,
	war_league_id int not null,
	war_league_name nvarchar(256) not null,
	members int not null,
	chat_language_id int not null,
	chat_language_name nvarchar(256) not null,
	chat_language_language_code nvarchar(8) not null,
	required_versus_trophies int not null,
	required_townhall_level int not null
)
create table members (
	id int identity(1, 1) primary key,
	clan_id int not null foreign key references clans(id),
	tag nvarchar(16) not null,
	name nvarchar(256) not null,
	role nvarchar(16) not null,
	exp_level int not null,
	league_id int not null,
	league_name nvarchar(16) not null,
	league_icon_urls_small nvarchar(256) not null,
	league_icon_urls_tiny nvarchar(256) not null,
	trophies int not null,
	versus_trophies int not null,
	clan_rank int not null,
	previous_clan_rank int not null,
	donations int not null,
	donations_received int not null
)
create table league_groups (
	id int identity(1, 1) primary key,
	request_id int not null foreign key references requests(id),
	state nvarchar(16) not null,
	season nvarchar(16) not null
)
create table league_group_clans (
	id int identity(1, 1) primary key,
	league_group_id int not null foreign key references league_groups(id),
	tag nvarchar(16) not null,
	name nvarchar(256) not null,
	clan_level int not null,
	badge_urls_small nvarchar(256) not null,
	badge_urls_large nvarchar(256) not null,
	badge_urls_medium nvarchar(256) not null
)
create table league_group_clan_members (
	id int identity(1, 1) primary key,
	league_group_clan_id int not null foreign key references league_group_clans(id),
	tag nvarchar(16) not null,
	name nvarchar(256) not null,
	town_hall_level int not null
)
create table league_group_rounds (
	id int identity(1, 1) primary key,
	league_group_id int not null foreign key references league_groups(id),
	day_number int not null
)
create table league_wars (
	id int identity(1, 1) primary key,
	league_group_round_id int not null foreign key references league_group_rounds(id),
	war_tag nvarchar(16) not null
)
create table league_war_details (
	id int identity(1, 1) primary key,
	league_war_id int not null foreign key references league_wars(id),
	state nvarchar(16) not null,
	team_size int not null,
	preparation_start_time datetime not null,
	start_time datetime not null,
	end_time datetime not null,
	war_start_time datetime not null
)
create table league_war_clans (
	id int identity(1, 1) primary key,
	league_war_id int not null foreign key references league_wars(id),
	tag nvarchar(16) not null,
	name nvarchar(256) not null,
	badge_urls_small nvarchar(256) not null,
	badge_urls_large nvarchar(256) not null,
	badge_urls_medium nvarchar(256) not null,
	clan_level int not null,
	attacks int not null,
	stars int not null,
	destruction_percentage float not null
)
create table league_war_clan_members (
	id int identity(1, 1) primary key,
	league_war_clan_id int not null foreign key references league_war_clans(id),
	tag nvarchar(16) not null,
	name nvarchar(256) not null,
	town_hall_level int not null,
	map_position int not null,
	opponent_attacks int not null,
	best_opponent_attack_attacker_tag nvarchar(16) null,
	best_opponent_attack_defender_tag nvarchar(16) null,
	best_opponent_attack_stars int null,
	best_opponent_attack_destruction_percentage int null,
	best_opponent_attack_order int null,
	best_opponent_attack_duration int null,
	attack_attacker_tag nvarchar(16) null,
	attack_defender_tag nvarchar(16) null,
	attack_stars int null,
	attack_destruction_percentage int null,
	attack_order int null,
	attack_duration int null
)
create table wars (
	id int identity(1, 1) primary key,
	request_id int not null foreign key references requests(id),
	state nvarchar(16) not null,
	team_size int not null,
	attacks_per_member int not null,
	preparation_start_time datetime not null,
	start_time datetime not null,
	end_time datetime not null
)
create table war_clans (
	id int identity(1, 1) primary key,
	war_id int not null foreign key references wars(id),
	tag nvarchar(16) not null,
	name nvarchar(256) not null,
	badge_urls_small nvarchar(256) not null,
	badge_urls_large nvarchar(256) not null,
	badge_urls_medium nvarchar(256) not null,
	clan_level int not null,
	attacks int not null,
	stars int not null,
	destruction_percentage float not null
)
create table war_clan_members (
	id int identity(1, 1) primary key,
	war_clan_id int not null foreign key references war_clans(id),
	tag nvarchar(16) not null,
	name nvarchar(256) not null,
	town_hall_level int not null,
	map_position int not null,
	opponent_attacks int not null,
	best_opponent_attack_attacker_tag nvarchar(16) null,
	best_opponent_attack_defender_tag nvarchar(16) null,
	best_opponent_attack_stars int null,
	best_opponent_attack_destruction_percentage int null,
	best_opponent_attack_order int null,
	best_opponent_attack_duration int null
)
create table war_attacks (
	id int identity(1, 1) primary key,
	war_clan_member_id int not null foreign key references war_clan_members(id),
	attacker_tag nvarchar(16) not null,
	defender_tag nvarchar(16) not null,
	stars int not null,
	destruction_percentage int not null,
	[order] int not null,
	duration int not null
)