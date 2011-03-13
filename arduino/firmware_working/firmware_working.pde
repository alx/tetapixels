#include <Wire.h>

// code for max7313
// initial code from eric toering
// modification for driving a lot of MAX7313 boards Lionel D. 24/02/2010
// Protocol implementation Fabrice F. 13/03/2010
// READ THE MAX7313 DATASHEET !!!!

// Using the Wire library (created by Nicholas Zambetti)
// On the Arduino board, Analog In 4 is SDA, Analog In 5 is SCL


void Send(byte addr, byte reg, byte data);
byte address[] = {
  0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F};
//byte address[] = {0x1B,0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F};
// adresses of max chips
//   byte address[] = {0x11, 0X12, 0x13};      // adresses of max chips
int maxnb = 27;    // total nb of max7313
int timer = 1; // timer used to slow down the full test (K2000 effect speed)
int intensity = 0xff; // intensity
int maxRow = 16;
char serString[433]; // lenght of the serial message maxnb *16
int valid = 0;
long randNumber;

void setup()
{

  Wire.begin(); // join i2c bus (address optional for master)
  //Serial.begin(115200); // (DEBUG)
  Serial.begin(38400); // (DEBUG)

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
  
  randomSeed(analogRead(0));
}



void loop()
{

  // Read the serial
  // readSerialProtocol(serString);
  

  //Serial.print(serString);

  //string index to browse the serial string
  int stringIndex=0;
  // browse cols
  int maxindex; // index of array
  /**
   * if ( valid == 0 ) {
   * for (int maxindex=0; maxindex < maxnb; maxindex++){
   * for (int row=0; row < maxRow; row++){
   * // j'efface tout
   * //delay(timer);
   * Send(address[maxindex], (0x10+(row/2)), 0xff);
   * }
   * }
   * return;
   * }
  /**/

  byte colData[8];
  byte Pos1;
  byte Pos2;
  int k=0;
  int t =0;
  boolean fort=true;

  // browse cols
  for (int maxindex=0; maxindex < maxnb; maxindex++){
    //browse rows

    for (int row=0; row < maxRow; row++){
      // Serial.println(serString[stringIndex]);
      //boucle sur les string index



      if (fort){
        Pos1=serString[stringIndex];
        fort=false;
        k++;
      }
      else{
        k++;
        //Serial.print(k,DEC);
        Pos2=serString[stringIndex];
        //Serial.print("pos1:");
        //Serial.println(Pos1,HEX);
        //Serial.print("pos2:");
        //Serial.println(Pos2,HEX);
        colData[t]=Read2HEXtoDEC(Pos1,Pos2);

        fort=true;
        t++;
      }
      stringIndex++;
    }
    //SendCol(address[maxindex], 0x10, colData);
    
    if(random(1) == 1){
      SendCol(address[maxindex], 0x10, "F");
    } else {
      SendCol(address[maxindex], 0x10, "0");
    }
    t=0;
  }

  //delay for debugging
  //delay(10);

}

// Send I2C data
void SendCol(byte addr, byte reg, byte colData[])
{

  Wire.beginTransmission(addr);
  Wire.send( reg);
  //     Serial.print("Maxaddress :");
  //     Serial.print(addr,HEX); // debug


    for (int i=0;i<8;i++){
    Wire.send( colData[i]);
    //     Serial.println(i,DEC); // debug
    //     Serial.print("< N Ligne / HEX Value : ");
    //     Serial.println(colData[i],HEX); // debug
  }
  Wire.endTransmission();
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
  int i = 0, c;
  int sync = 0;
  if(!Serial.available()) {
    return;
  }

  while (i < 432) {
    if (!Serial.available())
      continue;
    c = Serial.read();
    if (sync == 0) {
      if (c != 'Z') {
        //Serial.write('R');
        //Serial.write(c);
        continue;
      }
      //Serial.write('S');
      sync = 1;
      continue;
    }
    /**
    if (!((c >= 65 && c <= 70) || (c >= 48 && c <= 57))) {
      Serial.write('!');
      Serial.write(c);
      Serial.write('!');
    }
    /**/
    strArray[i++] = c;
  }
}

// Reads a 2 byte HEX from the serial port and converts it to DEC
// The incomming data stream is build up as follows
// Example:  15 06      A3      FF      00      ... etc.

int Read2HEXtoDEC(byte Pos2,byte Pos1)
{

  // Now convert the HEX to DEC

  int DECval = 0;

  if(Pos2 <= 57) // Convert Pos2 from 16 base to 10 base
  {
    DECval = DECval + Pos2-48;
  }
  else
  {
    DECval = DECval + Pos2-55;
  }

  if(Pos1 <= 57) // Convert Pos1 from 16 base to 10 base
  {
    DECval = DECval + 16*(Pos1-48);
  }
  else
  {
    DECval = DECval + 16*(Pos1-55);
  }

  return ~DECval;
}
