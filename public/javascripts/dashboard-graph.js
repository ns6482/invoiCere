// Load the Visualization API and the piechart package.
google.load('visualization', '1.0', {'packages':['corechart']});
     
// Set a callback to run when the Google Visualization API is loaded.
google.setOnLoadCallback(drawChart);

// Callback that creates and populates a data table, 
  // instantiates the pie chart, passes in the data and
  // draws it.
  function drawChart() {
	$.getScript('/dashboard/show.js', function(data, textStatus){
   		console.log(data); //data returned
   		console.log(textStatus); //success
   		console.log('Load was performed.');
	});
  }