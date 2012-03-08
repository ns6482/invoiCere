$(function() {
	
	var projects = [
			{
				value: "jquery",
				label: "jQuery",
				desc: "the write less, do more, JavaScript library",
				icon: "jquery_32x32.png"
			},
			{
				value: "jquery-ui",
				label: "jQuery UI",
				desc: "the official user interface library for jQuery",
				icon: "jqueryui_32x32.png"
			},
			{
				value: "sizzlejs",
				label: "Sizzle JS",
				desc: "a pure-JavaScript CSS selector engine",
				icon: "sizzlejs_32x32.png"
			}
		];

	
    var options = {
        source: projects,
        minLength: 1
    };

    $("input.item_description").live("keydown.autocomplete", function() {
        $(this).autocomplete(options);
        //alert($(this.id));
    });
    });
