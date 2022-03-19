
const axios = require('axios');
const utils = require('./utils');

/**
 * Gets the league war info from https://api.clashofclans.com/v1/clanwarleagues/wars/#wartag, and saves it in the database
 * @param {object} pool The sql connection pool
 * @param {object} headers Request api headers
 * @param {string} war_tag The war tag
 * @param {int} league_war_id The league war id
 */
async function execute (pool, headers, war_tag, league_war_id) {
	const league_war_state_result = await pool.request()
		.input('war_tag', war_tag)
		.execute('usp_league_war_state_get');

	if (league_war_state_result.recordset[0]?.state === 'warEnded') {
		return;
	}
	const response = await axios({
		url: 'https://api.clashofclans.com/v1/clanwarleagues/wars/%23' + war_tag.substring(1),
		headers: headers
	});
	const league_war_response = response.data;

	const insert_league_war_task = insert_league_war_details(pool, league_war_response, league_war_id);
	const insert_league_war_clan_task = insert_league_war_clan(pool, league_war_response.clan, league_war_id);
	const insert_league_war_opponent_task = insert_league_war_clan(pool, league_war_response.opponent, league_war_id);

	await Promise.all([insert_league_war_task, insert_league_war_clan_task, insert_league_war_opponent_task]);
}

/**
 * Inserts league war details
 * @param {object} pool The sql connection pool
 * @param {object} league_war_details The league war details
 * @param {int} league_war_id The league war id
 */
async function insert_league_war_details (pool, league_war_details, league_war_id) {
	await pool.request()
		.input('league_war_id', league_war_id)
		.input('state', league_war_details.state)
		.input('team_size', league_war_details.teamSize)
		.input('preparation_start_time', utils.get_date(league_war_details.preparationStartTime))
		.input('start_time', utils.get_date(league_war_details.startTime))
		.input('end_time', utils.get_date(league_war_details.endTime))
		.input('war_start_time', utils.get_date(league_war_details.warStartTime))
		.execute('usp_league_war_details_upsert');
}

/**
 * Inserts league war clan data, and associated member data
 * @param {object} pool The sql connection pool
 * @param {object} league_war_clan The league war clan details
 * @param {int} league_war_id The league war id
 */
async function insert_league_war_clan (pool, league_war_clan, league_war_id) {
	const league_war_clans_result = await pool.request()
		.input('league_war_id', league_war_id)
		.input('tag', league_war_clan.tag)
		.input('name', league_war_clan.name)
		.input('badge_urls_small', league_war_clan.badgeUrls.small)
		.input('badge_urls_large', league_war_clan.badgeUrls.large)
		.input('badge_urls_medium', league_war_clan.badgeUrls.medium)
		.input('clan_level', league_war_clan.clanLevel)
		.input('attacks', league_war_clan.attacks)
		.input('stars', league_war_clan.stars)
		.input('destruction_percentage', league_war_clan.destructionPercentage)
		.execute('usp_league_war_clans_upsert');
	const league_war_clan_id = league_war_clans_result.recordset[0][''];

	await Promise.all(league_war_clan.members.map(async (member) => await insert_league_war_clan_member(pool, member, league_war_clan_id)));
}

/**
 * Inserts league war member data
 * @param {object} pool The sql connection pool
 * @param {object} member The member details
 * @param {int} league_war_clan_id The league war clan id
 */
async function insert_league_war_clan_member (pool, member, league_war_clan_id) {
	await pool.request()
		.input('league_war_clan_id', league_war_clan_id)
		.input('tag', member.tag)
		.input('name', member.name)
		.input('town_hall_level', member.townhallLevel)
		.input('map_position', member.mapPosition)
		.input('opponent_attacks', member.opponentAttacks)
		.input('best_opponent_attack_attacker_tag', member.bestOpponentAttack?.attackerTag)
		.input('best_opponent_attack_defender_tag', member.bestOpponentAttack?.defenderTag)
		.input('best_opponent_attack_stars', member.bestOpponentAttack?.stars)
		.input('best_opponent_attack_destruction_percentage', member.bestOpponentAttack?.destructionPercentage)
		.input('best_opponent_attack_order', member.bestOpponentAttack?.order)
		.input('best_opponent_attack_duration', member.bestOpponentAttack?.duration)
		.input('attack_attacker_tag', member.attacks ? member.attacks[0].attackerTag : null)
		.input('attack_defender_tag', member.attacks ? member.attacks[0].defenderTag : null)
		.input('attack_stars', member.attacks ? member.attacks[0].stars : null)
		.input('attack_destruction_percentage', member.attacks ? member.attacks[0].destructionPercentage : null)
		.input('attack_order', member.attacks ? member.attacks[0].order : null)
		.input('attack_duration', member.attacks ? member.attacks[0].duration : null)
		.execute('usp_league_war_clan_members_upsert');
}

module.exports = {
	execute
};