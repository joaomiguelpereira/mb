
/**
 * @author jpereira
 */
var week_days = ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"];
var start_hour = 0;
var end_hour = 24;
var definingEvent = null;
var resizeIncrementY = 19;
var moveIncrementX = 100;
var minutesIncrement = 30;
var eventManager = new EventManager();
var mouseDownOnEvent = false;
var bodyElementId = "__body__el__id";
var browser = $.browser;
resizeIncrementY = browser.mozilla?19:20; 
$(function(){
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
    
    
});
/****************************************************
 * EventsManager Object
 */
function EventManager(){

    this.events = new Array();
    for (var i = 0; i < week_days.length; i++) {
        this.events[i] = new Array();
    }
    
}

EventManager.prototype.dump = function(){
    if ($("#dumper_zone")) {
        var html = "";
        for (var i = 0; i < week_days.length; i++) {
            day_array = this.events[i];
            html += "<div><strong>Day " + i + "</strong></div>";
            for (var j = 0; j < day_array.length; j++) {
                html += "<div>Event: " + day_array[j] + "</div>";
            }
        }
        $("#dumper_zone").html(html);
    }
}

EventManager.prototype.save = function(event){
    var array = this.events[event.weekDay];
    array.push(event);
}

EventManager.prototype.moveDay = function(event, originalDay){
    Logger.log("Moving original day: " + originalDay);
    Logger.log("Moving event day: " + event.weekDay);
    var array = this.events[originalDay];
    array.splice(this.events.indexOf(event));
    this.save(event);
}



EventManager.prototype.remove = function(event){

    array = this.events[event.weekDay];
    Logger.log("removing..." + array.length)
    array.splice(this.events.indexOf(event));
    Logger.log("removed..." + array.length)
    event.remove();
}


EventManager.prototype.canMove = function(event){
    //Check end hour if is beyond time
    
    if (event.endHour > end_hour * 60 || event.endHour < minutesIncrement || event.startHour < 0) {
        return false;
    }
    
    //Check if it colides with any existing event in the calendar
    Logger.log("can move...");
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
        if (event.endHour > end_hour * 60) {
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
    $(this.calendarBody.element()).scrollTo('+=300px', {
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
        for (i = 0; i < week_days.length; i++) {
            el = createElement("td").html(week_days[i]);
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

WeekCalendarBody.prototype.element = function(){
    if (this.container_wrapper == null) {
    
    
        this.container_wrapper = createElement("div").addClass("calendar_body_wrapper").attr("id", bodyElementId);
        
        
        this.container = createElement("div").addClass("calendar_body");
        
        this.table = createElement("table").attr("border", "0px").attr("cellspacing", "0px").addClass("calendar_table");
        
        
        for (i = start_hour; i < end_hour; i++) {
        
        
            first_half_hour_row = createElement("tr");
            second_half_hour_row = createElement("tr");
            hour_cell = createElement("td").attr("rowspan", 2).html(CalendarUtils.formatHour(i * 60)).addClass("calendar_body_hour");
            
            
            
            first_half_hour_row.append(hour_cell)
            for (j = 0; j < week_days.length; j++) {
            
            
            
                first_half_slot = new CalendarSlot(j, i * 60);
                second_half_slot = new CalendarSlot(j, ((i * 60) + minutesIncrement));
                
                first_half = first_half_slot.element();
                second_half = second_half_slot.element();
                first_half.addClass("calendar_slot");
                second_half.addClass("calendar_slot");
                first_half.addClass("first_hour_half");
                first_half_hour_row.append(first_half);
                second_half_hour_row.append(second_half);
            }
            
            this.table.append(first_half_hour_row);
            this.table.append(second_half_hour_row);
            
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
                definingEvent.save(event);
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

CalendarEvent.prototype.initialize = function(){
    if (this.initialized == false) {
        position = this.eventElement.position();
        
        
        this.eventElement.css("position", "absolute");
        
        
        this.eventElement.css("top", (position.top) + "px");
        this.initialized = true;
    }
    
}
CalendarEvent.prototype.update = function(){


    this.infoEl.html(CalendarUtils.formatHour(this.startHour) + " - " + CalendarUtils.formatHour(this.endHour) + "@" + this.weekDay);
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


CalendarEvent.prototype.save = function(event){
    if (definingEvent != null) {
    
        eventManager.save(definingEvent);
        mouseDownOnEvent = false;
        definingEvent = null;
    }
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
                        Logger.log("Moving...");
                        eventManager.moveDay(instanceVar, originalDraggingEventWeekDay);
                    }
                    
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


/*************************************************************
 * Calendar Utils
 * @param {Object} minutes
 ************************************************************/
var Logger = {
    log: function(what){
        if (window.console) {
            console.log(what);
        }
        
    }
}
var CalendarUtils = {
    formatHour: function(minutes){
        var date = new Date(minutes * 60 * 1000)
        var hours = date.getHours();
        var minutes = date.getMinutes();
        
        
        if (hours <= 9) {
            hours = "0" + hours
        }
        
        if (minutes <= 9) {
            minutes = "0" + minutes
        }
        
        return hours + ":" + minutes;
    }
}
