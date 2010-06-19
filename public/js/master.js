function switch_pixel(pixel_id, val) {
	$("#" + pixel_id).removeClass();
	$("#" + pixel_id).addClass('pixel pixel_' + val);
	$.post("/pixel_switch", {'pixel_id': pixel_id, 'gradient': val});
}

function load_pixels(new_grid){
	for(var i = 0; i < new_grid.length; i++) {
	  $("#" + i).removeClass().addClass('pixel pixel_' + new_grid.charAt(i));
	}
}

setInterval(function() {$.get("/grid", function(hex_grid){load_pixels(hex_grid);});}, 10000 );

$('document').ready(function() {
	
	$("#slider").slider({
		range: "min",
		min: 0,
		max: 15,
		value: 8,
		slide: function(event, ui) {
			value = ui.value;
			switch(value)
			{
			case 10:
			  value = 'A';
			  break;
			case 11:
			  value = 'B';
			  break;
			case 12:
			  value = 'C';
			  break;
			case 13:
			  value = 'D';
			  break;
			case 14:
			  value = 'E';
			  break;
			case 15:
			  value = 'F';
			  break;
			}
			$("#gradient").val(value);
			$("#sample").attr('src', "/images/" + value + ".gif");
		}
	});
	
	$('.pixel').click(function(){

		var pixel_id = this.id.split("-").pop();
		var color = $('#gradient').val();

		// blank pixel if already this color
		if($(this).is('.pixel_' + color)) {
			color = 0;
		}

		switch_pixel(pixel_id, color);

	});
	
	load_pixels(grid);
});