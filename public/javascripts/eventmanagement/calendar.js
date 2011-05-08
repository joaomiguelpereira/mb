

function Calendar() {
	view = null;
	
}

Calendar.prototype.init = function(parentElement, options) {
	//start rendering the calendar
	if (options.view == 'week') {
		this.view = new WeekView(this);	
	}
}


