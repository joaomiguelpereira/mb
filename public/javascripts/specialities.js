/**
 * @author jpereira
 */
var availabilityMessages = {
	error: {
		missingName: "É necessário preencher o nome!"
	},
	messages: {
		confirmRemove: "Tem a certeza que quer remover esta especialidade?"
	}
};
$( function() {
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
function SpecialityDataObject(name, description, id) {
	this.name = name;
	this.description = description;
	this.id = id;
}

SpecialityDataObject.prototype.toString = function() {
	return this.name+";"+this.description+";"+this.id;
}
/**
 *
 * @param {Object} parentElement
 * @param {Object} baseURL
 */
function SpecialitiesManager(parentElement, baseURL) {
	this.parentElement = parentElement;
	this.baseURL = baseURL;
	this.domTable = null;
	this.dataObjects = new Array();
}

SpecialitiesManager.prototype.removeSpeciality = function(specialityDOMRow, dataObject) {

	if (confirm(availabilityMessages.messages.confirmRemove)) {
		loading_indicator.show();
		var instance = this;
		$.ajax({
			type: 'DELETE',
			url: this.baseURL+".json",
			data: "speciality_id="+dataObject.id,
			success: function(data) {
				loading_indicator.hide();
				if (data.status == 'error') {
					flash_messages.show("error", data.message);
				} else {
					var index = 0;
					for (index=0; index<instance.dataObjects.length;index++) {
						if ( instance.dataObjects[index].id == dataObject.id ) {
							break;
						}
					}
					instance.dataObjects.splice(index, 1);
					specialityDOMRow.element.remove();

				}
			}
		});

	}

}
SpecialitiesManager.prototype.saveSpeciality = function(specialityDataObject, newSpecialityDOMRow) {

	//alert("Saving "+specialityDataObject.name);
	//alert("Saving "+specialityDataObject.description);
	var jsonData = JSON.stringify(specialityDataObject);
	var instance = this;
	//alert(jsonData);

	//call server to save this speciality
	loading_indicator.show();
	$.ajax({
		type: 'POST',
		url: this.baseURL+".json",
		data: "speciality="+jsonData,
		success: function(data) {
			loading_indicator.hide();
			if (data.status == 'error') {
				flash_messages.show("error", data.message);
			} else {
				var speciality = JSON.parse(data.speciality);
				specialityDataObject.id = speciality.speciality.id;
				instance.dataObjects.push(specialityDataObject);
				var specialityDOMRow = new SpecialityDOMRow(instance, specialityDataObject);
				instance.domTable.addExistingRecord(specialityDOMRow);
				newSpecialityDOMRow.element.remove();

			}
		}
	});

}
SpecialitiesManager.prototype.populate = function(JSONData) {
	//fail if JSONData is not an array

	for (var i=0; i < JSONData.length; i++ ) {
		var specialityDataObject = new SpecialityDataObject(JSONData[i].speciality.name,JSONData[i].speciality.description, JSONData[i].speciality.id);
		this.dataObjects.push(specialityDataObject);
		var specialityDOMRow = new SpecialityDOMRow(this, specialityDataObject);
		this.domTable.addExistingRecord(specialityDOMRow);

	}

}
SpecialitiesManager.prototype.loadData = function() {
	var instance = this;
	loading_indicator.show();
	$.ajax({
		type: 'GET',
		url: this.baseURL+".json",
		data: "",
		success: function(data) {
			loading_indicator.hide();

			if (data.status == 'error') {
				flash_messages.show("error", data.message);
			} else {
				instance.populate(data);
			}
		}
	});

}
SpecialitiesManager.prototype.initialize = function() {
	this.domTable = new SpecialitiesDOMTable(this);
	this.parentElement.append(this.domTable.table);
}
/**
 * Represents a saved speciality
 */
function SpecialityDOMRow(specialitiesManager, specilityDataObject) {
	this.dataObject = specilityDataObject;
	this.specialitiesManager = specialitiesManager;
	this.element = this.createElement();
}

SpecialityDOMRow.prototype.createElement = function() {
	if (this.element == null) {
		this.element = createElement("tr");

		var nameDiv = createElement("div").html(this.dataObject.name);
		var descriptionDiv = createElement("div").html(this.dataObject.description);

		//Create the div for the action icons
		var actionsDiv = createElement("div");
		var deleteSymbol = createElement("img").attr("src", crossImageUrl);

		actionsDiv.append(deleteSymbol);

		var tdHeaderCellName = createElement("td").addClass("border_left").append(nameDiv);
		var tdHeaderCellDescription = createElement("td").append(descriptionDiv);
		var tdHeaderCellActions = createElement("td").append(actionsDiv);
		this.element.append(tdHeaderCellName);
		this.element.append(tdHeaderCellDescription);
		this.element.append(tdHeaderCellActions);
		var instanceVar = this;
		deleteSymbol.bind("click", function() {
			instanceVar.specialitiesManager.removeSpeciality(instanceVar, instanceVar.dataObject);
		});
	}
	return this.element;
}
/**
 * Represents a new Speciality
 */
function NewSpecialityDOMRow(specialitiesManager) {
	this.specialitiesManager = specialitiesManager;
	this.element = this.createElement();
	this.nameInput = null;
	this.descriptionInput = null;
}

NewSpecialityDOMRow.prototype.focus = function() {

	if (this.nameInput != null) {
		this.nameInput.focus();
	}
}
NewSpecialityDOMRow.prototype.saveSpeciality = function() {
	var changeHanlder = function() {
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

	this.specialitiesManager.saveSpeciality(new SpecialityDataObject(this.nameInput.val().trim(), this.descriptionInput.val().trim()), this);

}
NewSpecialityDOMRow.prototype.createElement = function() {
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
		cancelSymbol.bind("click", function() {
			instanceVar.element.remove();
		});
		okSymbol.bind("click", function() {
			instanceVar.saveSpeciality();
		});
	}

	return this.element;
}
/**
 * The DOM Table
 */
function SpecialitiesDOMTable(specialitiesManager) {
	this.table = this.createElement();
	this.specialitiesManager = specialitiesManager;

}

SpecialitiesDOMTable.prototype.addExistingRecord = function(specialityDOMRow) {
	this.table.find("tr:last").before(specialityDOMRow.element);

}
SpecialitiesDOMTable.prototype.makeRoomForNewRecord = function() {
	var row = new NewSpecialityDOMRow(this.specialitiesManager);
	this.table.find("tr:last").before(row.createElement());
	row.focus();
}
SpecialitiesDOMTable.prototype.createElement = function() {
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
		addNewExceptionLink.bind("click", function() {
			instanceVar.makeRoomForNewRecord();
			return false;
		});
		actionsRow.append(tdActionsCell);

		tableBody.append(actionsRow);

		this.table.append(tableBody);

	}

	return this.table;
}
