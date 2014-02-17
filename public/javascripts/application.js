/*
jQuery.ajaxSetup({
    'beforeSend': function(xhr) {
        xhr.setRequestHeader("Accept",
            "text/javascript")
    }
})
*/

jQuery(function() {
    
    $("#filter_box").hide();
    
    $('#filter_link').click(
    function() {
        $("#filter_box").toggle(function () {
           
            });
    });

});

/*
jQuery.fn.submitWithAjax = function() {
    this.submit(function() {
        $.post(this.action, $(this).serialize(), null, "script");
        return false;
    })
    return this;
};
*/

//$(function() {
//    $( "#print-invoice" ).button({
//        text: true,
//        icons: {
//            primary: "ui-icon-print"
//        }
//    })
//    $( "#pdf-invoice" ).button({
//        text: true,
//        icons: {
//            primary: "ui-icon-print"
//        }
//    })
//    $( "#edit-invoice" ).button({
//        text: true,
//        icons: {
//            primary: "ui-icon-pencil"
//        }
//    })
//    $( "#reminder-invoice" ).button({
//        text: true,
//        icons: {
//            primary: "ui-icon-clock"
//        }
//    })
//    $( "#edit-invoice" ).button({
//        text: true,
//        icons: {
//            primary: "ui-icon-pencil"
//        }
//    })
//    $( "#email-invoice" ).button({
//        text: true,
//        icons: {
//            primary: "ui-icon-mail-closed"
//        }
//    })
//
//    $( "#comment-invoice" ).button({
//        text: true,
//        icons: {
//            primary: "ui-icon-comment"
//        }
//    })
//});


$(document).ready(function() {

      // Notice the use of the each() method to acquire access to each elements attributes
    $('#toolbar a[tooltip]').each(function()
    {
       $(this).qtip({
         content: $(this).attr('tooltip'), // Use the tooltip attribute of the element for the content
         style: 'dark' // Give it a crea mstyle to make it stand out
      });
    });


    $(function()
    {
	$('.scroll-pane').jScrollPane({showArrows: true});
    });
      
    //set timer for flash
    setTimeout(hideFlashes, 10);

    // Change all select helpers to use ajax
    $('select.order_by, select.order_as, select.page, select.per_page').live('click',function() {
        var onchange = $(this).attr('onchange').toString();
        var matches = onchange.match(/window\.location = "(.*)" \+ this/);
        var url = matches[matches.length - 1];
        $(this).attr('onchange', null)
        $(this).change(function() {
            $.get(url + $(this).val(), null, null, 'script');
         
            //$('#invoices').load(url + $(this).val());
            return false;
        })
    })

    // Change all link helpers to use ajax
    $('a.ordering, a.descending, a.ascending, .pagination a, a.calendar_month').live('click', function() {
        //$('#invoices').load(this.href);
        $.get(this.href, null, null, 'script');       
        return false;
    })

    $('a.interactive').live('click', function() {

      $('#load').remove();
      $('#toolbar').append('<span id="load"><IMG SRC="/images/ajax-loading.gif"> </span>');
      $('#load').fadeIn('normal');

      $.get(this.href, show_interactive, null, 'script');
      return false;
    })

    function show_interactive() {         
         $('#interactive').show('normal',hideLoader());
         $("button").button();         
    }
    
    function hideLoader() {
        //alert('hide loader');
     $('#load').fadeOut('normal');
    }

    function showLoader() {
        //alert('hide loader');
     $('#load').fadeIn('normal');
    }
    
    // Change our reminder form to ajax
    
    //$('#interactive').hide();
    /*
    $('.ajax_form').live('submit', function()
    {
        var options = {

            beforeSubmit:  showLoader(),
            error: function(request, errorType) {
                $('#interactive').html(request.responseText).find('form').addClass('ajax_form');
                hideLoader();
            },
            success:    function() { 
                $('#interactive').hide('normal', function(){$(".notice").fadeOut(4000);});
                hideLoader();
            } 
        }

        $(this).ajaxSubmit(options);
       
        return false;
    }
        
    );
*/
       // Notice the use of the each() method to acquire access to each elements attributes
//   $('a[tooltip]').each(function()
//   {
//      $(this).qtip({
//         content: $(this).attr('tooltip'), // Use the tooltip attribute of the element for the content
//         style: 'dark' // Give it a crea mstyle to make it stand out
//      });
//   });



    $('#reminder_default_message').live('click', function()
    {

        if (this.checked){
            $("#reminder_custom_message_input").fadeOut(800);
        }
        else {
            $("#reminder_custom_message_input").fadeIn(800);
        }

    }

    );


    $('#schedule_default_message').live('click', function()
    {

        if (this.checked){
            $("#schedule_custom_message_input").fadeOut(800);
        }
        else {
            $("#schedule_custom_message_input").fadeIn(800);
        }

    }

    );

    

    
             
});

var hideFlashes = function() {
    $('p.notice, p.warning, p.error').fadeOut(3000);
}


$.fn.stars = function() {
    return $(this).each(function() {
        // Get the value
        var val = parseFloat($(this).html());
        // Make sure that the value is in 0 - 5 range, multiply to get width
        var size = Math.max(0, (Math.min(5, val))) * 16;
        // Create stars holder
        var $span = $('<span />').width(size);
        // Replace the numerical value with stars
        $(this).html($span);
    });
}

$(function() {
    $('span.stars').stars();
});




