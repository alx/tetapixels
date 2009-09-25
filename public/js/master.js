$('document').ready(function() {
	$('.pixel').click(function(){
		
		var pixel_id = this.id.split("-").pop();
		
		if($(this).hasClass('pixel_on')){
			$(this).removeClass('pixel_on');
			$(this).addClass('pixel_off');
			$.post("/pixel_off", { 'pixel_id': pixel_id});
		} else {
			$(this).removeClass('pixel_off');
			$(this).addClass('pixel_on');
			$.post("/pixel_on", { 'pixel_id': pixel_id});
		}
	})
});