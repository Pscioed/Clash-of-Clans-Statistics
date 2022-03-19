


require('dotenv').config();
const sql = require('mssql');
const clan_info_get = require('./js/clan_info_get');
const league_group_info_get = require('./js/league_group_info_get');
const current_war_info_get = require('./js/current_war_info_get');
const headers = { Authorization: 'Bearer ' + process.env.API_KEY };

let pool;
(async () => {
	pool = await sql.connect(process.env.SQL_CONNECTION_STRING);
	const time = new Date();
	const request_result = await pool.request()
		.input('timestamp', sql.DateTime, time)
		.execute('usp_requests_upsert');
	const request_id = request_result.recordset[0][''];

	const clan_info_task = clan_info_get.execute(pool, headers, request_id, process.env.CLAN_TAG);
	const league_group_info_task = league_group_info_get.execute(pool, headers, request_id, process.env.CLAN_TAG);
	const current_war_info_task = current_war_info_get.execute(pool, headers, request_id, process.env.CLAN_TAG);

	await Promise.all([clan_info_task, league_group_info_task, current_war_info_task]);
	await pool.close();
})().catch(e => {
	console.error(e);
	pool.close();
});