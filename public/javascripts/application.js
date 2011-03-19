// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function createElement(name){
    return $(document.createElement(name));
}

var autoCloseFashMessagesTime = 5000;

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

var flash_messages = {
	settings: {
		autoCloseFashMessagesTime: 5000,
		autoClose: true
	},
    timer: null,
	show: function(type, msg, options) {
		
		$.extend(flash_messages.settings, options);
		//if exists
		if ( $('#floating_message_wrapper') ) {
		  $('#floating_message_wrapper').remove();
		}
		fM = createElement("div").attr("id","floating_message_wrapper").addClass(type);
		innerEl = createElement("div").addClass("page_message");
		message = createElement("strong").html(msg);
		innerEl.append(message);
		fM.append(innerEl);
		closeC = createElement("div").addClass("page_message_close");
		closeA = createElement("a").attr("href","#").html("X");
		closeC.append(closeA);
		fM.append(closeC);
		closeA.bind("click", function() {
			
			flash_messages.close();
		});
      
	  	
		$("#page_errors_container").append(fM);
		//alert(msg);
		$("#floating_message_wrapper").trigger('float_message:loaded');
		$(window).trigger("scroll");
		
	},
    close_notice: function(){
        $('#notice_message').hide();
    },
    close: function(){
        $('#floating_message_wrapper').hide();
        
        
        if (flash_messages.timer != null) {
        
            clearInterval(flash_messages.timer);
        }
       
        
    },
	
    close_future: function(){
    
		if ( flash_messages.settings.autoClose ) {
			flash_messages.timer = window.setInterval(flash_messages.close, flash_messages.settings.autoCloseFashMessagesTime);	
		}
        
        
        
    },
   
	scroll: function(){
        element = $("#floating_message_wrapper");
        
		element.animate({
            top: $(window).scrollTop() + "px"
        }, {
            "duration": 100
        });
    }
}


var loading_indicator = {
    show: function(){
        $('#loading_indicator').show();
        
    },
    hide: function(){
        $('#loading_indicator').hide();
    },
    scroll: function(){
        element = $('#loading_indicator');
		
        element.animate({
            top: $(window).scrollTop() + "px"
        }, {
            "duration": 100
        });
    }
    
}
//Drop down menu stuff
var ddm = {
    start: function(){
        $(".ddm .ddm_title").live("click", function(){
            $(this).siblings("ul").toggle();
            
            return false;
        })
    },
    close: function(){
    
        $(".ddm .ddm_title").siblings("ul").hide();
    }
};
var form_utils = {
    focus_first_field: function(){
        $("[textarea||input]:visible:enabled:first").focus();
        
        //$("textarea:visible:enabled:first").focus();
        
        //try also on the on one that have errors
        
        $("div.field_with_errors").children("[textarea||input]:visible:enabled:first").focus();
        //$("div.field_with_errors textarea:visible:enabled:first").focus();
    	$(window).trigger("scroll");
    
    
    }
}

$(function(){
    ddm.start();
    form_utils.focus_first_field();
    $(window).click(function(){
        ddm.close()
    });
    $("*").live('ajax:beforeSend', function(){
        loading_indicator.show();
    });
    
    $("*").live('ajax:complete', function(){
        loading_indicator.hide();
    });
    
    $("#floating_message_wrapper").live("float_message:loaded", function(){
		
        flash_messages.close_future();
		loading_indicator.scroll();
    });
    
    $(window).scroll(function(){
        flash_messages.scroll();
        loading_indicator.scroll();
    });
    
    element = $("#floating_message_wrapper");
    
    if (element != null && element.html() != null) {
        flash_messages.close_future();
        flash_messages.scroll();
    };
    
    })

