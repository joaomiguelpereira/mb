
/**
 * Initializer.
 * @param {Object} '#exceptions_container'
 */
$(function(){
    parentDOMElement = $('#exceptions_container');
    
    dataPickerGlobalOptions = {
        monthNamesShort: calendarConfig.dateMonthNamesShort,
        dateFormat: calendarConfig.dateFormat,
        monthNames: calendarConfig.dateMonthNames,
        dayNames: calendarConfig.dateDayNames,
        dayNamesMin: calendarConfig.dateDayNamesShort,
        onSelect: function(dateText, inst){
            $(this).trigger("change");
        }
        
    };
    new ExceptionManager(parentDOMElement);
    
});

var dataPickerGlobalOptions = null;
var dateUtils = new DateUtils();

var exceptionsMessages = {
    error: {
        missingMotive: "É necessário preencher o motivo!",
        missingStartDate: "É necessário preencher a data de início",
        missingEndDate: "É necessário preencher a data de fim",
        endDateGreaterStartDate: "A data de fim tem de ser após a data de ínicio"
    }
};

var exceptionsHeaderTitles = {
    motive: "Motivo",
    startDate: "Data ínicio",
    endDate: "Data fim",
    notes: "Notas",
    actions: "Ações"

};

function DateUtils(){

}

DateUtils.prototype.getDateObectFromServerDateFormat = function(inDate) {
    var array = inDate.split("/");
    var day = parseInt(array[0]);
    var month = parseInt(array[1]);
    var year = parseInt(array[2]);
	return new DateObject(day, month, year);
}




DateUtils.prototype.isUIDateInFuture = function(startDate, endDate){
    //unparse format dd-mmm-yyy. start date
    
    var array = startDate.split("-");
    var startDay = parseInt(array[0]);
    var startMonth = 0;
    var startYear = parseInt(array[2]);
    
    for (var i = 0; i < calendarConfig.dateMonthNamesShort.length; i++) {
        if (calendarConfig.dateMonthNamesShort[i] == array[1]) {
            startMonth = i + 1;
            break;
        }
    }
    array = endDate.split("-");
    var endDay = parseInt(array[0]);
    var endMonth = 0;
    var endYear = parseInt(array[2]);
    
    for (var i = 0; i < calendarConfig.dateMonthNamesShort.length; i++) {
        if (calendarConfig.dateMonthNamesShort[i] == array[1]) {
            endMonth = i + 1;
            break;
        }
    }
    var sDateObject = new DateObject(startDay, startMonth, startYear);
    var eDateObject = new DateObject(endDay, endMonth, endYear);
    return eDateObject.isGreaterThan(sDateObject);
    
    //return ((endYear > startYear) || (endYear == startYear && endMonth > startMonth) || (endYear == startYear && endMonth == startMonth && endDay >= startDay)); 



}

DateUtils.prototype.formatToServer = function(inDate){

    var array = inDate.split("-");
    var day = array[0];
    var month = 0;
    var year = array[2];
    
    for (var i = 0; i < calendarConfig.dateMonthNamesShort.length; i++) {
        if (calendarConfig.dateMonthNamesShort[i] == array[1]) {
            month = i + 1;
            break;
        }
    }
    return day + "/" + month + "/" + year;
    
    
    
    
    
}


DateUtils.prototype.formatToUI = function(inDate){
    //format in the input assumed as dd/mm/yyyy
    var array = inDate.split("/");
    
    return array[0] + "-" + calendarConfig.dateMonthNamesShort[array[1] - 1] + "-" + array[2];
    
}


/**
 * 
 * @param {Object} day
 * @param {Object} month
 * @param {Object} year
 */
function DateObject(day, month, year){
    this.month = month;
    this.year = year;
    this.day = day;
}

DateObject.prototype.toString = function() {
	return this.day+"/"+this.month+"/"+this.year;
}
DateObject.prototype.isGreaterThan = function(otherDate){
    return ((this.year > otherDate.year) || (this.year == otherDate.year && this.month > otherDate.month) || (this.year == otherDate.year && this.month == otherDate.month && this.day >= otherDate.day));
}



