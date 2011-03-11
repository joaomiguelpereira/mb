
/**
 * @author jpereira
 */
//var week_days = ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"];

var start_hour = 0;
var end_hour = 24;
var definingEvent = null;
var resizeIncrementY = 19;
var moveIncrementX = 100;
var minutesIncrement = 30;
var hourMinutes = 60;
var eventManager = null;
var mouseDownOnEvent = false;
var bodyElementId = "__body__el__id";
var browser = $.browser;
var startScrollPosition = (hourMinutes / minutesIncrement) * resizeIncrementY * 8;
var dev = false;
resizeIncrementY = browser.mozilla ? 19 : 20;
$(function(){


    if (typeof initialData === 'undefined' || typeof availabilityUpdateUrl === 'undefined') {
        alert("Missing initial data or updateUrl")
        throw "Error: missing initial data or updateUrl";   
    }
    else {
    	eventManager = new EventManager();
        eventManager.createCalendar($("#ccontainer"));
        eventManager.loadFromJson(initialData);
    }
	$("#config_exceptions_bt").bind("click", function() {
		
		$("#exceptions_container").toggle();
		$("#exceptions_container").trigger("initializeExceptions");
		if ($("#exceptions_container").is(":visible") ){
			$("#config_exceptions_bt").html("Ocultar excepções");	
		} else {
			$("#config_exceptions_bt").html("Mostrar excepções");	
		}
		
		
		return false;
	});
	
	
	
	    
	
    if (dev) {
        $("#dump_events").bind("click", function(){
            eventManager.dump();
            return false;
        });
        $("#hide_dump").bind("click", function(){
            if ($("#dumper_zone")) {
                $("#dumper_zone").toggle();
            }
            
            return false;
        });
        
    }
    
    
});
/****************************************************
 * EventsManager Object
 */
function EventManager(){
    this.parentElement = null;
    this.weekCalendar = null;
    this.events = new Array();
    for (var i = 0; i < dateDayNames.length; i++) {
        this.events[i] = new Array();
    }
    
}

EventManager.prototype.createCalendar = function(element){
    this.parentElement = element;
    this.weekCalendar = new WeekCalendar(element);
}

EventManager.prototype.loadFromJson = function(json){
    Logger.log("loading from json: " + json);
    var array = JSON.parse(json);
    for (var i = 0; i < array.length; i++) {
        dayArray = array[i];
        for (var j = 0; j < dayArray.length; j++) {
        
            var ev = new CalendarEvent().loadFromRawObject(dayArray[j]);
            Logger.log("loading event: " + ev);
            ev.renderInCalendar();
            this.events[ev.weekDay].push(ev);
            
            
        }
    }
    
    
}
EventManager.prototype.toJson = function(){

    var jsonArray = new Array();
    for (var i = 0; i < dateDayNames.length; i++) {
    
        jsonArray[i] = new Array();
        
        for (var j = 0; j < this.events[i].length; j++) {
            var eventObj = this.events[i][j].toRawObject();
            
            jsonArray[i].push(eventObj);
        }
    }
    
    return JSON.stringify(jsonArray);
    
}
EventManager.prototype.dump = function(){
    if ($("#dumper_zone")) {
        var html = "";
        for (var i = 0; i < dateDayNames.length; i++) {
            day_array = this.events[i];
            html += "<div><strong>Day " + i + "</strong></div>";
            for (var j = 0; j < day_array.length; j++) {
                html += "<div>Event: " + day_array[j] + "</div>";
            }
        }
        html += "<div>JSON: " + this.toJson() + "</div>"
        $("#dumper_zone").html(html);
    }
}


EventManager.prototype.updateServer = function(event){
    //this.weekCalendar.calendarBody.disable();
    loading_indicator.show();
    var instanceVar = this;
    $.ajax({
        type: 'PUT',
        url: availabilityUpdateUrl,
        data: "json_data=" + this.toJson(),
        success: function(data){
            //alert(data);
            loading_indicator.hide();
            instanceVar.weekCalendar.calendarBody.enable();
            
        }
        
    });
}

EventManager.prototype.add = function(event){
    var array = this.events[event.weekDay];
    array.push(event);
}

EventManager.prototype.moveDay = function(event, originalDay){
    var array = this.events[originalDay];
    array.splice(this.events.indexOf(event));
    this.add(event);
}

