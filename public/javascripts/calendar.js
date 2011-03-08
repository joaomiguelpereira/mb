var week_days = ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"];
var start_hour = 0;
var end_hour = 24;
var calendarBodyContainer = null;

/**
 * @author jpereira
 */
function Calendar(){
    this.events = new Array();
}


/********************************
 * Calendar Event
 * @param {Object} startHour
 * @param {Object} weekDay
 */
function CalendarEvent(startHour, weekDay){
    this.eventElement = null;
    this.startHour = startHour;
    this.weekDay = weekDay;
    this.endHour = startHour + 30;
    this.infoEl = null;
}

CalendarEvent.prototype.setEndHour = function(endHour){
    this.endHour = endHour;
    if (this.endHour == this.startHour) {
        this.endHour = this.endHour + 30;
    }
    this.infoEl.html(CalendarUtils.formatHour(this.startHour) + " - " + CalendarUtils.formatHour(this.endHour));
}

CalendarEvent.prototype.element = function(){
    if (this.eventElement == null) {
        this.eventElement = createElement("div").addClass("calendar_event");
        this.infoEl = createElement("div").addClass("calendar_event_info").html(CalendarUtils.formatHour(this.startHour) + " - " + CalendarUtils.formatHour(this.endHour));
        this.eventElement.append(this.infoEl);
		
        /*this.eventElement.resizable({
         grid: 26,
         maxWidth: 100,
         minWidth: 100,
         resize: function(event, ui) {
         
         console.log("Resizing..."+ui.size.height);
         
         },
         start: function(event, ui) {
         console.log(ui.size.height);
         }
         }).draggable({
         grid: [101, 26]
         });*/
        /*
         this.eventElement.bind("resizecreate", function() {
         alert("created");
         });*/
    }
    return this.eventElement;
}

CalendarEvent.prototype.updateHeight = function(){
    //this.eventElement.height(200);
    //this.eventElement.trigger("resize");
}

var definingEvent = null;

/*****************************************
 * Calendar Slot
 ****************************************/
function CalendarSlot(weekDay, hour){
    this.slotElement = null;
    this.weekDay = weekDay;
    this.hour = hour;
    this.event = null;
    this.selected = false;
    
}

CalendarSlot.prototype.startSelecting = function(){

    if (this.event == null) {
        this.event = new CalendarEvent(this.hour, this.weekDay);
        this.slotElement.append(this.event.element());
        
        definingEvent = this.event;
    }
    
}


CalendarSlot.prototype.endSelecting = function(){
    if (definingEvent != null) {
        definingEvent.setEndHour(this.hour);
        definingEvent = null;
    }
}

CalendarSlot.prototype.selecting = function(){

    if (definingEvent != null) {
        definingEvent.setEndHour(this.hour);
        
        //definingEvent = null;
    }
}

CalendarSlot.prototype.element = function(){
    var thisVar = this;
    if (this.slotElement == null) {
        this.slotElement = createElement("td");
        this.slotElement.bind('mousedown', function(){
            thisVar.startSelecting();
        });
        this.slotElement.bind("mousemove", function(){
            thisVar.selecting();
        });
        this.slotElement.bind('mouseup', function(){
            thisVar.endSelecting();
        });
        
        
    }
    return this.slotElement;
}

/***********************************
 * CalendarBody
 ***********************************/
function CalendarBody(){
    this.container = null;
    this.table = null;
    this.container_wrapper = null;
}

CalendarBody.prototype.build = function(){

    this.container_wrapper = createElement("div").addClass("calendar_body_wrapper");
    //this.container_wrapper.resizable();
    this.container = createElement("div").addClass("calendar_body");
    this.table = createElement("table").attr("border", "0px").attr("cellspacing", "0px").addClass("calendar_table");
    
    
    for (i = start_hour; i < end_hour; i++) {
    
    
        first_half_hour_row = createElement("tr");
        second_half_hour_row = createElement("tr");
        hour_cell = createElement("td").attr("rowspan", 2).html(CalendarUtils.formatHour(i * 60)).addClass("calendar_body_hour");
        
        first_half_hour_row.append(hour_cell)
        for (j = 0; j < week_days.length; j++) {
        
        
        
            first_half_slot = new CalendarSlot(j, i * 60);
            second_half_slot = new CalendarSlot(j, ((i * 60) + 30));
            
            first_half = first_half_slot.element();
            second_half = second_half_slot.element();
            
            
            first_half.addClass("first_hour_half");
            
            
            first_half_hour_row.append(first_half);
            second_half_hour_row.append(second_half);
        }
        
        this.table.append(first_half_hour_row);
        this.table.append(second_half_hour_row);
        
    }
    
    
    this.container.append(this.table);
    this.container_wrapper.append(this.container);
    return this.container_wrapper;
    
}


function CalendarHeader(){
    this.container = null;
    this.table = null;
}


CalendarHeader.prototype.build = function(){

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
    return this.container;
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

var calendar = {

    render_week_view: function(parent_container){
    
        container = createElement("div");
        container.append(new CalendarHeader().build());
        container.append(new CalendarBody().build());
        parent_container.append(container);
        
        
        
    }
}