/**
 * This is the main manager
 * @param {Object} parentDOMElement
 */
function ExceptionManager(parentDOMElement){
    this.exceptionUITable = new ExceptionsUITable(parentDOMElement, this);
    this.exceptionDataObjects = new Array();
    //load from JSON String
    this.loadFromJSON(availabilityExceptionsInitialData);
}

ExceptionManager.prototype.updateServer = function(){

    var serverData = JSON.stringify(this.exceptionDataObjects);
    //alert(serverData);
    loading_indicator.show();
    $.ajax({
        type: 'PUT',
        url: availabilityExceptionsUpdateUrl,
        data: "json_data=" + serverData,
        success: function(data){
            loading_indicator.hide();
            if (data.status == 'error') {
                flash_messages.show("error", data.message);
            }
        }
        
    });
}

ExceptionManager.prototype.saveException = function(exceptionDataObject, exceptionUIRow){

    this.exceptionDataObjects.push(exceptionDataObject);
    
    this.exceptionUITable.addException(new ExceptionUIRow(exceptionDataObject, this));
    exceptionUIRow.remove();
    this.updateServer();
    
}
ExceptionManager.prototype.remove = function(exceptionUIRow){
    var index = -1;
    for (var i = 0; i < this.exceptionDataObjects.length; i++) {
    
        if (this.exceptionDataObjects[i].id == exceptionUIRow.dataObject.id) {
            index = i;
            break;
        }
    }
    if (index >= 0) {
        this.exceptionDataObjects.splice(index, 1);
    }
    this.updateServer();
    exceptionUIRow.remove();
    
    
    
}
ExceptionManager.prototype.loadFromJSON = function(JSONString){

    if (JSONString.trim().length != 0) {
        var array = JSON.parse(JSONString);
        for (var i = 0; i < array.length; i++) {
            var record = new ExceptionDataObject(array[i].motive, array[i].startDate, array[i].endDate, array[i].notes);
            
            this.exceptionDataObjects.push(record);
            
            this.exceptionUITable.addException(new ExceptionUIRow(record, this));
        }
    }
}

/**
 * Exception Data Object
 */
function ExceptionDataObject(motive, startDate, endDate, notes){
    //Must be unique,
    this.id = new Date().getTime() + Math.floor(Math.random() * 1000)
    
    this.motive = motive;
    this.startDate = startDate;
    this.endDate = endDate;
    this.notes = notes;
}





/**
 * UI object for an existing exception
 */
function ExceptionUIRow(dataObject, exceptionManager){
    this.id = new Date().getTime();
    this.element = null;
    this.dataObject = dataObject;
    this.exceptionManager = exceptionManager;
    
}

ExceptionUIRow.prototype.remove = function(){
    this.element.remove();
}

ExceptionUIRow.prototype.createElement = function(){
	//find if the end date is 1 month after current date

	var today = new Date();
	today.setDate(today.getDate()-15);
	
	
	var endDateObject = dateUtils.getDateObectFromServerDateFormat(this.dataObject.endDate);
	var nowDateObject  = new DateObject(today.getDate(), today.getMonth()+1, today.getFullYear());
	//alert(endDateObject);
	//alert(nowDateObject);
	var additionalCssClass = "";
	var aditionalNotes = "";
	if ( nowDateObject.isGreaterThan(endDateObject) ) {
		additionalCssClass = "pastDate"
		
		aditionalNotes = "(Obsoleta)"
			
	}
    this.element = createElement("tr").addClass(additionalCssClass);
    var motiveElement = createElement("div").html(this.dataObject.motive);
    
    var startDateElement = createElement("div").html(dateUtils.formatToUI(this.dataObject.startDate));
    var endDateElement = createElement("div").html(dateUtils.formatToUI(this.dataObject.endDate));
    var notesElement = createElement("div").html(aditionalNotes+" "+this.dataObject.notes);
    var actionElement = createElement("div");
    var deleteActionElement = createElement("img").attr("src", crossImageUrl);
    actionElement.append(deleteActionElement);
    
    this.element.append(createElement("td").addClass("border_left").append(motiveElement));
    this.element.append(createElement("td").append(startDateElement));
    this.element.append(createElement("td").append(endDateElement));
    this.element.append(createElement("td").append(notesElement));
    this.element.append(createElement("td").append(actionElement));
    var instanceVar = this;
    deleteActionElement.bind("click", function(){
        instanceVar.exceptionManager.remove(instanceVar);
    });
    
	return this.element;
	
}
/**
 * UI object to create new exception
 */
