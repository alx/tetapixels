#include <Wire.h>

// code for max7313
// initial code from eric toering
// modification for driving a lot of MAX7313 boards Lionel D. 24/02/2010
// Protocol implementation Fabrice F. 13/03/2010
// READ THE MAX7313 DATASHEET !!!!

// Using the Wire library (created by Nicholas Zambetti)
// On the Arduino board, Analog In 4 is SDA, Analog In 5 is SCL


   void Send(byte addr, byte reg, byte data);
   byte address[] = {0x11, 0X12, 0x13, 0x14, 0x15, 0x16, 0x17};      // adresses of max chips
//   byte address[] = {0x11, 0X12, 0x13};      // adresses of max chips   
   int maxnb = 7;    // total nb of max7313
   int timer = 1; // timer used to slow down the full test (K2000 effect speed)
   int intensity = 0xff; // intensity
   int maxRow = 16;
   char serString[112]; // lenght of the serial message maxnb *16            


void setup()
{
  
Wire.begin(); // join i2c bus (address optional for master)
Serial.begin(115200); // (DEBUG)
  
//  print("check");
int maxindex; // index of array
for (int maxindex=0; maxindex < maxnb; maxindex++)
// Max 7313 - Init phase
  {
  Send(address[maxindex], 0xf, 0x10); // blink 0 aan, 0x10 is glob uit
  Send(address[maxindex], 0x6, 0x00); // input en output config.
  Send(address[maxindex], 0x7, 0x00); // oninterresante getallen, afblijven!!
  Send(address[maxindex], 0x2, 0xff); // global intensity reg.
  Send(address[maxindex], 0x3, 0xff);
  Send(address[maxindex], 0xe, 0xff); // config bit
  }
}



void loop()
{
  
  // Read the serial
  readSerialProtocol(serString);
  
  //Serial.print(serString);
  
  //string index to browse the serial string
  int stringIndex=0;
  // browse cols
  int maxindex; // index of array
   for (int maxindex=0; maxindex < maxnb; maxindex++){
         for (int row=0; row < maxRow; row++){    
                       // j'efface tout
                      //delay(timer);
              	      Send(address[maxindex], (0x10+(row/2)), 0xff);
         }
    }
  
  // browse cols
      for (int maxindex=0; maxindex < maxnb; maxindex++){    
       //browse rows
 //      int row;
       for (int row=0; row < maxRow; row++){
//               Serial.println(serString[stringIndex]);
               switch (serString[stringIndex]) {
               /*  case 'F':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x00);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0x00);
	              }
                      break;*/
                 case 'E':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x01);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0x10);
	              }
                      break;
                  case 'D':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x02);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0x20);
	              }
                      break;
                  case 'C':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x03);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0x30);
	              }
                      break;
                   case 'B':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x04);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0x40);
	              }
                      break;
                  case 'A':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x05);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0x50);
	              }
                      break;
                  case '9':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x06);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0x60);
	              }
                      break;
                  case '8':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x07);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0x70);
	              }
                      break;
                   case '7':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x08);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0x80);
	              }
                      break;
                  case '6':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x09);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0x90);
	              }
                      break;
                   case '5':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x0A);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0xA0);
	              }
                      break;
                  case '4':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x0B);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0x0B);
	              }
                      break;
                   case '3':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x0C);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0xC0);
	              }
                      break;
                  case '2':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x0D);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0xD0);
	              }
                      break;
                  case '1':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x0E);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0xE0);
	              }
                      break;
 /*                 case '0':
                      if ((row % 2)>0){
		          Send(address[maxindex], (0x10+(row / 2)), 0x0F);
                      } else {
              	          Send(address[maxindex], (0x10+(row / 2)), 0xF0);
	              }
                      break;*/
           
               }
          //next value for protocol string
          stringIndex++;
        }
  
    }
  
  //delay for debuging
  delay(10);
  
}

// Send I2C data
void Send(byte addr, byte reg, byte data)
{  

    Wire.beginTransmission(addr);
      Wire.send( reg);
      Wire.send( data);
     Wire.endTransmission();
}

// Read the protocol string from the serial and store it in an array
//you must supply the array variable
void readSerialProtocol (char *strArray) {
int i = 0;
if(!Serial.available()) {
return;
}
while (Serial.available()) {
strArray[i] = Serial.read();
i++;
}
}
