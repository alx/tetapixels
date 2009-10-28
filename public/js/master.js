$('document').ready(function() {

	// load grid
	for(var i = 0; i < grid.length; i++) {
		$("#pixel-" + i).addClass('pixel_' + grid.charAt(i));
	}
	
	$('.pixel').click(function(){
		
		var pixel_id = this.id.split("-").pop();
		$.post("/pixel_switch", {pixel_id: pixel_id, gradient: $('#gradient').val()});
		switch_pixel("#" + this.id);
		
	});
	
	function switch_pixel(pixel_id) {
		$(pixel_id).removeClass();
		$(pixel_id).addClass('pixel pixel_' + $('#gradient').val());
	}
	
	function get_updates() {
		$.getJSON('updates', {'timestamp': timestamp}, function(data) {
			$.each(data.pixels,	 function(i, pixel) {
				switch_pixel("#pixel" + pixel);
			});
		});
		timestamp = new Date().getTime();
	}
	
	$('#rollback').click(function(){
		
		var limit = 20;
		var offset = 0;
		
		while($('#edit').attr("display") != 'none') {
			$.getJSON('last', {'limit': limit, 'offset': offset}, function(data) {
				$.each(data, function(i, pixel) {
					switch_pixel("#pixel" + pixel);
					setTimeout("",200);
				});
			});
			offset += limit;
		}
	});
});