import processing.net.*;

Client myClient;
PImage bg;
int a;
char[] buffer_led;
char buffer_value;

String IMG_PATH = new String("file:///Users/alx/dev/tetalab/pixels/simulator/ledpong.gif");
int PIXEL_WIDTH = 27;
int PIXEL_HEIGHT = 16;

void setup() {

	// Setup client on port 5204
	myClient = new Client(this, "127.0.0.1", 5204); 

	// Setup background image
	size(270, 160);
	bg = loadImage(IMG_PATH);

	// Setup random if we want to random display pixels
	randomSeed(0);
}

void draw() {

	background(bg);
	noStroke();

	if (myClient.available() > 0) { 
		// Read until we get a linefeed
		int byteCount = myClient.readBytesUntil(interesting, byteBuffer); 
		// Convert the byte array to a String
		String myString = new String(byteBuffer);
		// Display the string inside the pixel frame
		displayPixels(myString); 
	} 
}

void displayPixels(String pixels) {
	for(int row = 0; row < PIXEL_HEIGHT; row++) {
		for(int column = 0; column < PIXEL_WIDTH; column++) {
			fill(color(0, getPixelIntensity(pixels.charAt(row * column))));
			rect(column*10, row*10, 10, 10);
		}
	}
}

int getPixelIntensity(char pixel){

	int pixel_value = 0;

	switch(pixel) {
		case 'A':
		pixel_value = 10;
		break;
		case 'B':
		pixel_value = 11;
		break;
		case 'C':
		pixel_value = 12;
		break;
		case 'D':
		pixel_value = 13;
		break;
		case 'E':
		pixel_value = 14;
		break;
		case 'F':
		pixel_value = 15;
		break;
		default:
		pixel_value = int(pixel);
	}

	return (pixel_value * 16);
}