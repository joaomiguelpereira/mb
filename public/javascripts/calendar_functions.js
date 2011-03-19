/**
 * This function is expected to run after the dom is loaded and is reading the defined config sent from the server
 * @param {Object} minutes
 */
$(function(){
    calendarConfig.dateDayNamesShort = dateDayNamesShort;
    calendarConfig.dateDayNames = dateDayNames;
    calendarConfig.dateMonthNames = dateMonthNames;
    calendarConfig.dateMonthNamesShort = dateMonthNamesShort;
});



var dateFormate = {
    short: {
        format: 'd-M-yy',
        parser: function(originalDate){
            var array = originalDate.split("-");
            var month = 0;
            
            for (var i = 0; i < calendarConfig.dateMonthNamesShort.length; i++) {
                if (calendarConfig.dateMonthNamesShort[i] == array[1]) {
                    month = i + 1;
                    break;
                }
            }
            return new CalendarDate(array[0], month, array[2]);
            
        }
    }
};
function CalendarDate(day, month, year){
    this.day = day;
    this.month = month;
    this.year = year;
};
CalendarDate.prototype.isInFuture = function(otherDate) {

	if (( this.year > otherDate.year) || (this.year == otherDate.year && this.month>otherDate.month) || (this.year == otherDate.year && this.month==otherDate.month && (this.day>otherDate.day || this.day==otherDate.day))) {
		return true;
	}
	return false;
};
var calendarConfig = {
 
    dateFormat: dateFormate.short,
    dateDayNamesShort: null,
    dateDayNames: null,
    dateMonthNames: null,
    dateMonthNamesShort: null
}

var CalendarUtils = {

    formatHour: function(minutes){
        var hours = Math.floor(minutes / 60);
        var minutes = minutes % 60;
        
        if (hours <= 9) {
            hours = "0" + hours
        }
        
        if (minutes <= 9) {
            minutes = "0" + minutes
        }
        
        return hours + ":" + minutes;
    }
}
