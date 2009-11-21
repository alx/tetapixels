/******************************************************************************
 *  tetapong
 *  Tetalab
 *  November 21, 2009
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

void i2c_send(byte adres, byte reg, byte data);
void parse_frame(char frame);

byte columns[] = {0x11, 0x14};      // adresses of max chips

int intensity = 0xff;


void setup() {
	Wire.begin(); // join i2c bus (address optional for master)
	Serial.begin(9600);

	//print("check");
	for(int i = 0; i < sizeof(columns); i++) {
		i2c_send(columns[i], 0xf, 0x10); // blink 0 aan, 0x10 is glob uit
		i2c_send(columns[i], 0x6, 0x00); // input en output config.
		i2c_send(columns[i], 0x7, 0x00); // oninterresante getallen, afblijven!!
		i2c_send(columns[i], 0x2, 0xff); // global intensity reg.
		i2c_send(columns[i], 0x3, 0xff);
		i2c_send(columns[i], 0xe, 0xff); // config bit
		
		
		for (int i = 0x10; i < 0x17; i++){
			i2c_send(columns[i], i, 0x00);
		}
		delay(500);
		
		for (int i = 0x10; i < 0x17; i++){
			i2c_send(columns[i], i, 0xff);
		}
		delay(500);
	}
}



void loop()
{
	int i = 0;
	char frame[432];
	while( Serial.available() && (i < 433) ) {
		frame[i++] = Serial.read();
	}
	parse_frame(frame);
}

void parse_frame(char frame[]) {
	for(int i = 0, current_column = 0; i < sizeof(frame); i++, current_column = i % 16){
		i2c_send(columns[current_column], i % 16, frame[i]);
	}
}

void i2c_send(byte adres, byte reg, byte data){  // small hint: stuur = dutch for send
	Wire.beginTransmission(adres);
	Wire.send(reg);
	Wire.send(data);
	Wire.endTransmission();
}