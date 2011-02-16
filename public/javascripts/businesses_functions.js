/**
 * @author jpereira
 */
$(function(){
	
    $("#business_full_name").live("keyup", function(){
        short_name = this.value.replace(/\W/g, '').substring(0, 24).toLowerCase();
    	if ($("#business_short_name").is(':disabled') == false) 
		
            $("#business_short_name").val(short_name);
    });
	
	$("#bt_edit_business").live("click", function() {
		loading_indicator.show();
		$.getScript(this.href);
		return false;
	});
	
	$("#cancel_business_edit").live("click", function() {
		loading_indicator.show();
		$.getScript(this.href);
		return false;
	});
    
});


