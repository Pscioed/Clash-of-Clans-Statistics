
const axios = require('axios');
const league_war_info_get = require('./league_war_info_get');

/**
 * Retrieves information from https://api.clashofclans.com/v1/clans/#clantag/currentwar/leaguegroup for the given clan_tag, stores the results in the database.
 * Additionally follows up with requests to https://api.clashofclans.com/v1/clanwarleagues/wars/#wartag for all wars in the monthly league and stores that data in the database.
 * @param {object} pool The sql connection pool
 * @param {object} headers Request api headers
 * @param {int} request_id The request id
 * @param {string} clan_tag The clan tag
 */
async function execute (pool, headers, request_id, clan_tag) {
	let league_group_response_data;
	try {
		const league_group_response = await axios({
			url: 'https://api.clashofclans.com/v1/clans/%23' + clan_tag.substring(1) + '/currentwar/leaguegroup',
			headers: headers
		});
		league_group_response_data = league_group_response.data;
	}
	catch {
		//404 when the clan is not currently in a league war
		return;
	}

	const league_group_state_result = await pool.request()
		.input('season', league_group_response_data.season)
		.execute('usp_league_group_state_get');

	if (league_group_state_result.recordset[0]?.state === 'ended') {
		return;
	}
	await insert_league_group(pool, headers, league_group_response_data, request_id);
}

/**
 * Inserts league group data into the database, then inserts data for child tables
 * @param {object} pool The sql connection pool
 * @param {object} headers Request api headers
 * @param {int} request_id The request id
 * @param {object} league_group The league group details to insert
 */
async function insert_league_group (pool, headers, league_group, request_id) {
	const league_group_result = await pool.request()
		.input('request_id', request_id)
		.input('state', league_group.state)
		.input('season', league_group.season)
		.execute('usp_league_groups_upsert');
	const league_group_id = league_group_result.recordset[0][''];

	const insert_league_group_clan_tasks = league_group.clans.map(async (clan) => await insert_league_group_clan(pool, clan, league_group_id))

	const insert_league_group_round_tasks = league_group.rounds.map(async (round) => await insert_league_group_round(pool, headers, round, league_group_id));

	await Promise.all(insert_league_group_clan_tasks.concat(insert_league_group_round_tasks));
}

/**
 * Inserts league group clan data into the database, then inserts members
 * @param {object} pool The sql connection pool
 * @param {object} clan The clan details to insert
 * @param {int} league_group_id The league group id
 */
async function insert_league_group_clan (pool, clan, league_group_id) {
	const league_group_clans_result = await pool.request()
		.input('league_group_id', league_group_id)
		.input('tag', clan.tag)
		.input('name', clan.name)
		.input('clan_level', clan.clanLevel)
		.input('badge_urls_small', clan.badgeUrls.small)
		.input('badge_urls_large', clan.badgeUrls.large)
		.input('badge_urls_medium', clan.badgeUrls.medium)
		.execute('usp_league_group_clans_upsert');
	const league_group_clan_id = league_group_clans_result.recordset[0][''];

	await Promise.all(clan.members.map(async (member) => await insert_league_group_clan_member(pool, member, league_group_clan_id)));
}

/**
 * Inserts league group clan member data into the database
 * @param {object} pool The sql connection pool
 * @param {object} member The member to insert
 * @param {int} league_group_clan_id The league group clan id
 */
async function insert_league_group_clan_member (pool, member, league_group_clan_id) {
	await pool.request()
		.input('league_group_clan_id', league_group_clan_id)
		.input('tag', member.tag)
		.input('name', member.name)
		.input('town_hall_level', member.townHallLevel)
		.execute('usp_league_group_clan_members_upsert');
}

/**
 * Inserts the league group round, followed by the league wars
 * @param {object} pool The sql connection pool
 * @param {object} headers Request api headers
 * @param {object} round The round to insert
 * @param {int} league_group_id The league group id
 */
async function insert_league_group_round (pool, headers, round, league_group_id) {
	const league_group_rounds_result = await pool.request()
		.input('league_group_id', league_group_id)
		.input('day_number', index)
		.execute('usp_league_group_rounds_upsert');
	const league_group_round_id = league_group_rounds_result.recordset[0][''];

	await Promise.all(round.warTags.map(async (war_tag) => await insert_league_war(pool, headers, war_tag, league_group_round_id)));
}

/**
 * Inserts the league war, followed by fetching the details for that war and inserting those
 * @param {object} pool The sql connection pool
 * @param {object} headers Request api headers
 * @param {string} war_tag The war tag
 * @param {int} league_group_round_id The league group round id
 */
async function insert_league_war (pool, headers, war_tag, league_group_round_id) {
	const league_wars_result = await pool.request()
		.input('league_group_round_id', league_group_round_id)
		.input('war_tag', war_tag)
		.execute('usp_league_wars_upsert');
	const league_war_id = league_wars_result.recordset[0][''];

	await league_war_info_get.execute(pool, headers, war_tag, league_war_id)
}

module.exports = {
	execute
};