/******************************************************************************
 *  tetapong
 *  Tetalab
 *  November 14, 2009
 *
 *  Arduino controller to listen on serial port an wait for a particular string
 *	to be sent on the i2c chain.
 *
 *  Arduino analog input 5 - I2C SCL
 *  Arduino analog input 4 - I2C SDA
 *
 *  init code: http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1182959181
 *
 ******************************************************************************/
#include <Wire.h>

// Using the Wire library (created by Nicholas Zambetti)
void send(byte adres, byte reg, byte data);

byte chip_0 = 0x10;      // adresses of max chips
byte chip_1 = 0x11;

int intensity = 0xff;
byte chipdata = 0;

void setup()
{


  Wire.begin(); // join i2c bus (address optional for master)
  Serial.begin(9600);

	Serial.print("setup()");

  send(chip_0, 0xf, 0x10);			// blink 0 aan, 0x10 is glob uit
  send(chip_0, 0x6, 0x00);			// input en output config.
  send(chip_0, 0x7, 0x00);			// oninterresante getallen, afblijven!!
  send(chip_0, 0x2, 0xff);			// global intensity reg.
  send(chip_0, 0x3, 0xff);
  send(chip_0, 0xe, 0xff);			// config bit
  send(chip_1, 0xf, 0x10);			// blink 0 aan, 0x10 is glob uit
  send(chip_1, 0x6, 0x00);			// input en output config.
  send(chip_1, 0x7, 0x00);			// oninterresante getallen, afblijven!!
  send(chip_1, 0x2, 0xff);			// global intensity reg.
  send(chip_1, 0x3, 0xff);
  send(chip_1, 0xe, 0xff);			// config bit

  for (int i = 0x10; i < 0x17; i++){
      send(chip_0, i, 0x00);
      send(chip_1, i, 0x00);
  }
  Serial.println("check");
  delay(500);

  for (int i = 0x10; i < 0x17; i++){
      send(chip_0, i, 0xff);
      send(chip_1, i, 0xff);
  }
  delay(500);
}



void loop()
{
	/*  
	 * small routine for finding out how the adress pins are connected
	 */ 

	// for (int i = 0; i < 255; i++){
	// 	chip_0 = i;
	// 	send(chip_0, 0xf, 0x10);
	// 	send(chip_0, 0x6, 0x00);
	// 	send(chip_0, 0x7, 0x00);
	// 	send(chip_0, 0x2, 0xff);
	// 	send(chip_0, 0x3, 0xff);
	// 	send(chip_0, 0xe, 0xff);
	// 	send(chip_0, 0x10, 0x00);
	// 	send(chip_0, 0x11, 0x00);
	// 	send(chip_0, 0x12, 0x00);
	// 	send(chip_0, 0x13, 0x00);
	// 	send(chip_0, 0x14, 0x00);
	// 	send(chip_0, 0x15, 0x00);
	// 	send(chip_0, 0x16, 0x00);
	// 	send(chip_0, 0x17, 0x00);
	// 	Serial.println(i, DEC);
	// 	delay (5);
	// }
	// 
	// for (int i = 0; i < 255; i++){
	// 	chip_0 = i;
	// 	send(chip_0, 0xf, 0x10);
	// 	send(chip_0, 0x6, 0x00);
	// 	send(chip_0, 0x7, 0x00);
	// 	send(chip_0, 0x2, 0xff);
	// 	send(chip_0, 0x3, 0xff);
	// 	send(chip_0, 0xe, 0xff);
	// 	send(chip_0, 0x10, 0xff);
	// 	send(chip_0, 0x11, 0xff);
	// 	send(chip_0, 0x12, 0xff);
	// 	send(chip_0, 0x13, 0xff);
	// 	send(chip_0, 0x14, 0xff);
	// 	send(chip_0, 0x15, 0xff);
	// 	send(chip_0, 0x16, 0xff);
	// 	send(chip_0, 0x17, 0xff);
	// 	Serial.println(i, DEC);
	// 	delay (5);
	// }

	for (int y = 0; y < 5; y++){

		for (int i = 0; i < 16; i++){

			if ((i % 2)>0){
				send(chip_1, (0x10+(i / 2)), 0x0F);
      } else { 
				send(chip_1, (0x10+(i / 2)), 0xF0);
			}

			delay(60);
			send(chip_1, (0x10+(i / 2)), 0xFF);
		}

		for (int p = 0; p < 16; p++){

			int i = 15 - p;

			if ((i % 2)>0){
				send(chip_0, (0x10+(i / 2)), 0x0F);
      } else {
				send(chip_0, (0x10+(i / 2)), 0xF0);
			}

			delay(60);
			send(chip_0, (0x10+(i / 2)), 0xFF);
		}
	}  

	for (int x = 0; x< 5; x++){
		
		while (intensity > 0){
			for (int i = 0x10; i < 0x18; i++){
				send(chip_0, i, intensity);
				send(chip_1, i, intensity);
			}
			
			delay(40);
			intensity -= 0x11;
		}

		while (intensity  < 0xff){
			for (int i = 0x10; i < 0x18; i++){
				send(chip_0, i, intensity);
				send(chip_1, i, intensity);
			}
			delay(60);
			intensity += 0x11;
		}
	}
	
	for (int i = 16; i > 0; i--){
		if ((i % 2)>0){
			send(chip_1, (0x10+(i / 2)), 0x0F);
		} else {
			send(chip_1, (0x10+(i / 2)), 0xF0);
		}
		delay(50);
		send(chip_1, (0x10+(i / 2)), 0xFF);
	}

	for (int i = 0; i < 16; i++){
		if ((i % 2)>0){
			send(chip_0, (0x10+(i / 2)), 0x0F);
		} else {
			send(chip_0, (0x10+(i / 2)), 0xF0);
		}
		delay(80);
		send(chip_0, (0x10+(i / 2)), 0xFF);
	}
}

void send(byte adres, byte reg, byte data){
		
		Serial.print("send()");
		// small hint: stuur = dutch for send
		Wire.beginTransmission(adres);
		Serial.print("beginTransmission");
		Wire.send(reg);
		Wire.send(data);
		Wire.endTransmission();
		Serial.print("endTransmission");
}