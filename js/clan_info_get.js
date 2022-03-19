
const axios = require('axios');
/**
 * Retrieves information from https://api.clashofclans.com/v1/clans/#clantag for the given clan_tag, and stores the result for the clan and the members in the database
 * @param {object} pool The sql connection pool
 * @param {object} headers Request api headers
 * @param {int} request_id The request id
 * @param {string} clan_tag The clan tag
 */
async function execute (pool, headers, request_id, clan_tag) {
	const clan_response = await axios({
		url: 'https://api.clashofclans.com/v1/clans/%23' + clan_tag.substring(1),
		headers: headers
	});
	const clan_response_data = clan_response.data;

	await insert_clan(pool, clan_response_data, request_id);
}

/**
 * Inserts clan data into the database, then inserts member data
 * @param {object} pool The sql connection pool
 * @param {object} clan The clan details to insert
 * @param {int} request_id The request id
 */
async function insert_clan (pool, clan, request_id) {
	const clan_result = await pool.request()
		.input('request_id', request_id)
		.input('tag', clan.tag)
		.input('name', clan.name)
		.input('description', clan.description)
		.input('location_id', clan.location.id)
		.input('location_name', clan.location.name)
		.input('location_is_country', clan.location.isCountry)
		.input('location_country_code', clan.location.countryCode)
		.input('badge_urls_small', clan.badgeUrls.small)
		.input('badge_urls_large', clan.badgeUrls.large)
		.input('badge_urls_medium', clan.badgeUrls.medium)
		.input('clan_level', clan.clanLevel)
		.input('clan_points', clan.clanPoints)
		.input('clan_versus_points', clan.clanVersusPoints)
		.input('required_trophies', clan.requiredTrophies)
		.input('war_frequency', clan.warFrequency)
		.input('war_win_streak', clan.warWinStreak)
		.input('war_wins', clan.warWins)
		.input('war_ties', clan.warTies)
		.input('war_losses', clan.warLosses)
		.input('is_war_log_public', clan.isWarLogPublic)
		.input('war_league_id', clan.warLeague.id)
		.input('war_league_name', clan.warLeague.name)
		.input('members', clan.members)
		.input('chat_language_id', clan.chatLanguage.id)
		.input('chat_language_name', clan.chatLanguage.name)
		.input('chat_language_language_code', clan.chatLanguage.languageCode)
		.input('required_versus_trophies', clan.requiredVersusTrophies)
		.input('required_townhall_level', clan.requiredTownhallLevel)
		.execute('usp_clans_upsert');
	const clan_id = clan_result.recordset[0][''];

	await Promise.all(clan.memberList.map(async (member) => await insert_member(pool, member, clan_id)));
}

/**
 * Inserts member data into the database
 * @param {object} pool The sql connection pool
 * @param {object} member The member details to insert
 * @param {int} clan_id The clan id
 */
async function insert_member (pool, member, clan_id) {
	await pool.request()
		.input('clan_id', clan_id)
		.input('tag', member.tag)
		.input('name', member.name)
		.input('role', member.role)
		.input('exp_level', member.expLevel)
		.input('league_id', member.league.id)
		.input('league_name', member.league.name)
		.input('league_icon_urls_small', member.league.iconUrls.small)
		.input('league_icon_urls_tiny', member.league.iconUrls.tiny)
		.input('trophies', member.trophies)
		.input('versus_trophies', member.versusTrophies)
		.input('clan_rank', member.clanRank)
		.input('previous_clan_rank', member.previousClanRank)
		.input('donations', member.donations)
		.input('donations_received', member.donationsReceived)
		.execute('usp_members_upsert');
}

module.exports = {
	execute
};