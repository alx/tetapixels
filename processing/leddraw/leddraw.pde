
import processing.net.*;


// Number of columns and rows in our system
int cols, rows;


String ledCol;
String ledWallMsg;

Client myClient;

void setup() {

    size( 270, 160);
   myClient = new Client(this, "127.0.0.1", 5204);
  // Initialize columns and rows
  cols = width/10;
  rows = height/10;
  
    // open video stream
   // opencv = new OpenCV( this );
   // opencv.capture( 270, 160 );
 background(255);
}

void draw() {

     fill (0); 
   //stroke(188, 178, 146); 
  if(mousePressed) { 
    line(mouseX, mouseY, pmouseX, pmouseY); 
    ellipse(mouseX, mouseY, 20,20); 
    fill (150, 100, 80, 50); 
    smooth(); 
    }


  
  
  //-----------------------------------------------------------------
  //--processing2ledWall
  //-----------------------------------------------------------------
  
  loadPixels();

  ledWallMsg ="";
  // Begin loop for columns
  for (int i = 0; i < cols; i++) {
    // Begin loop for rows
    ledCol = "";
    for (int j = 0; j < rows; j++) {
      
      // Where are we, pixel-wise?
      int x = i*10;
      int y = j*10;
      // Looking up the appropriate color in the pixel array
      color c = pixels[x+ y*270];
      int value = (int)brightness(c);  // get the brightness
      fill(value);
      //println(hex(value/16,1));
      
      ledCol += hex(value/16,1); 
      //fill(c);
      stroke(0);
      rect(x,y,10,10);
      
       
    }
   ledWallMsg += ledCol;
    updatePixels();
  }
 
  //send pix to the Led Wall
  println(ledWallMsg);
   myClient.write(ledWallMsg);
    delay(100);
  


}

