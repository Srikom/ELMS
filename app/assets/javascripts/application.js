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
//= require jqueryr
//= require jquery.ui.datepicker
//= require jquery_ujs
//= require_tree .





$(function(){

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
		var choice = $("#status_name").val();
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

	$('form#archive').submit(function(e){
		var choice = $("#status_name").val();
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

	
});