EventManager.prototype.remove = function(event){

    array = this.events[event.weekDay];
    array.splice(this.events.indexOf(event));
    event.remove();
    eventManager.updateServer();
}


EventManager.prototype.canMove = function(event){
    //Check end hour if is beyond time
    
    if (event.endHour > end_hour * hourMinutes || event.endHour < minutesIncrement || event.startHour < 0) {
        return false;
    }
    
    //Check if it colides with any existing event in the calendar
    for (var i = 0; i < this.events[event.weekDay].length; i++) {
        existEvent = this.events[event.weekDay][i];
        Logger.log("can move... " + existEvent);
        if (existEvent != event) {
            Logger.log("can move eh1: " + event.endHour + " -> sh2: " + existEvent.startHour);
            if (event.endHour > existEvent.startHour && event.startHour < existEvent.endHour) {
                return false;
            }
        }
    }
    
    return true;
    
}

EventManager.prototype.canResize = function(event, tolerance){


    if (!tolerance) {
        tolerance = 0;
    }
    
    
    //find any event for this day wich startHour equal endHour of even
    for (var i = 0; i < this.events[event.weekDay].length; i++) {
        existEvent = this.events[event.weekDay][i];
        if (existEvent != event) {
            // Logger.log("verifying existing event Start Hour " + existEvent.startHour + " with wannabe " + event.endHour);
            if (existEvent.startHour > event.startHour && event.endHour + tolerance > existEvent.startHour) {
                return false;
            }
        }
        if (event.endHour > end_hour * hourMinutes) {
            return false;
        }
        
    }
    return true;
    
    
}



/*********************************************************
 * WeekCalendar Object
 * @param {Object} parent
 *********************************************************/
function WeekCalendar(parent){

    this.container = createElement("div");
    this.calendarHeader = new WeekCalendarHeader();
    this.calendarBody = new WeekCalendarBody();
    this.container.append(this.calendarHeader.element());
    this.container.append(this.calendarBody.element());
    parent.append(this.container);
    $(this.calendarBody.element()).scrollTo(startScrollPosition, {
        axis: 'y'
    });
    
    
    
}


/********************************************************
 * WeeKCalendarHeader
 ********************************************************/
function WeekCalendarHeader(){
    this.container = null;
    this.table = null;
}

WeekCalendarHeader.prototype.element = function(){
    if (this.container == null) {
        this.container = createElement("div").addClass("calendar_header");
        
        //Create table to the header
        this.table = createElement("table").attr("border", "0px").attr("cellspacing", "0px").addClass("calendar_table");
        theader = createElement("thead");
        trow = createElement("tr");
        //Render week days
        for (i = 0; i < dateDayNames.length; i++) {
            el = createElement("td").html(dateDayNames[i]);
            if (i == 0) {
                el.css("border-left", "solid 1px #ccc");
            }
            trow.append(el);
        }
        theader.append(trow);
        this.table.append(theader);
        this.container.append(this.table)
    }
    return this.container;
}

/*******************************************************************
 * CalendarBody
 ******************************************************************/
function WeekCalendarBody(){
    this.container = null;
    this.table = null;
    this.container_wrapper = null;
}

WeekCalendarBody.prototype.disable = function(){
    this.table.css("opacity", "0.5");
    
}

WeekCalendarBody.prototype.enable = function(){
    this.table.css("opacity", "1");
    
}


WeekCalendarBody.prototype.element = function(){
    if (this.container_wrapper == null) {
    
    
        this.container_wrapper = createElement("div").addClass("calendar_body_wrapper").attr("id", bodyElementId);
        
        
        this.container = createElement("div").addClass("calendar_body");
        
        this.table = createElement("table").attr("border", "0px").attr("cellspacing", "0px").addClass("calendar_table");
        
        
        var trNumber = hourMinutes / minutesIncrement;
        
        var trElements = new Array();
        
        for (i = start_hour; i < end_hour; i++) {
        
        
        
            for (var trCount = 0; trCount < trNumber; trCount++) {
                trElements[trCount] = createElement("tr");
            }
            
            hour_cell = createElement("td").attr("rowspan", trNumber).html(CalendarUtils.formatHour(i * hourMinutes)).addClass("calendar_body_hour");
            
            trElements[0].append(hour_cell);
            
            for (var j = 0; j < dateDayNames.length; j++) {
            
                for (var slotCount = 0; slotCount < trNumber; slotCount++) {
                    aSlot = new CalendarSlot(j, ((i * hourMinutes) + minutesIncrement * slotCount));
                    aSlot.element().addClass("calendar_slot");
                    if (slotCount < trNumber - 1) {
                        aSlot.element().addClass("first_hour_half");
                    }
                    trElements[slotCount].append(aSlot.element());
                }
            }
            for (var k = 0; k < trElements.length; k++) {
                this.table.append(trElements[k]);
            }
        }
        this.container.append(this.table);
        this.container_wrapper.append(this.container);
        this.table.bind("mousemove", function(event){
            if (definingEvent != null) {
                definingEvent.ajust(event);
            }
        });
        this.table.bind("mouseup", function(event){
            if (definingEvent != null) {
                definingEvent.create(event);
            }
        });
    }
    return this.container_wrapper;
    
}


