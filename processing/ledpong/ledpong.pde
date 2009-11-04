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
    if (whatClientSaid != null) {
      for(int row = 0; row < 16; row++) {
        for(int column = 0; column < 27; column++) {
          fill(color(0, int(whatClientSaid.charAt(row * column)) * 16));
          rect(column*10, row*10, 10, 10);
        }
      }
    }
   }
   delay(100);
    myClient.write("0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF");
    delay(100);
  }
 
void draw2(){  buffer_led = new char [432];
 
  for(int row = 0; row < 16; row++) {
    for(int column = 0; column < 27; column++) {
      int cell = int(random(0, 255));
      fill(color(0, cell));
      int arduino_value = int(cell/16);
      switch(arduino_value) {
        case 10:
          buffer_value = 'A';  // Does not execute
          break;
        case 11:
          buffer_value = 'B';  // Does not execute
          break;
        case 12:
          buffer_value = 'C';  // Does not execute
          break;
        case 13:
          buffer_value = 'D';  // Does not execute
          break;
        case 14:
          buffer_value = 'E';  // Does not execute
          break;
        case 15:
          buffer_value = 'F';  // Does not execute
          break;
        default:
          buffer_value = char(arduino_value);  // Does not execute
          break;
      }
      buffer_led[row * column] = buffer_value;
      rect(column*10, row*10, 10, 10);
    }
  }
  //println(new String(buffer_led));
  delay(20);
}

void draw_send()
{
  Client thisClient = myServer.available();

   if (thisClient !=null) {
    String whatClientSaid = thisClient.readString();
    if (whatClientSaid != null) {
      println(whatClientSaid);
    }
  }

 
  background(bg);
  noStroke();
 
  buffer_led = new char [432];
 
  for(int row = 0; row < 16; row++) {
    for(int column = 0; column < 27; column++) {
      int cell = int(random(0, 255));
      fill(color(0, cell));
      int arduino_value = int(cell/16);
      switch(arduino_value) {
        case 10:
          buffer_value = 'A';  // Does not execute
          break;
        case 11:
          buffer_value = 'B';  // Does not execute
          break;
        case 12:
          buffer_value = 'C';  // Does not execute
          break;
        case 13:
          buffer_value = 'D';  // Does not execute
          break;
        case 14:
          buffer_value = 'E';  // Does not execute
          break;
        case 15:
          buffer_value = 'F';  // Does not execute
          break;
        default:
          buffer_value = char(arduino_value);  // Does not execute
          break;
      }
      buffer_led[row * column] = buffer_value;
      rect(column*10, row*10, 10, 10);
    }
  }
  //println(new String(buffer_led));
  delay(20);
}
