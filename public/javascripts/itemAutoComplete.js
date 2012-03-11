$(function() {
	
	var projects = [
			{
				value: "test item",
				item_description: "test item",
				qty: "1",
				cost: "10.50",
				item_type: "Pack"
			},
			{				
				value: "test item2",
				item_description: "test item2",
				qty: "2",
				cost: "11.50",
				item_type: "Single"
			},
			{							
				value: "test item3",
				item_description: "test item3",
				qty: "4",
				cost: "12.50",
				item_type: "Hours"			
			}
		];

	
    var options = {
        source: projects,
        minLength: 0, 
        select: function( event, ui ) {
        		//alert(ui.item.desc);
				val = $(this).attr('id');
				val = "#"+val.replace("item_description", "");
				
				$(val+"item_description").val(ui.item.item_description);
				$(val+"qty").val(ui.item.qty);
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
