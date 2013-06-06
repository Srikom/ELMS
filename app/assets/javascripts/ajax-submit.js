

$("form").on("submit", function(event) {
   
   		$('div.popup').append("<div class='loader'></div>");
   		form = $(this).validate();
   		if(form.valid() == false){
   			$('.loader').remove();
   		}

    });

