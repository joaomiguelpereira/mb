/**
 * @author jpereira
 */
/**
 * When edit_user is clicked
 *
 */
$(function(){
	$("#bt_edit_user").live("click", function() {
		loading_indicator.show();
		$.getScript(this.href);
		return false;
	});

	$("#cancel_user_edit").live("click", function() {
		loading_indicator.show();
		$.getScript(this.remote_url);
		return false;
	});
	
	
})
