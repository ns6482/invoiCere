$(function() {
	
	var projects = [
			{
				value: "test item @10.50/pack",
				item_description: "test item",
				cost: "10.50",
				item_type: "Pack"
			},
			{				
				value: "test item2 @11.50/single",
				item_description: "test item2",
				cost: "11.50",
				item_type: "Single"
			},
			{							
				value: "test item3 @12.50/hour",
				item_description: "test item3",
				cost: "12.50",
				item_type: "Hours"			
			}
		];

	
    var options = {
        source: "/items.json",
        dataType: "json",
        position: { my : "right top", at: "right bottom"},
        select: function( event, ui ) {
        		//alert(ui.item.desc);
        		
				val = $(this).attr('id');
				val = "#"+val.replace("item_description", "");
				
				$(val+"item_description").val(ui.item.item_description);
				$(val+"cost_cents").val(ui.item.cost);
				$(val+"item_type").val(ui.item.item_type);
				
				
				//item_description qty, cost, type
				//$( "#project" ).val( ui.item.label );
				//$( "#project-id" ).val( ui.item.value );
				//$( "#project-description" ).html( ui.item.desc );
				//$( "#project-icon" ).attr( "src", "images/" + ui.item.icon );

				return false;
			}

    };

    $(document).on("keydown.autocomplete", "input.item_description", function() {
    	
        $(this).autocomplete(options);        
    });
    });

/*$(function() {
	
	var projects = [
			{
				value: "test item @10.50/pack",
				item_description: "test item",
				cost: "10.50",
				item_type: "Pack"
			},
			{				
				value: "test item2 @11.50/single",
				item_description: "test item2",
				cost: "11.50",
				item_type: "Single"
			},
			{							
				value: "test item3 @12.50/hour",
				item_description: "test item3",
				cost: "12.50",
				item_type: "Hours"			
			}
		];

	
    var options = {
        source: "/items.json",
        dataType: "json",
        minLength: 0, 
        select: function( event, ui ) {
        		//alert(ui.item.desc);
				val = $(this).attr('id');
				val = "#"+val.replace("item_description", "");
				
				$(val+"item_description").val(ui.item.item_description);
				$(val+"cost").val(ui.item.cost);
				$(val+"item_type").val(ui.item.item_type);
				
				
				//item_description qty, cost, type
				//$( "#project" ).val( ui.item.label );
				//$( "#project-id" ).val( ui.item.value );
				//$( "#project-description" ).html( ui.item.desc );
				//$( "#project-icon" ).attr( "src", "images/" + ui.item.icon );

				return false;
			}

    };

    $("input.item_description").live("keydown.autocomplete", function() {
        $(this).autocomplete(options);        
    });
    });
    
  
/*
$(document).ready(function() {
	$('.typeahead').typeahead({
	name: 'items',
	prefetch: '/items.json',
	limit: 10
	});
  
});
*/

 
	