/***************************************************************
 * Calendar Slot
 ***************************************************************/
function CalendarSlot(weekDay, hour){
    this.slotElement = null;
    this.weekDay = weekDay;
    this.hour = hour;
}

CalendarSlot.prototype.startSelecting = function(){


    if (definingEvent == null && mouseDownOnEvent == false) {
        //Check if you clicked in any existing event....
        definingEvent = new CalendarEvent(this.hour, this.weekDay);
        this.slotElement.append(definingEvent.element());
    }
    
    
}

CalendarSlot.prototype.element = function(){
    var thisVar = this;
    if (this.slotElement == null) {
        this.slotElement = createElement("td");
        this.slotElement.css("z-index", "-9999");
        this.slotElement.bind('mousedown', function(){
            thisVar.startSelecting();
        });
        
        
    }
    return this.slotElement;
}


/************************************************************************
 * Calendar Event
 * @param {Object} startHour
 * @param {Object} weekDay
 ************************************************************************/
function CalendarEvent(startHour, weekDay){
    this.eventElement = null;
    this.startHour = startHour;
    this.weekDay = weekDay;
    this.endHour = startHour + minutesIncrement;
    this.infoEl = null;
    this.startSlot = null;
    this.initialized = false;
    this.lastMouseYPosition = -1;
}


CalendarEvent.prototype.renderInCalendar = function(){
    //find the day in the table
    targetTable = eventManager.weekCalendar.calendarBody.table;
    
    var trIndex = (this.startHour / minutesIncrement);
    
    var tdIndex = this.weekDay + 1;
    //if starting if half hour, ajust trIndex
    if (this.startHour % hourMinutes != 0) {
        tdIndex -= 1;
    }
    
    var trElement = targetTable.find("tr:eq(" + trIndex + ")");
    var tdElement = trElement.find("td:eq(" + tdIndex + ")");
    
    var element = this.element();
    
    tdElement.append(element);
    //ajust size
    this.initialize();
    var newSize = ((this.endHour - this.startHour) / minutesIncrement) * resizeIncrementY;
    
    
    element.animate({
        height: newSize + "px"
    }, 500);
    
    
    
}

CalendarEvent.prototype.loadFromRawObject = function(rawObject){
    this.weekDay = rawObject.weekDay;
    this.startHour = rawObject.startHour;
    this.endHour = rawObject.endHour;
    return this;
    
}

CalendarEvent.prototype.initialize = function(){
    if (this.initialized == false) {
        position = this.eventElement.position();
        this.eventElement.css("position", "absolute");
        this.eventElement.css("top", (position.top) + "px");
        this.initialized = true;
    }
}
CalendarEvent.prototype.update = function(){
    this.infoEl.html(CalendarUtils.formatHour(this.startHour) + " - " + CalendarUtils.formatHour(this.endHour));
}
CalendarEvent.prototype.ajust = function(event){
    if (definingEvent != null) {
        this.initialize();
        if (this.lastMouseYPosition == -1) {
            this.lastMouseYPosition = event.pageY;
        }
        var diff = event.pageY - this.lastMouseYPosition;
        
        if (diff > resizeIncrementY && eventManager.canResize(this, resizeIncrementY)) {
            this.endHour += minutesIncrement;
            this.lastMouseYPosition = event.pageY;
            this.element().height((this.element().height() + resizeIncrementY) + "px");
        }
        else 
            if (diff < -resizeIncrementY) {
                this.endHour -= minutesIncrement;
                this.lastMouseYPosition = event.pageY;
                this.element().height((this.element().height() - resizeIncrementY) + "px");
            }
        
        this.update();
    }
    
}


