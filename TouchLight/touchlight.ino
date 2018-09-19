/*

	TouchLight

	Use DS Touchscreen data to illuminate LOL-shield.
	Sends and receives data from i2c connected sibling.

	Created 23 sep 2014
	By Jonas Johansson
	Modified 10 oct 2014
	By Jonas Johansson

*/

#include <Charliplexing.h>
#include <TouchScreen.h>
#include <Wire.h>

#define Y1 A3 //YM
#define X2 A2 //XP
#define Y2 A1 //YP
#define X1 A0 //XM
#define MINPRESSURE 10
#define MAXPRESSURE 1000
#define COLS 14
#define ROWS 9
#define MIN_X 80
#define MAX_X 930
#define MIN_Y 840
#define MAX_Y 180
#define MIN_Z 350
#define MAX_Z 0
#define PULSE_DELAY 200

const uint8_t b = 7;
const uint8_t c = 100;
unsigned long start;
long dx0,dy0,dx1,dy1,dx2,dy2;
int x0,y0,z0,x1,y1,z1;
int d0,d1,d2;
int rad = 0;
byte x01,x02,y01,y02,z01,z02;
bool touching = false;
bool pulsate = false;

TouchScreen ts = TouchScreen(X2,Y2,X1,Y1,300);

struct Point {
	uint8_t brightness;
} points[COLS][ROWS];

void setup() {
	//Serial.begin(9600);
    LedSign::Init(GRAYSCALE);
	Wire.begin(5);
	Wire.onReceive(receiveEvent);
}

void loop() {
	TSPoint p = ts.getPoint();
	if (p.z > ts.pressureThreshhold) {
		x0 = map(p.x,MIN_X,MAX_X,0,COLS*c);
		y0 = map(p.y,MIN_Y,MAX_Y,0,ROWS*c);
		z0 = map(p.z,MIN_Z,MAX_Z,50,450);
		x01 = (byte) (x0 % 0xFF);
		x02 = (byte) ((x0 >> 8) & 0xFF);
		y01 = (byte) (y0 % 0xFF);
		y02 = (byte) ((y0 >> 8) & 0xFF);
		z01 = (byte) (z0 % 0xFF);
		z02 = (byte) ((z0 >> 8) & 0xFF);
		Wire.beginTransmission(5);
		Wire.write(x01);
		Wire.write(x02);
		Wire.write(y01);
		Wire.write(y02);
		Wire.write(z01);
		Wire.write(z02);
		Wire.endTransmission();
		touching = true;
		start = millis();
		/*Serial.print("\tX: "); Serial.print(p.x);
		Serial.print("\tY: "); Serial.print(p.y);
		Serial.print("\tZ: "); Serial.println(p.z);*/

	} else if (touching) {
		if (millis() - start > PULSE_DELAY) {
			touching = false;
			pulsate = true;
		}
	}
	for (uint8_t x = 0; x < COLS; x++) {
		for (uint8_t y = 0; y < ROWS; y++) {
			dx0 = x*c - x0;
			dy0 = y*c - y0;
			dx1 = x*c - x1;
			dy1 = y*c - y1;
			d0 = sqrt( (dx0*dx0) + (dy0*dy0) );
			d1 = sqrt( (dx1*dx1) + (dy1*dy1) );
			if (d0 < z0) points[x][y].brightness = (d0 * (1-b) ) / z0 + b;
			if (d1 < z1) points[x][y].brightness = (d1 * (1-b) ) / z1 + b;
			if ((d0 >= z0 || d1 >= z1) && points[x][y].brightness != 0) LedSign::Set(x,y,--points[x][y].brightness);
			/*if (pulsate) {
				dx2 = dx0*0.01;
				dy2 = dy0*0.01;
				d2 = sqrt( (dx2*dx2) + (dy2*dy2) );
				if (d2 == rad) {
					points[x][y].brightness = b;
				} else if (d2 < rad && points[x][y].brightness != 0) {
					LedSign::Set(x,y,--points[x][y].brightness);
				}
			}*/
			LedSign::Set(x,y,points[x][y].brightness);
		}
	}
	/*if (pulsate) {
		rad++;
		if (rad > (ROWS+COLS)) {
			rad = 0;
			pulsate = false;
		}
	}*/
}

void receiveEvent(int howMany) {
	while (Wire.available()) {
		x1 = Wire.read();
		x1 += Wire.read() << 8;
		y1 = Wire.read();
		y1 += Wire.read() << 8;
		z1 = Wire.read();
		z1 += Wire.read() << 8;
	}
}