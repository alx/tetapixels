$('document').ready(function() {
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