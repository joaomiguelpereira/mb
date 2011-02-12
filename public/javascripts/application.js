// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var flash_messages = {
	
	close : function() {
		$('#floating_message_wrapper').hide();
	}, 
	close_future: function() {
		
		window.setInterval(flash_messages.close, 5000);
	}	
}


var loading_indicator = {
    show: function() {
		$('#loading_indicator').show();
		
	},
	hide: function() {
		$('#loading_indicator').hide();
	}	
}

$(function(){
	
	$("*").live( 'ajax:beforeSend', function() {
		loading_indicator.show();
	}),
	
		
	$("*").live( 'ajax:complete', function() {
		loading_indicator.hide();
	}), 
	
	$("#floating_message_wrapper").live("float_message:loaded", function() {
		flash_messages.close_future();
	}),
	element  =$("#floating_message_wrapper");
	if (element!=null) {
		flash_messages.close_future();
	}
	
})