function NewExceptionUIRow(exceptionManager){
    this.id = new Date().getTime();
    this.element = null;
    this.motiveInput = null;
    this.startDateInput = null;
    this.endDateInput = null;
    this.notesInput = null;
    this.exceptionManager = exceptionManager;
}


NewExceptionUIRow.prototype.focus = function(){
    this.motiveInput.focus();
}
NewExceptionUIRow.prototype.remove = function(){
    this.element.remove();
}

NewExceptionUIRow.prototype.save = function(){
    var changeHanlder = function(){
        $(this).removeClass("field_with_errors");
        $(this).unbind("change", changeHanlder)
    };
    
    //validate
    
    if (this.motiveInput.val().trim().length == 0) {
        flash_messages.show("error", exceptionsMessages.error.missingMotive);
        this.motiveInput.focus();
        this.motiveInput.addClass("field_with_errors");
        this.motiveInput.bind("change", changeHanlder);
        return;
    }
    
    
    if (this.startDateInput.val().trim().length == 0) {
        flash_messages.show("error", exceptionsMessages.error.missingStartDate);
        this.startDateInput.focus();
        this.startDateInput.addClass("field_with_errors");
        this.startDateInput.bind("change", changeHanlder);
        return;
    }
    
    
    if (this.endDateInput.val().trim().length == 0) {
        flash_messages.show("error", exceptionsMessages.error.missingEndtDate);
        this.endDateInput.focus();
        this.endDateInput.addClass("field_with_errors");
        this.endDateInput.bind("change", changeHanlder);
        return;
    }
    
    
    
    if (!dateUtils.isUIDateInFuture(this.startDateInput.val(), this.endDateInput.val())) {
        flash_messages.show("error", exceptionsMessages.error.endDateGreaterStartDate);
        this.endDateInput.focus();
        this.endDateInput.addClass("field_with_errors");
        this.endDateInput.bind("change", changeHanlder);
        return;
    }
    //create a ExceptionDataBoject from it
    
    var tmpStartDate = dateUtils.formatToServer(this.startDateInput.val());
    var tmpEndDate = dateUtils.formatToServer(this.endDateInput.val());
    var exceptionDataObject = new ExceptionDataObject(this.motiveInput.val(), tmpStartDate, tmpEndDate, this.notesInput.val())
    this.exceptionManager.saveException(exceptionDataObject, this);
}

