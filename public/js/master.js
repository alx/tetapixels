var glider_id = 0;
var gliderIntervalId = 0;

function switch_pixel(pixel_id, val) {
	$("#" + pixel_id).removeClass();
	$("#" + pixel_id).addClass('pixel pixel_' + val);
	$.post("/pixel_switch", {'pixel_id': pixel_id, 'gradient': val});
}

function load_pixels(new_grid){
	for(var i = 0; i < new_grid.length; i++) {
		$("#" + i).addClass('pixel_' + new_grid.charAt(i));
	}
}

setInterval(function() {$.get("/grid", function(hex_grid){load_pixels(hex_grid);});}, 10000 );

function gliding(){
  var classes = $("#" + glider_id).attr("class");
  var intensity = classes.substring(classes.search(/\d+/i));
  
  var new_intensity = "0";
  var direction = "up";
  
  switch(intensity)
  {
  case "0":
    new_intensity = "F";
    direction = "down";
    break;
  case "1":
      new_intensity = "E";
      direction = "right";
    break;
  case "2":
      new_intensity = "D";
      direction = "left";
    break;
  case "3":
      new_intensity = "C";
      direction = "up";
    break;
  case "4":
      new_intensity = "B";
      direction = "down";
    break;
  case "5":
      new_intensity = "A";
      direction = "right";
    break;
  case "6":
      new_intensity = "9";
      direction = "left";
    break;
  case "7":
      new_intensity = "8";
      direction = "up";
    break;
  case "8":
      new_intensity = "7";
      direction = "down";
    break;
  case "9":
      new_intensity = "6";
      direction = "right";
    break;
  case "A":
      new_intensity = "5";
      direction = "left";
    break;
  case "B":
      new_intensity = "4";
      direction = "up";
    break;
  case "C":
      new_intensity = "3";
      direction = "down";
    break;
  case "D":
      new_intensity = "2";
      direction = "right";
    break;
  case "E":
      new_intensity = "1";
      direction = "left";
    break;
  case "F":
      new_intensity = "0";
      direction = "up";
    break;
  }
  
  $("#" + glider_id).removeClass("pixel_" + intensity).addClass("pixel_" + new_intensity);
  
  switch(direction)
  {
  case "up":
    if(glider_id % 16 == 0){
      glider_id += 16;
    } else {
      glider_id -= 1;
    }
    if(glider_id == 416){
      glider_id = 0;
    }
    break;
  case "down":
    if(glider_id % 16 == 15){
      glider_id -= 16;
    } else {
      glider_id += 1;
    }
    if(glider_id <= 0){
      glider_id = 431;
    }
    break;
  case "left":
    if(glider_id < 16){
      glider_id += (26*16);
    } else {
      glider_id -= 16;
    }
    break;
  case "right":
    if(glider_id > 416){
      glider_id -= (26*16);
    } else {
      glider_id += 16;
    }
    break;
  }
}

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
	
	$("#start_glider").click(function(){
	  gliderIntervalId = setInterval(function() {gliding();}, 10 );
	  $("#start_glider").hide();
	  $("#stop_glider").show();
	});
	
	$("#stop_glider").click(function(){
	  clearInterval ( gliderIntervalId );
	  $("#start_glider").show();
	  $("#stop_glider").hide();
	})
});