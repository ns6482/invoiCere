$(function() {
		var items = [
			{
				name: "test 1",
				description: "test desc 1",
				unit: "hours",
				price: 1
			},
			{
				name: "test 2",
				description: "test desc 2",
				unit: "hours 2",
				price: 2
			}];
		
		$( ".item_description" ).autocomplete({
			minLength: 0,
			source: items,
			focus: function( event, ui ) {
				$( ".item_description" ).val( ui.item.name );
				return false;
			},
			select: function( event, ui ) {
				//$( "#project" ).val( ui.item.label );
				//$( "#project-id" ).val( ui.item.value );
				$( ".item_description" ).val( ui.item.description );
				//$( "#project-icon" ).attr( "src", "images/" + ui.item.icon );
				return false;
			}
		})
		//.data( "autocomplete" )._renderItem = function( ul, item ) {
		//	return $( "<li></li>" )
		//		.data( "item.autocomplete", item )
		//		.append( "<a>" + item.label + "<br>" + item.desc + "</a>" )
		//		.appendTo( ul );
		//};

});
