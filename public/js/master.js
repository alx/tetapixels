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
		
		if($(this).hasClass('pixel_on')){
			$(this).removeClass('pixel_on');
			$(this).addClass('pixel_off');
		} else {
			$(this).removeClass('pixel_off');
			$(this).addClass('pixel_on');
		}	
			
	})
});