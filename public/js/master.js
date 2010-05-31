var glider_id = 0;
var gliderIntervalId = 0;
var sequencerLine = 0;
var opacityArray = [1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0];

function showCircle(o, counter) {
  if (!$("#" + o).hasClass("pixel_0")){

    counter += 1;
  } else {
    this.stop();
  }
}

function sparkle(pixel){
  setTimeout(function(){fadeOut(pixel, 5)}, 100);
  setTimeout(function(){fadeIn(pixel, 5)}, 600);
}

function fadeOut(pixel, length){
  if(length == undefined){length = 16;}
  $.each(opacityArray.slice(16-length, length),
      function(index, color){
        setTimeout(function(){$(pixel).css({opacity: color});}, index * 100);
      }
  );
}

function fadeIn(pixel, length){
  if(length == undefined){length = 16;}
  $.each(opacityArray.reverse().slice(0, length),
    function(index, color){
      setTimeout(function(){$(pixel).css({opacity: color});}, index * 100);
    }
  );
}

function switch_pixel(pixel_id, val) {
	$("#" + pixel_id).removeClass();
	$("#" + pixel_id).addClass('pixel pixel_' + val);
	$.post("/pixel_switch", {'pixel_id': pixel_id, 'gradient': val});
}

function load_pixels(new_grid){
	for(var i = 0; i < new_grid.length; i++) {
		$("#" + i).css({opacity: 0});
	}
}

function sequence(){
  // for(i=0;i<16;i++){
  //   fadeOut($("#" + (i + sequencerLine)), 5);
  // }
  
  sequencerLine += 16;
  if(sequencerLine > 432){sequencerLine = 0;}
  
  for(i=0;i<16;i++){
    fadeIn($("#" + (i + sequencerLine)), 5);
  }
}

setInterval(function() {sequence()},10);

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
      new_intensity = "F";
      direction = "right";
    break;
  case "2":
      new_intensity = "F";
      direction = "left";
    break;
  case "3":
      new_intensity = "F";
      direction = "up";
    break;
  case "4":
      new_intensity = "A";
      direction = "down";
    break;
  case "5":
      new_intensity = "A";
      direction = "right";
    break;
  case "6":
      new_intensity = "A";
      direction = "left";
    break;
  case "7":
      new_intensity = "A";
      direction = "up";
    break;
  case "8":
      new_intensity = "6";
      direction = "down";
    break;
  case "9":
      new_intensity = "6";
      direction = "right";
    break;
  case "A":
      new_intensity = "6";
      direction = "right";
    break;
  case "B":
      new_intensity = "6";
      direction = "up";
    break;
  case "C":
      new_intensity = "0";
      direction = "gith";
    break;
  case "D":
      new_intensity = "0";
      direction = "right";
    break;
  case "E":
      new_intensity = "0";
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

    // var pixel_id = this.id.split("-").pop();
    // var color = $('#gradient').val();
    // 
    // // blank pixel if already this color
    // if($(this).is('.pixel_' + color)) {
    //  color = 0;
    // }
    // 
    // switch_pixel(pixel_id, color);
    //setInterval(sparkle($(this)), 1000);
    
    var o = parseInt(this.id);
    for(var i = 1; i <= 3; i++) {
      $.each([o-i, o+i, o-(16*i), o+(16*i)], function(index, value){
        fadeOut($("#" + value));
      });
  	}
	});
	
	$(".pixel").mouseenter(function(event){
    $(this).css({opacity: 1});
  });
	$(".pixel").mouseleave(function(event){
	  fadeOut($(this));
  });
	
	$("#start_glider").click(function(){
	  gliderIntervalId = setInterval(function() {gliding();}, 10 );
	  $("#start_glider").hide();
	  $("#stop_glider").show();
	});
	
	$("#stop_glider").click(function(){
	  clearInterval ( gliderIntervalId );
	  $("#start_glider").show();
	  $("#stop_glider").hide();
	});
	
	$(".pixel").css({opacity: 0});
});