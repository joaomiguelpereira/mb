/**
 * @author jpereira
 */
var dataPickerGlobalOptions = null;
var headerTitles = null;
var isInitialized = false;

var availabilityExceptionsInitialData__ = "[{\"startDate\":\"12/12/2001\",\"endDate\":\"12/12/2001\",\"motive\":\"Holidays, big ones\",\"notes\":\"Some notes\"}]";
$.fn.qtip.styles.helpTip = {


    width: 200,
    padding: 3,
    background: '#00BF08',
    color: '#ffffff',
    textAlign: 'center',
    border: {
        width: 7,
        radius: 5,
        color: '#00BF08'
    },
    tip: 'bottomLeft',
    name: 'dark'
};



$(function(){
    $("#exceptions_container").bind("initializeExceptions", function(){
        availabilityExceptionsManager.initialize();
        
    });
    
    dataPickerGlobalOptions = {
        monthNamesShort: calendarConfig.dateMonthNamesShort,
        dateFormat: calendarConfig.dateFormat.format,
        monthNames: calendarConfig.dateMonthNames,
        dayNames: calendarConfig.dateDayNames,
        dayNamesMin: calendarConfig.dateDayNamesShort,
        onSelect: function(dateText, inst){
            $(this).trigger("change");
        }
        
    };
    
    exceptionsHeaderTitles = {
        motive: "Motivo",
        startDate: "Data ínicio",
        endDate: "Data fim",
        notes: "Notas"
    };
    exceptionsMessages = {
        error: {
            missingMotive: "É necessário preencher o motivo!",
            missingStartDate: "É necessário preencher a data de início",
            missingEndDate: "É necessário preencher a data de fim",
            endDateGreaterStartDate: "A data de fim tem de ser após a data de ínicio"
        }
    }
});

var availabilityExceptionsManager = {
    exceptionsTable: null,
    
    initialize: function(){
        if (typeof tickImageUrl === 'undefined' || typeof crossImageUrl === 'undefined') {
            alert("missing some configurations");
            throw "Missing some configurations"
        }
        if (!isInitialized) {
            availabilityExceptionsManager.loadFromJson(availabilityExceptionsInitialData__);
            availabilityExceptionsManager.exceptionsTable = new ExceptionsTable($("#exceptions_container")).render();
            
            isInitialized = true;
        }
        
    },
	saveException: function(exception) {
		alert("Add to a arrnay and save in server.,.");
	},
    loadFromJson: function(jsonData){
        Logger.log("Loading from json: " + jsonData);
        var array = JSON.parse(jsonData);
        for (var i = 0; i < array.length; i++) {
            Logger.log("Loading exception startDate: " + array[i].startDate);
            Logger.log("Loading exception endDate: " + array[i].endDate);
            Logger.log("Loading exception motive: " + array[i].motive);
            Logger.log("Loading exception notes: " + array[i].notes);
            
        }
        
    }
}

/**
 * Exceptions Table Editable row
 */
function ExceptionsRow(){
    this.isNew = true;
    this.rowElement = null;
    this.motiveInput = null;
    this.startDateInput = null;
    this.endDateInput = null;
    this.notesInput = null;
    this.actionsDiv = null;
    this.okSymbol = null;
    this.cancelSymbol = null;
    
    this.dataObject = {
        startDate: null,
        endDate: null,
        motive: null,
        notes: null
    };
    
}

ExceptionsRow.prototype.fromDataObject = function(dataObject){
    this.dataObject = dataObject;
}


ExceptionsRow.prototype.toDataObject = function(){


    this.dataObject.motive = this.motiveInput.val().trim();
    
    this.dataObject.startDate = calendarConfig.dateFormat.parser(this.startDateInput.val());
    this.dataObject.endDate = calendarConfig.dateFormat.parser(this.endDateInput.val());
    this.dataObject.notes = this.notesInput.val().trim();
    
    Logger.log("Start Date Day: " + this.dataObject.startDate.day);
    Logger.log("Start Date Month: " + this.dataObject.startDate.month);
    Logger.log("Start Date Year: " + this.dataObject.startDate.year);
    
    
    
}
ExceptionsRow.prototype.focus = function(){
    this.motiveInput.focus();
}

ExceptionsRow.prototype.validate = function(){

    var changeHanlder = function(){
        $(this).removeClass("field_with_errors");
        $(this).unbind("change", changeHanlder)
    };
    
    
    if (this.motiveInput.val().trim().length == 0) {
    
        this.motiveInput.addClass("field_with_errors");
        this.motiveInput.focus();
        flash_messages.show("error", exceptionsMessages.error.missingMotive, {
            autoClose: true,
            autoCloseTime: 10000
        });
        this.motiveInput.bind("change", changeHanlder);
        return false;
    }
    
    if (this.startDateInput.val().trim().length == 0) {
        this.startDateInput.addClass("field_with_errors");
        this.startDateInput.focus();
        flash_messages.show("error", exceptionsMessages.error.missingStartDate);
        this.startDateInput.bind("change", changeHanlder);
        return false;
        
    }
    if (this.endDateInput.val().trim().length == 0) {
        this.endDateInput.addClass("field_with_errors");
        this.endDateInput.focus();
        flash_messages.show("error", exceptionsMessages.error.missingEndDate);
        this.endDateInput.bind("change", changeHanlder);
        return false;
    }
    
    //check date
    if (!this.dataObject.endDate.isInFuture(this.dataObject.startDate)) {
        this.endDateInput.addClass("field_with_errors");
        this.endDateInput.focus();
        flash_messages.show("error", exceptionsMessages.error.endDateGreaterStartDate);
        this.endDateInput.bind("change", changeHanlder);
        return false;
    }
	
	return true;
}


