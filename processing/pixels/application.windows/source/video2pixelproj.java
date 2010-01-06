import processing.core.*; 
import processing.xml.*; 

import processing.video.*; 
import processing.net.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class video2pixelproj extends PApplet {




// Size of each cell in the grid, ratio of window size to video size
int videoScale = 10;
// Number of columns and rows in our system
int cols, rows;
// Variable to hold onto Capture object

String ledCol;
String ledWallMsg;

Client myClient;
Capture video;

public void setup() {
  size(800,600);
  
   //myClient = new Client(this, "127.0.0.1", 5204);
  // Initialize columns and rows
  cols = width/videoScale;
  rows = height/videoScale;
  video = new Capture(this,cols,rows,30);
}

public void draw() {
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
      int c = video.pixels[i + j*video.width];
     // println("---------");
     // println(video.width);
      
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
  //println(ledWallMsg);
   //myClient.write(ledWallMsg);
    delay(100);
}


  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--stop-color=#cccccc", "video2pixelproj" });
  }
}
