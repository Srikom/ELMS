$(document).ready(function(){
$(function(){
	$("#leave_application_start_date").datepicker({
	dateFormat:"dd/mm/yy",
	changeMonth: true,
	changeYear: true,
	duration:"fast",
	stepMonths:0,
	minDate: 0 ,
	showButtonPanel:true
			});
});
$(function(){
$("#leave_application_end_date").datepicker({
	dateFormat:"dd/mm/yy",
	changeMonth: true,
	changeYear: true,
	duration:"fast",
	stepMonths:0,
	minDate: 0 
	showButtonPanel:true
			});
});
 

$('submit_btn').click(function() {
	$("#myForm").submit();
        var start = $('#leave_application_start_date').datepicker('getDate');
        var end   = $('#leave_application_end_date').datepicker('getDate');
        var days   = (end - start)/1000/60/60/24;
        alert(days);
        if ((end - start) > 30)
                confirm("Selected time period is of more than 1 month duration");

    });
});