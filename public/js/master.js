$('document').ready(function() {

	// load grid
	for(var i = 0; i < grid.length; i++) {
		if (grid.charAt(i) == '1'){
			$("#pixel-" + i).addClass('pixel_on');
		} else {
			$("#pixel-" + i).addClass('pixel_off');
		}
	}
	
	$('.pixel').click(function(){
		
		var pixel_id = this.id.split("-").pop();
		
		$.post("/pixel_switch", { 'pixel_id': pixel_id});
		
		switch_pixel("#" + this.id);
		
		get_updates();
	})
	
	function switch_pixel(pixel_id) {
		if($(pixel_id).hasClass('pixel_on')){
			$(pixel_id).removeClass('pixel_on');
			$(pixel_id).addClass('pixel_off');
		} else {
			$(pixel_id).removeClass('pixel_off');
			$(pixel_id).addClass('pixel_on');
		}
	}
	
	function get_udpates() {
		$.getJSON('/updates', {'timestamp', timestamp}, function(data) {
			$.each(data.pixels, function(i, pixel) {
				switch_pixel("#pixel" + pixel);
			});
		});
		timestamp = new Date().getTime();
	}
});