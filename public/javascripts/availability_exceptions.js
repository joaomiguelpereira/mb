/**
 * @author jpereira
 */
var dataPickerGlobalOptions = null;
var headerTitles = null;
var isInitialized = false;


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
        monthNamesShort: dateMonthNamesShort,
        dateFormat: 'd-M-yy',
        monthNames: dateMonthNames,
        dayNames: dateDayNames,
        dayNamesMin: dateDayNamesShort,
    
    };
    
    headerTitles = {
        motive: "Motivo",
        startDate: "Data ínicio",
        endDate: "Data fim",
        notes: "Notas"
    };
});

var availabilityExceptionsManager = {
    exceptionsTable: null,
    
    initialize: function(){
        if (typeof tickImageUrl === 'undefined' || typeof crossImageUrl === 'undefined') {
            alert("missing some configurations");
            throw "Missing some configurations"
        }
        if (!isInitialized) {
            availabilityExceptionsManager.exceptionsTable = new ExceptionsTable($("#exceptions_container")).render();
            
            isInitialized = true;
        }
        else {
        
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
    
}

ExceptionsRow.prototype.focus = function(){
    this.motiveInput.focus();
    
    
    
}

ExceptionsRow.prototype.validate = function(){
    if (this.motiveInput.val().trim().length == 0) {
        this.motiveInput.addClass("field_with_errors");
    	this.motiveInput.focus();
		flash_messages.show("error","É necessário preencher o motivo");
		return false;
	}
}
ExceptionsRow.prototype.saveException = function(){
    this.validate();
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
    
    var tdHeaderCellMotive = createElement("td").html(headerTitles.motive).addClass("border_left").css("width", "240px");
    var tdHeaderCellStartDate = createElement("td").html(headerTitles.startDate).css("width", "120px");
    var tdHeaderCellEndDate = createElement("td").html(headerTitles.endDate).css("width", "120px");
    var tdHeaderCellNotes = createElement("td").html(headerTitles.notes).css("width", "240px");
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