ExceptionsRow.prototype.saveException = function(){
    this.toDataObject();
    if ( this.validate() ) {
		alert("Adding to table....");
		availabilityExceptionsManager.saveException(this);
		
		
	}
	
    
}
var dateUtils = {

    convert: function(value, originalFormat, targetFormat){
        return value;
    }
};

ExceptionsRow.prototype.toString = function(){

    return this.motiveInput.val() + "->" + dateUtils.convert(this.startDateInput.val(), "d-M-yy", "dd-mm-yy");
}

ExceptionsRow.prototype.cancelEditException = function(){
    if (this.isNew) {
        this.rowElement.remove();
    }
}

ExceptionsRow.prototype.element = function(){
    if (this.rowElement == null) {
        var instanceVar = this;
        this.rowElement = createElement("tr");
        
        this.motiveInput = createElement("input").addClass("has-tooltip").attr("type", "text").attr("size", "30").css("width", "200px");
        this.startDateInput = createElement("input").attr("type", "text").attr("size", "10").css("width", "100px");
        this.endDateInput = createElement("input").attr("type", "text").attr("size", "10").css("width", "100px");
        this.notesInput = createElement("textarea").attr("cols", 25);
        this.actionsDiv = createElement("div");
        this.okSymbol = createElement("img").attr("src", tickImageUrl);
        this.cancelSymbol = createElement("img").attr("src", crossImageUrl);
        
        this.actionsDiv.append(this.okSymbol);
        this.actionsDiv.append(this.cancelSymbol);
        
        
        
        var tdHeaderCellMotive = createElement("td").addClass("border_left").append(this.motiveInput);
        var tdHeaderCellStartDate = createElement("td").append(this.startDateInput);
        var tdHeaderCellEndDate = createElement("td").append(this.endDateInput);
        var tdHeaderCellNotes = createElement("td").append(this.notesInput);
        var tdHeaderCellActions = createElement("td").append(this.actionsDiv);
        
        this.rowElement.append(tdHeaderCellMotive);
        this.rowElement.append(tdHeaderCellStartDate);
        this.rowElement.append(tdHeaderCellEndDate);
        this.rowElement.append(tdHeaderCellNotes);
        this.rowElement.append(tdHeaderCellActions);
        
        this.startDateInput.datepicker(dataPickerGlobalOptions);
        this.endDateInput.datepicker(dataPickerGlobalOptions);
        
        
        this.motiveInput.qtip({
            content: 'Preencha o motivo da excepção. P. ex.: Férias',
            show: {
                when: 'focus',
                effect: {
                    type: 'fade',
                    length: '500'
                }
            },
            hide: 'blur',
            style: 'helpTip',
            position: {
                corner: {
                    target: 'topMiddle',
                    tooltip: 'bottomMiddle'
                }
            }
        });
        
        
        
        
        this.okSymbol.bind("click", function(){
            instanceVar.saveException();
        });
        
        
        this.cancelSymbol.bind("click", function(){
            instanceVar.cancelEditException();
        });
        
        this.startDateInput.bind("keydown", function(event){
            event.preventDefault();
            
        });
        this.endDateInput.bind("keydown", function(event){
            event.preventDefault();
            
        });
        
        
        
    }
    return this.rowElement;
}
/**
 * Exceptions Table
 * @param {Object} parentElement
 */
function ExceptionsTable(parentElement){
    this.parentElement = parentElement;
    this.table = null;
    
}

ExceptionsTable.prototype.createNewExceptionRow = function(){
    var row = new ExceptionsRow();
    this.table.find("tr:last").before(row.element());
    row.focus();
    
    
}
ExceptionsTable.prototype.render = function(){
    var instanceVar = this;
    
    //create header
    this.table = createElement("table").attr("border", "0px").attr("cellspacing", "0px").addClass("editable_table");
    var tHeader = createElement("thead");
    var tHeaderRow = createElement("tr");
    
    var tdHeaderCellMotive = createElement("td").html(exceptionsHeaderTitles.motive).addClass("border_left").css("width", "240px");
    var tdHeaderCellStartDate = createElement("td").html(exceptionsHeaderTitles.startDate).css("width", "120px");
    var tdHeaderCellEndDate = createElement("td").html(exceptionsHeaderTitles.endDate).css("width", "120px");
    var tdHeaderCellNotes = createElement("td").html(exceptionsHeaderTitles.notes).css("width", "240px");
    var tdHeaderCellActions = createElement("td").html("Actions").css("width", "82px");
    
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
        instanceVar.createNewExceptionRow();
        return false;
    });
    actionsRow.append(tdActionsCell);
    
    tableBody.append(actionsRow);
    
    
    this.table.append(tableBody);
    
    this.parentElement.append(this.table);
    
    
    return this;
    
}