NewExceptionUIRow.prototype.createElement = function(){
    this.element = createElement("tr");
    this.motiveInput = createElement("input").addClass("has-tooltip").attr("type", "text").attr("size", "30").css("width", "200px");
    this.startDateInput = createElement("input").attr("type", "text").attr("size", "10").css("width", "100px");
    this.endDateInput = createElement("input").attr("type", "text").attr("size", "10").css("width", "100px");
    this.notesInput = createElement("textarea").attr("cols", 25);
    
    var actionsDiv = createElement("div");
    var okSymbol = createElement("img").attr("src", tickImageUrl);
    var cancelSymbol = createElement("img").attr("src", crossImageUrl);
    
    
    var tdHeaderCellMotive = createElement("td").addClass("border_left").append(this.motiveInput);
    var tdHeaderCellStartDate = createElement("td").append(this.startDateInput);
    var tdHeaderCellEndDate = createElement("td").append(this.endDateInput);
    var tdHeaderCellNotes = createElement("td").append(this.notesInput);
    var tdHeaderCellActions = createElement("td").append(actionsDiv);
    
    this.element.append(tdHeaderCellMotive);
    this.element.append(tdHeaderCellStartDate);
    this.element.append(tdHeaderCellEndDate);
    this.element.append(tdHeaderCellNotes);
    this.element.append(tdHeaderCellActions);
    actionsDiv.append(okSymbol);
    actionsDiv.append(cancelSymbol);
    
    this.startDateInput.datepicker(dataPickerGlobalOptions);
    this.endDateInput.datepicker(dataPickerGlobalOptions);
    var instanceVar = this;
    cancelSymbol.bind("click", function(){
        instanceVar.remove();
        
    });
    okSymbol.bind("click", function(){
        instanceVar.save();
    })
    
    this.startDateInput.bind("keydown", function(event){
        event.preventDefault();
        
    });
    this.endDateInput.bind("keydown", function(event){
        event.preventDefault();
        
    });
    
    return this.element;
    
}

/**
 * This object represents the UI table showing the exceptions
 */
function ExceptionsUITable(parentDOMElement, exeptionManager){
    this.parentDOMElement = parentDOMElement;
    this.table = null;
    this.exceptionManager = exeptionManager;
    this.render();
}

ExceptionsUITable.prototype.addException = function(uiExceptionRow){
    this.table.find("tr:last").before(uiExceptionRow.createElement());
}
ExceptionsUITable.prototype.makeRoomForNewRecord = function(){
    var newRow = new NewExceptionUIRow(this.exceptionManager);
    this.table.find("tr:last").before(newRow.createElement());
    newRow.focus();
    
    //alert("new ");
}
/**
 * This will render the skeleton DOM table
 */
ExceptionsUITable.prototype.render = function(){


    var instanceVar = this;
    this.table = createElement("table").attr("border", "0px").attr("cellspacing", "0px").addClass("editable_table");
    
    var tHeader = createElement("thead");
    var tHeaderRow = createElement("tr");
    
    var tdHeaderCellMotive = createElement("td").html(exceptionsHeaderTitles.motive).addClass("border_left").css("width", "240px");
    var tdHeaderCellStartDate = createElement("td").html(exceptionsHeaderTitles.startDate).css("width", "120px");
    var tdHeaderCellEndDate = createElement("td").html(exceptionsHeaderTitles.endDate).css("width", "120px");
    var tdHeaderCellNotes = createElement("td").html(exceptionsHeaderTitles.notes).css("width", "240px");
    var tdHeaderCellActions = createElement("td").html(exceptionsHeaderTitles.actions).css("width", "82px");
    
    tHeaderRow.append(tdHeaderCellMotive);
    tHeaderRow.append(tdHeaderCellStartDate);
    tHeaderRow.append(tdHeaderCellEndDate);
    tHeaderRow.append(tdHeaderCellNotes);
    tHeaderRow.append(tdHeaderCellActions);
    
    tHeader.append(tHeaderRow);
    this.table.append(tHeader);
    //render body
    var tableBody = createElement("tbody");
    
    
    //render last row
    var actionsRow = createElement("tr").addClass("last_row");
    var tdActionsCell = createElement("td").attr("colspan", "5");
    var addNewExceptionLink = createElement("a").attr("href", "#").addClass("link_as_button").addClass("action_add").html("Definir nova excepção");
    tdActionsCell.append(addNewExceptionLink);
    addNewExceptionLink.bind("click", function(){
        instanceVar.makeRoomForNewRecord();
        return false;
    });
    actionsRow.append(tdActionsCell);
    
    tableBody.append(actionsRow);
    
    
    this.table.append(tableBody);
    
    this.parentDOMElement.append(this.table);
    
}