CalendarEvent.prototype.create = function(event){
    if (definingEvent != null) {
        eventManager.add(definingEvent);
        eventManager.updateServer();
        mouseDownOnEvent = false;
        definingEvent = null;
    }
}



CalendarEvent.prototype.toRawObject = function(){
    var json = {
        startHour: this.startHour,
        endHour: this.endHour,
        weekDay: this.weekDay
    };
    return json;
    
    
}




CalendarEvent.prototype.toJson = function(){

    return JSON.stringify(this.toRawObject());
}

CalendarEvent.prototype.toString = function(){


    return this.startHour + "-" + this.endHour + "@" + this.weekDay + "(" + CalendarUtils.formatHour(this.startHour) + " - " + CalendarUtils.formatHour(this.endHour) + "@" + this.weekDay + ")";
}


var resizingEventHeight = -1;
var draggingEvent = null;
var originalDraggingElementPos = null;
var originalDraggingEventHours = null;
var originalDraggingEventWeekDay = null;
var lastUsedDraggingElementPosForUpdate = null;
var originalResizingHeigh = null;
var originalResizingEndHour = null;



CalendarEvent.prototype.remove = function(){
    this.eventElement.remove();
    
}

CalendarEvent.prototype.element = function(){
    var instanceVar = this;
    if (this.eventElement == null) {
        this.eventElement = createElement("div").addClass("calendar_event");
        
        var infoHeaderWrapper = createElement("div").addClass("calendar_event_info");
        
        this.infoEl = createElement("div").html(CalendarUtils.formatHour(this.startHour) + " - " + CalendarUtils.formatHour(this.endHour));
        
        var removeBtWrapper = createElement("div").addClass("calendar_event_remove").html("x").attr("title", "Remover");
        removeBtWrapper.bind("click", function(){
            eventManager.remove(instanceVar);
            
        });
        
        infoHeaderWrapper.append(removeBtWrapper);
        infoHeaderWrapper.append(this.infoEl);
        this.eventElement.append(infoHeaderWrapper);
        
        this.eventElement.css("z-index", "9999");
        var thisVar = this;
        this.eventElement.bind("mousedown", function(){
        
            mouseDownOnEvent = true;
        });
        
        this.eventElement.bind("mouseup", function(){
        
            mouseDownOnEvent = false;
        });
        
        var instanceVar = this;
        this.eventElement.resizable({
            grid: resizeIncrementY,
            maxWidth: moveIncrementX,
            minWidth: moveIncrementX,
            start: function(event, ui){
                originalResizingHeigh = instanceVar.element().height();
                originalResizingEndHour = instanceVar.endHour;
                //save current end hour
                //Save current height
            },
            stop: function(event, ui){
            
                //Ajust any done update
                var cHeight = instanceVar.element().height();
                var yDiff = originalResizingHeigh - cHeight;
                instanceVar.endHour = originalResizingEndHour + (yDiff < 1 ? 1 : -1) * minutesIncrement * Math.abs(yDiff / resizeIncrementY);
                instanceVar.update();
                
                if (!eventManager.canResize(instanceVar)) {
                    instanceVar.element().height(originalResizingHeigh);
                    instanceVar.endHour = originalResizingEndHour;
                    instanceVar.update();
                    
                }
                else {
                    eventManager.updateServer();
                }
                
                originalResizingHeigh = null;
                originalResizingEndHour = null;
                resizingEventHeight = -1;
                mouseDownOnEvent = false;
                redefiningEvent = null;
                
            },
            resize: function(event, ui){
                if (resizingEventHeight == -1) {
                    resizingEventHeight = instanceVar.element().height();
                }
                var diff = instanceVar.element().height() - resizingEventHeight;
                if (diff >= resizeIncrementY || diff <= -resizeIncrementY) {
                
                    resizingEventHeight = instanceVar.element().height();
                    
                    instanceVar.endHour += minutesIncrement * (diff < 0 ? -1 : 1);
                    instanceVar.update();
                    
                }
                
            }
        }).draggable({
        
            containment: [102, 1, 800, 650],
            //handle: ".calendar_event_info",
            opacity: 0.7,
            //revert: "invalid",
            //helper: "clone",
            grid: [moveIncrementX + 1, resizeIncrementY],
            snap: ".draggable_area",
            start: function(event, ui){
            
            },
            drag: function(event, ui){
                //Calculate new start and endHour
                var oTop = originalDraggingElementPos[0];
                var oLeft = originalDraggingElementPos[1];
                cTop = instanceVar.element().position().top;
                cLeft = instanceVar.element().position().left;
                if (lastUsedDraggingElementPosForUpdate == null) {
                    lastUsedDraggingElementPosForUpdate = new Array();
                    lastUsedDraggingElementPosForUpdate[0] = oTop;
                    lastUsedDraggingElementPosForUpdate[1] = oLeft;
                }
                yDiff = lastUsedDraggingElementPosForUpdate[0] - cTop;
                
                
                
                
                if ((yDiff <= -resizeIncrementY || yDiff >= resizeIncrementY) && lastUsedDraggingElementPosForUpdate[0] != cTop) {
                    lastUsedDraggingElementPosForUpdate[0] = cTop;
                    
                    instanceVar.endHour += (yDiff < 1 ? 1 : -1) * minutesIncrement;
                    instanceVar.startHour += (yDiff < 1 ? 1 : -1) * minutesIncrement;
                    instanceVar.update();
                }
                //calculate new day
                xDiff = lastUsedDraggingElementPosForUpdate[1] - cLeft;
                Logger.log("xDiff: " + xDiff);
                
                if ((xDiff <= -moveIncrementX || xDiff >= moveIncrementX) && lastUsedDraggingElementPosForUpdate[1] != cLeft) {
                    lastUsedDraggingElementPosForUpdate[1] = cLeft;
                    instanceVar.weekDay += (xDiff < 1 ? 1 : -1) * 1;
                }
            },
            stop: function(event, ui){
            
            
                var topPos = instanceVar.element().position().top;
                
                Logger.log("Current startHour: " + instanceVar.startHour);
                //Ajust what was not ajusted before... hackkkk
                cTop = instanceVar.element().position().top
                oTop = originalDraggingElementPos[0];
                //Calc Diff
                yDiff = oTop - cTop;
                
                
                draggingEvent.startHour = originalDraggingEventHours[0] + (yDiff < 1 ? 1 : -1) * minutesIncrement * Math.abs(yDiff / resizeIncrementY);
                draggingEvent.endHour = originalDraggingEventHours[1] + (yDiff < 1 ? 1 : -1) * minutesIncrement * Math.abs(yDiff / resizeIncrementY);
                
                
                draggingEvent.update();
                
                if (!eventManager.canMove(draggingEvent)) {
                
                    orTopPos = originalDraggingElementPos[0];
                    orLeftPos = originalDraggingElementPos[1];
                    
                    
                    
                    instanceVar.startHour = originalDraggingEventHours[0];
                    instanceVar.endHour = originalDraggingEventHours[1];
                    
                    
                    instanceVar.element().animate({
                        top: orTopPos + "px",
                        left: orLeftPos + "px"
                    }, 500, function(){
                        instanceVar.startHour = originalDraggingEventHours[0];
                        instanceVar.endHour = originalDraggingEventHours[1];
                        instanceVar.weekDay = originalDraggingEventWeekDay;
                        instanceVar.update();
                    });
                    
                }
                else {
                    if (originalDraggingEventWeekDay != instanceVar.weekDay) {
                        eventManager.moveDay(instanceVar, originalDraggingEventWeekDay);
                    }
                    eventManager.updateServer();
                    
                }
                draggingEvent = null;
                originalDraggingElementPos = null;
                mouseDownOnEvent = false;
                lastUsedDraggingElementPosForUpdate = null;
                return true;
                
                
            },
            start: function(event, ui){
                draggingEvent = instanceVar;
                originalDraggingEventHours = new Array();
                originalDraggingEventHours[0] = instanceVar.startHour;
                originalDraggingEventHours[1] = instanceVar.endHour;
                
                
                originalDraggingElementPos = new Array();
                originalDraggingElementPos[0] = instanceVar.element().position().top;
                originalDraggingElementPos[1] = instanceVar.element().position().left;
                
                originalDraggingEventWeekDay = instanceVar.weekDay;
                Logger.log("Start dragging Orin day : " + originalDraggingEventWeekDay)
                
                
                
            }
            
        });
        
    }
    
    return this.eventElement;
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
