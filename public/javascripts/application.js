// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var flash_messages = {

    timer: null,
    
    close: function(){
        $('#floating_message_wrapper').hide();
        
        
        if (flash_messages.timer != null) {
        
            clearInterval(flash_messages.timer);
        }
        else {
            console.log("times is null");
        }
        
    },
    close_future: function(){
    
        flash_messages.timer = window.setInterval(flash_messages.close, 5000);
        
        
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

$(function(){

    $("*").live('ajax:beforeSend', function(){
        loading_indicator.show();
    });
    
    $("*").live('ajax:complete', function(){
        loading_indicator.hide();
    });
    
    $("#floating_message_wrapper").live("float_message:loaded", function(){
        flash_messages.close_future();
        flash_messages.scroll();
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

