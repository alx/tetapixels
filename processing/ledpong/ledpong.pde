import processing.net.*;
Server myServer;


PImage bg;
int a;
char[] buffer_led;
char buffer_value;
Client myClient;

void setup() {
  myServer = new Server(this, 5204);
  size(270, 160);
  bg = loadImage("ledpong.gif");
  randomSeed(0);
 
  myClient = new Client(this, "127.0.0.1", 5204);
}

void draw()
{
 
  background(bg);
  noStroke();
  Client thisClient = myServer.available();

   if (thisClient !=null) {
    String whatClientSaid = thisClient.readString();
      
   // if (whatClientSaid != null) {
      
      for(int column = 0; column < 27; column++) {
        for(int row = 0; row < 17; row++) {
          println ("_________________________");
          //println (whatClientSaid);
          println(str(whatClientSaid.charAt((column*16+row))));
          
          int cell = unhex(str(whatClientSaid.charAt((column*16+row))));
          println ("column>"+column+"row>"+ row);
          println (cell);
          println ("--valeur--");
          println (cell);
          println ("--");
          fill(color(0, cell*16));
          println (cell);
          rect(column*10, row*10, 10, 10);
         // delay(100);
        }
      }
    //}
   }
   delay(100);
    myClient.write("0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF");
    delay(100);
  }
  
  
