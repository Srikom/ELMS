// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.validate.min
//= require jquery.ui.datepicker
//= require jquery_ujs
//= require_tree .




$(function(){

	reg_employee();
 	login_employee();
 	new_app_val();
	edit_leave_app();


	 

 	
	$("div#empLeave").delegate("span#day","click",function(e){
		
		var date = $(this).data("date");
		var id = "#y_"+date;
      	var newID = id.replace("#","");
      	$('a.overlay').attr('id', newID);
      	
		window.location.href = id;
		ajax_c(date);
		new_app_val();
	});

	

	$("body").delegate("a.overlay_new, a.close_new","click",function(){
		$('form#new_leave_application')[0].reset();
		$('label.error').remove();
	});


	$('#empLeave').delegate('#selection option','click',function(){
		$('a.overlay').fadeIn(1000);
	});

	$('#empLeave').delegate('#selection option','mouseleave',function(){
		$(this).removeAttr("selected");
		$('a.overlay').attr('id', 'info');
	});

	$('#empLeave').delegate('#selection option','mouseenter',function(){
		$("div.popup").hide();
		$(this).removeAttr("selected");
		var id = $(this).val();
      	var newID = id.replace("#","");
      	$('a.overlay').attr('id', newID);      	
	});

	function showApplicationDetail(e){
		e.preventDefault();
		var id = $(this).val();
      	var newID = id.replace("#","");
      	var lid = parseInt($(this).data("lid"));
      	var eid = parseInt($(this).data("eid"));
      	var sid = parseInt($(this).data("sid"));
      	var did = parseInt($(this).data("did"));
      	var sd = $(this).data("sd");
      	var ed = $(this).data("ed");
      	var date = $(this).data("date");
      	ajaxCall(lid,eid,sid,did,sd,ed,date);
	}

	function ajaxCall(lid,eid,sid,did,sd,ed,date){
		$.ajax({
				type: "POST",
				timeout: 10000,
      			url: "/leave_applications/showDetails",
      			data: {lid:lid,eid:eid,sid:sid,did:did,sd:sd,ed:ed,dt:date},
      			success: function(data){
      				$("div.popup").html(data);
      				$("div.popup").slideDown("normal");
      			},
      			error:function(){
      				alert("An error has occured!");
      			}
      	});
	}



	$('#empLeave').delegate('#selection option','click change',showApplicationDetail);

	$('#notice').fadeOut(4000);
	$('#alert').fadeOut(4000);
	$('#rangeS').datepicker();
	$('#rangeE').datepicker();

	$("#showL").click(function(){
		$("#right").fadeIn(1000);
		$(this).fadeOut();
	});

	$("#right").click(function(){
		$("#showL").fadeIn(1000);
		$(this).fadeOut();
	})

	$('form#formStat').submit(function(e){
		$.ajax({
				url: "/leave_applications/show_status",
				data: $(this).serialize(),
				beforeSend: function(){
					$('div#x').append("<div class='loader'></div>");
				},
				success: function(){
					$('.loader').remove();
				},
				dataType: 'script'
		});
		e.preventDefault();
	});

	$('form#edit_leave_application').on('ajax:before', function() {
        $('div.popup').append("<div class='loader'></div>");
    });

	$('form#archive').submit(function(e){
		$.ajax({
				url: "/leave_applications/archive",
				data: $(this).serialize(),
				beforeSend: function(){
					$('div#x').append("<div class='loader'></div>");
				},
				success: function(){
					$('.loader').remove();
				},
				dataType: 'script'
		});
		e.preventDefault();
	});

function getDiff() {
	  
        var start = $('#leave_application_start_date').datepicker('getDate');
        var end   = $('#leave_application_end_date').datepicker('getDate');
        var dayDiff = Math.ceil((end - start) / (1000 * 60 * 60 * 24));

        if(start != null && end != null){
        if (dayDiff > 30){
                confirm("Selected time period is of more than 1 month duration.Please select again!");
                $("input[type=submit]").attr("disabled", "disabled");
        }else if(dayDiff < 0){
        		confirm("End date cannot be before the start date!");
        		$("input[type=submit]").attr("disabled", "disabled");
        }else{
        $("input[type=submit]").removeAttr("disabled"); 
    }
}
    }

 function saturdayAndSunday(date){
 		var day=date.getDay();
 	   	return [(day != 0 && day != 6), ''];
 }

$('body').on('click', '#leave_application_start_date', function(event) {
		$(this).datepicker({
		beforeShowDay: saturdayAndSunday,
		dateFormat: 'yy-mm-dd',
		showButtonPanel: true,
		changeMonth: true,
		changeYear: true,
		 showAnim: "fadeIn",
		  
		duration:"fast",
		stepMonths:0,
		minDate: 0,
		 onSelect: function (dateText, inst) {
		 		$('#leave_application_end_date').val(dateText);
	            getDiff();
				}
	}).focus();
});


$('body').on('click', '#leave_application_end_date', function(event) {
	$(this).datepicker({
		beforeShowDay: saturdayAndSunday,
		dateFormat: 'yy-mm-dd',
		 showButtonPanel: true,
		changeMonth: true,
		changeYear: true,
		duration:"fast",
		stepMonths:0,
		minDate: 0,
		showAnim: "fadeIn",
		
	    onSelect: getDiff
		
				}).focus();
});

 	

});


