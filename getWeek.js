/* A function to calculate the current accounting week number */

function getWeek() {
	// How many milliseconds in a day
	var one_day=1000*60*60*24

	// Today's Date
	var today = new Date()

	// Find the first day of the current academic year.
	// The accounting year start on the first Monday of August.

	// If it's not August yet, we must be in the year starting
	// last August.
	var year = today.getFullYear()

	if ( today.getMonth() < 7 ) {
		--year
	}

	// Now find the first Monday of August
	var day
	var first
	for (day = 1; day < 8; ++day) {
		first = new Date(year, 7, day);
		if ( first.getDay() == 1 ) {
			break
		}
	}

	// Number of days from the start of the year
	var diff = Math.ceil((today - first) / one_day)

	// Convert Days into weeks
	var week = Math.ceil(diff / 7)

	// That's your lot
	return week;
}
