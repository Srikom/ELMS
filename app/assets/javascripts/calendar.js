
$(function(){
	function getDiff() {
        var from = $("#leave_application_start_date").val();
        var till = $("#leave_application_end_date").val();
        var c = from.split("/");
        beg = new Date(c[2], c[1] - 1, c[0]);
        var d = till.split("/");
        en = new Date(d[2], d[1] - 1, d[0]);
        var rest = (en - beg) / 86400000;
        var txt = rest == 0 ? "" : rest + " days"
        $("#res").text(txt);
        var start = $('#leave_application_start_date').datepicker('getDate');
        var end   = $('#leave_application_end_date').datepicker('getDate');
        var days   = (end - start)/1000/60/60/24;
        if (days > 30)
                confirm("Selected time period is of more than 1 month duration.Please select again!");
    }

	$("#leave_application_start_date").datepicker({
	dateFormat:"dd/mm/yy",
	showButtonPanel: true,
	changeMonth: true,
	changeYear: true,
	 showAnim: "fadeIn",
	  
	duration:"fast",
	stepMonths:0,
	minDate: 0,
	 onSelect: function (dateText, inst) {
            $("#leave_application_end_date").val(dateText);
            $("#leave_application_end_date").datepicker("option", "minDate", dateText);
            getDiff();
			}
});

$("#leave_application_end_date").datepicker({
	dateFormat:"dd/mm/yy",
	 showButtonPanel: true,
	changeMonth: true,
	changeYear: true,
	duration:"fast",
	stepMonths:0,
	minDate: 0,
	showAnim: "fadeIn",
	
    onSelect: getDiff
	
			});
});
 

