

$("form").on("submit", function(event) {
    var label = $("label.error").is(':empty');
    if (label) {
   		$('div.popup').append("<div class='loader'></div>");
	}
    });