function ajax_c(date){

	$.ajax({
				url: "/leave_applications/new",
				data: {dt:date},
				async: false,
				success: function(data){
					$("div.popup").html(data);
					$("a.overlay").show();
      				$("div.popup").slideDown("normal");
      				
				}
		});
}


function login_employee(){

	$("form#new_employee").validate({
		rules: {
				"employee[email]" : {
					required: true,
					email:true
	
				},
				"employee[password]" : {
					required: true,
				},
				errorPlacement: function(error, element) {
                 error.appendTo(element.parents('div#acc'));
           		 }
			},
		messages: {
			"employee[email]" :{
				required: "Please enter email",
				email: "Your email address must be in the format of name@domain.com"
			},
			"employee[password]" : {
					required: "Please enter password",
			}
		}
	});

}

function edit_leave_app(){

	$.validator.addMethod(
    "formatDate",
    function(value, element) {
        // put your own logic here, this is just a (crappy) example
        return value.match(/^\d\d\d\d?\-\d\d?\-\d\d$/);
    },
    "Please enter a date in the format yyyy-mm-dd."
);


	$("form.edit_leave_application").validate({
		rules: {

				"leave_application[start_date]" : {
					required: true,
					date: true,
					formatDate: true
				},

				"leave_application[end_date]" : {
					required: true,
					date: true,
					formatDate: true
				},

				"leave_application[leave_id]" : {
					required: true
				},

				"leave_application[reason]" : {
					required: true,
					minlength: 10
				}

			},
		messages: {

				"leave_application[start_date]" : {
					required: "Please enter the starting date of your leave",
					date: "Please enter a valid date"
				},

				"leave_application[end_date]" : {
					required: "Please enter the ending date of your leave",
					date: "Please enter a valid date"
				},

				"leave_application[leave_id]" : {
					required: "Please enter your leave type"
				},

				"leave_application[reason]" : {
					required: "Please enter your reason of taking leave",
				}

		}
	});


}

function reg_employee(){

	jQuery.validator.addMethod("accept", function(value, element, param) {
  return value.match(new RegExp("." + param + "$"));
});

	$("form#reg_employee").validate({
		rules: {
				"employee[name]" :{
					required: true,
					minlength: 3,
					accept: "[a-zA-Z]+" 
				},
				"employee[email]" : {
					required: true,
					email:true
				},
				"employee[password]" : {
					required: true,
					minlength: 6
				},
				"employee[password_confirmation]": {
					required: true,
					minlength: 6,
					equalTo: "#employee_password"
				},
				"employee[department_id]": {
					required: true
				},
				"employee[role_id]": {
					required: true
				},
				"employee[phone]": {
					required: true,
					digits: true
				},
				"employee[email]": {
					required: true,
					email: true
				}
			},
		messages: {
			"employee[name]" :{
				required: "Please enter name",
				accept: "Enter only letters"
			},
			"employee[email]" :{
				required: "Please enter email",
				email: "Your email address must be in the format of name@domain.com"
			},
			"employee[password]" : {
				required: "Please enter password"
			},
			"employee[password_confirmation]": {
				required: "Please enter password for confirmation",
				equalTo: "Password does not match"
			},
			"employee[department_id]": {
				required: "Please enter department"
			},
			"employee[role_id]": {
				required: "Please enter role"
			},
			"employee[phone]": {
				required: "Please enter phone number"
			},
			"employee[email]": {
				required: "Please enter email",
				email: "Your email address must be in the format of name@domain.com"
			}
		}
	});

}


function new_app_val(){

	$.validator.addMethod(
    "formatDate",
    function(value, element) {
        // put your own logic here, this is just a (crappy) example
        return value.match(/^\d\d\d\d?\-\d\d?\-\d\d$/);
    },
    "Please enter a date in the format yyyy-mm-dd."
);

	$("form#new_leave_application").validate({
		rules: {

				"leave_application[start_date]" : {
					required: true,
					date: true,
					formatDate: true
				},

				"leave_application[end_date]" : {
					required: true,
					date: true,
					formatDate: true
				},

				"leave_application[leave_id]" : {
					required: true
				},

				"leave_application[reason]" : {
					required: true,
					minlength: 10
				}

			},
		messages: {

				"leave_application[start_date]" : {
					required: "Please enter the starting date of your leave",
					date: "Please enter a valid date"
				},

				"leave_application[end_date]" : {
					required: "Please enter the ending date of your leave",
					date: "Please enter a valid date"
				},

				"leave_application[leave_id]" : {
					required: "Please enter your leave type"
				},

				"leave_application[reason]" : {
					required: "Please enter your reason of taking leave",
				}

		}
	});

}