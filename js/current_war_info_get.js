
const axios = require('axios');
const utils = require('./utils');

/**
 * Gets the current war info from https://api.clashofclans.com/v1/clans/#clantag/currentwar, and saves it in the database
 * @param {object} pool The sql connection pool
 * @param {object} headers Request api headers
 * @param {int} request_id The request id
 * @param {string} clan_tag The clan tag
 */
async function execute (pool, headers, request_id, clan_tag) {
	let current_war_response_data;
	try {
		const current_war_response = await axios({
			url: 'https://api.clashofclans.com/v1/clans/%23' + clan_tag.substring(1) + '/currentwar',
			headers: headers
		});
		current_war_response_data = current_war_response.data;
	}
	catch {
		//404 when the clan is not currently in a war
		return;
	}

	const war_state_result = await pool.request()
		.input('start_time', current_war_response_data.start_time)
		.execute('usp_war_state_get');

	if (war_state_result.recordset[0]?.state === 'warEnded') {
		return;
	}

	await insert_war(pool, current_war_response_data, request_id);
}

/**
 * Inserts the war details, then child table details
 * @param {object} pool The sql connection pool
 * @param {object} war The war details
 * @param {int} request_id The request id
 */
async function insert_war (pool, war, request_id) {
	const war_result = await pool.request()
		.input('request_id', request_id)
		.input('state', war.state)
		.input('team_size', war.teamSize)
		.input('attacks_per_member', war.attacksPerMember)
		.input('preparation_start_time', utils.get_date(war.preparationStartTime))
		.input('start_time', utils.get_date(war.startTime))
		.input('end_time', utils.get_date(war.endTime))
		.execute('usp_wars_upsert');
	const war_id = war_result.recordset[0][''];

	const insert_war_clan_task = insert_war_clan(pool, war.clan, war_id);
	const insert_war_opponent_task = insert_war_clan(pool, war.opponent, war_id);

	await Promise.all([insert_war_clan_task, insert_war_opponent_task]);
}

/**
 * Inserts the war clan details, then child table details
 * @param {object} pool The sql connection pool
 * @param {object} war_clan The war clan details
 * @param {int} war_id The war id
 */
async function insert_war_clan (pool, war_clan, war_id) {
	const war_clans_result = await pool.request()
		.input('war_id', war_id)
		.input('tag', war_clan.tag)
		.input('name', war_clan.name)
		.input('badge_urls_small', war_clan.badgeUrls.small)
		.input('badge_urls_large', war_clan.badgeUrls.large)
		.input('badge_urls_medium', war_clan.badgeUrls.medium)
		.input('clan_level', war_clan.clanLevel)
		.input('attacks', war_clan.attacks)
		.input('stars', war_clan.stars)
		.input('destruction_percentage', war_clan.destructionPercentage)
		.execute('usp_war_clans_upsert');
	const war_clan_id = war_clans_result.recordset[0][''];

	await Promise.all(war_clan.members.map(async (member) => await insert_war_clan_member(pool, member, war_clan_id)));
}

/**
 * Inserts the member details, followed by attack details
 * @param {object} pool The sql connection pool
 * @param {object} member The member details
 * @param {int} war_clan_id The war clan id
 */
async function insert_war_clan_member (pool, member, war_clan_id) {
	const war_clan_members_result = await pool.request()
		.input('war_clan_id', war_clan_id)
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
		.execute('usp_war_clan_members_upsert');
	const war_clan_member_id = war_clan_members_result.recordset[0][''];

	if (member.attacks) {
		await Promise.all(member.attacks.map(async (attack) => await insert_war_attack(pool, attack, war_clan_member_id)));
	}
}

/**
 * Inserts the attack details
 * @param {object} pool The sql connection pool
 * @param {object} attack The attack details
 * @param {int} war_clan_member_id The war clan member id
 */
async function insert_war_attack (pool, attack, war_clan_member_id) {
	await pool.request()
		.input('war_clan_member_id', war_clan_member_id)
		.input('attacker_tag', attack.attackerTag)
		.input('defender_tag', attack.defenderTag)
		.input('stars', attack.stars)
		.input('destruction_percentage', attack.destructionPercentage)
		.input('order', attack.order)
		.input('duration', attack.duration)
		.execute('usp_war_attacks_upsert');
}

module.exports = {
	execute
};