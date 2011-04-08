/**
 * @author jpereira
 */
var availabilityMessages = {
    error: {
        missingName: "É necessário preencher o nome!"
    }
};
$(function(){
    parentElement = $('#specialities_container');
    var manager = new SpecialitiesManager(parentElement, baseURL);
    manager.initialize();
	manager.loadData();
});

/**
 * Data Object
 * @param {Object} name
 * @param {Object} description
 */
function SpecialityDataObject(name, description) {
	this.name = name;
	this.description = description;
}

/**
 * 
 * @param {Object} parentElement
 * @param {Object} baseURL
 */
function SpecialitiesManager(parentElement, baseURL){
    this.parentElement = parentElement;
    this.baseURL = baseURL;
    this.domTable = null;
}

SpecialitiesManager.prototype.savepeciality = function(specialityDataObject, newSpecialityDOMRow) {
	alert("Saving "+specialityDataObject.name);
	alert("Saving "+specialityDataObject.description);
	
}

SpecialitiesManager.prototype.loadData = function(){
	
	loading_indicator.show();
	    $.ajax({
        type: 'GET',
        url: this.baseURL+".json",
        data: "",
        success: function(data){
            loading_indicator.hide();
            if (data.status == 'error') {
                flash_messages.show("error", data.message);
            }
        }
        
    });


}


SpecialitiesManager.prototype.initialize = function(){
    this.domTable = new SpecialitiesDOMTable(this);
    this.parentElement.append(this.domTable.table);
}


/**
 * Represents a new Speciality
 */
function NewSpecialityDOMRow(specialitiesManager){
    this.specialitiesManager = specialitiesManager;
    this.element = this.createElement();
    this.nameInput = null;
    this.descriptionInput = null;
}

NewSpecialityDOMRow.prototype.focus = function(){

    if (this.nameInput != null) {
        this.nameInput.focus();
    }
}
NewSpecialityDOMRow.prototype.saveSpeciality = function(){
    var changeHanlder = function(){
        $(this).removeClass("field_with_errors");
        $(this).unbind("change", changeHanlder)
    };
    
    //Validate it
    if (this.nameInput.val().trim().length == 0) {
    
        flash_messages.show("error", availabilityMessages.error.missingName);
        this.nameInput.focus();
        this.nameInput.addClass("field_with_errors");
        this.nameInput.bind("change", changeHanlder);
        return;
    }
	
	this.specialitiesManager.savepeciality(new SpecialityDataObject(this.nameInput.val().trim(), this.descriptionInput.val().trim()), this);
    
}
NewSpecialityDOMRow.prototype.createElement = function(){
    if (this.domElement == null) {
        this.element = createElement("tr");
        this.nameInput = createElement("input").addClass("has-tooltip").attr("type", "text").attr("size", "30").css("width", "200px");
        this.descriptionInput = createElement("textarea").attr("cols", 30).css("width", "280px");
        
        //Create the div for the action icons
        var actionsDiv = createElement("div");
        var okSymbol = createElement("img").attr("src", tickImageUrl);
        var cancelSymbol = createElement("img").attr("src", crossImageUrl);
        actionsDiv.append(okSymbol);
        actionsDiv.append(cancelSymbol);
        
        var tdHeaderCellName = createElement("td").addClass("border_left").append(this.nameInput);
        var tdHeaderCellDescription = createElement("td").append(this.descriptionInput);
        var tdHeaderCellActions = createElement("td").append(actionsDiv);
        this.element.append(tdHeaderCellName);
        this.element.append(tdHeaderCellDescription);
        this.element.append(tdHeaderCellActions);
        var instanceVar = this;
        cancelSymbol.bind("click", function(){
            instanceVar.element.remove();
        });
        okSymbol.bind("click", function(){
            instanceVar.saveSpeciality();
        });
        
    }
    
    return this.element;
}


/**
 * The DOM Table
 */
function SpecialitiesDOMTable(specialitiesManager){
    this.table = this.createElement();
    this.specialitiesManager = specialitiesManager;
    
}

SpecialitiesDOMTable.prototype.makeRoomForNewRecord = function(){
    var row = new NewSpecialityDOMRow(this.specialitiesManager);
    this.table.find("tr:last").before(row.createElement());
    row.focus();
}
SpecialitiesDOMTable.prototype.createElement = function(){
    if (this.table == null) {
        this.table = createElement("table").attr("border", "0px").attr("cellspacing", "0px").addClass("editable_table");
        var tHeader = createElement("thead");
        var tHeaderRow = createElement("tr");
        var tdHeaderCellSpeciality = createElement("td").html("Especialidade").addClass("border_left").css("width", "240px");
        var tdHeaderCellSpecialityDescription = createElement("td").html("Descrição/Definição").css("width", "300px");
        var tdHeaderCellActions = createElement("td").html("Ações").css("width", "82px");
        
        tHeaderRow.append(tdHeaderCellSpeciality);
        tHeaderRow.append(tdHeaderCellSpecialityDescription);
        tHeaderRow.append(tdHeaderCellActions);
        tHeader.append(tHeaderRow);
        this.table.append(tHeader);
        
        
        var tableBody = createElement("tbody");
        
        
        //render last row
        var actionsRow = createElement("tr").addClass("last_row");
        var tdActionsCell = createElement("td").attr("colspan", "3");
        
        var addNewExceptionLink = createElement("a").attr("href", "#").addClass("link_as_button").addClass("action_add").html("Adicionar especialidade");
        tdActionsCell.append(addNewExceptionLink);
        var instanceVar = this;
        addNewExceptionLink.bind("click", function(){
            instanceVar.makeRoomForNewRecord();
            return false;
        });
        actionsRow.append(tdActionsCell);
        
        tableBody.append(actionsRow);
        
        
        this.table.append(tableBody);
        
        
    }
    
    return this.table;
}
