import processing.video.*;
import processing.net.*;

// Size of each cell in the grid, ratio of window size to video size
int videoScale = 10;
// Number of columns and rows in our system
int cols, rows;
// Variable to hold onto Capture object

import processing.serial.*;

// The serial port:
Serial myPort;



// Send a capital A out the serial port
//myPort.write(65);


String ledCol;
String ledWallMsg;

//Client myClient;
Capture video;

void setup() {
  size(70,160);
  
  // List all the available serial ports:
println(Serial.list());

// I know that the first port in the serial list on my mac
// is always my  Keyspan adaptor, so I open Serial.list()[0].
// Open whatever port is the one you're using.
myPort = new Serial(this, Serial.list()[0], 9600);
   //myClient = new Client(this, "127.0.0.1", 5204);
  // Initialize columns and rows
  cols = width/videoScale;
  rows = height/videoScale;
  video = new Capture(this,cols,rows,30);
}

void draw() {
  // Read image from the camera
  if (video.available()) {
    video.read();
  }
  video.loadPixels();
  
  
  ledWallMsg ="";
  // Begin loop for columns
  for (int i = 0; i < cols; i++) {
    // Begin loop for rows
    ledCol = "";
    for (int j = 0; j < rows; j++) {
      
      // Where are we, pixel-wise?
      int x = i*videoScale;
      int y = j*videoScale;
      // Looking up the appropriate color in the pixel array
      color c = video.pixels[i + j*video.width];
      //println("---------");
      //println(video.width);
      
      int value = (int)brightness(c);  // get the brightness
      fill(value);
      //println(hex(value/16,1));
      
      ledCol +=hex(value/16,1); 
      //fill(c);
      stroke(0);
      rect(x,y,videoScale,videoScale);
    }
   ledWallMsg += ledCol;
  }
  
  //send pix to the Led Wall
  println(ledWallMsg);
  myPort.write(ledWallMsg);
   //myClient.write(ledWallMsg);
   //Seri.write(ledWallMsg);
    delay(100);
}

