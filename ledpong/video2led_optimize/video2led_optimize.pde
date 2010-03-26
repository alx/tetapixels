// Processing to led Wall Fabrice Fourc. 2010
// tetalab.org


import processing.video.*;
import processing.net.*;

// Size of each cell in the grid, ratio of window size to video size
int videoScale = 10;
// Number of columns and rows in our system
int cols, rows;
// Variable to hold onto Capture object

String ledCol;
String ledWallMsg;

//message pour le mur
byte[] message;
byte bitFortbyte;
byte valueByte;

Client myClient;
Capture video;

void setup() {
 size(270,160);
 message = new byte[216];
  myClient = new Client(this, "127.0.0.1", 5204);
 // Initialize columns and rows
 cols = width/videoScale;
 rows = height/videoScale;
 video = new Capture(this,cols,rows,30);
}

void draw() {
 // Read image from the camera

 int t=0;
 boolean fort = true;
 int bitFort=0;

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

     if (fort) {
       bitFort=value;
       bitFortbyte=byte(value);
       fort=false;
     } else {
       message[t]=byte((bitFort+value/16));
       fort=true;
       t++;
       bitFort=0;
     }
     //fill(c);
     stroke(0);
     rect(x,y,videoScale,videoScale);
   }

  ledWallMsg += ledCol;
 }


 //send pix to the Led Wall
//println(ledWallMsg);
 println(message);

 myClient.write(message);
   delay(100);
}