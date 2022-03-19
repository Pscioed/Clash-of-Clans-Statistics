
/**
 * Gets a date object from a string such as this: '20220302T023733.000Z'
 * This is the clash of clans api date format, and is an invalid date format for the javascript date parser
 * @param {string} date_string The date string from the clash of clans api
 * @returns The parsed date
 */
 function get_date(date_string) {
	const string_parts = [
		date_string.substring(0, 4),//YYYY
		'-',
		date_string.substring(4, 6),//MM
		'-',
		date_string.substring(6, 11),//DDTHH
		':',
		date_string.substring(11, 13),//mm
		':',
		date_string.substring(13)//ss.uuu
	];
	const date_string_fixed = string_parts.join('');
	return new Date(date_string_fixed);
}

module.exports = {
	get_date
};