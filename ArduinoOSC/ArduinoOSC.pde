import netP5.*;
import oscP5.*;
import themidibus.*;
import processing.serial.*;

NetAddress ProcessingAddress;
NetAddress MaxAddress;

Serial myPort;
OscP5 oscP5;
MidiBus myBus;

int val;
char incomingByte;
int port = 7000;
int lf = 10;
int value1 = 0; //this variable will contain the reading

void setup() {
  size(200, 200);
  MidiBus.list();
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil(lf); 
  oscP5 = new OscP5(this, port);
  myBus = new MidiBus(this, "Processing", "Processing");
  MaxAddress = new NetAddress("127.0.0.1", port);
}

void draw() {
  value1 = constrain(value1, 0, 254);
  print(value1);
  myBus.sendControllerChange(0, 10, value1);
  /*while (myPort.available() > 0) {
    int lf = 10;
    byte[] inBuffer = new byte[7];
    myPort.readBytesUntil(lf, inBuffer);
    if (inBuffer != null) {
      String myString = new String(inBuffer);
      //print(myString);
      float floatString = float(myString);
      if (Float.isNaN(floatString)){
      } else {
        float value = map(floatString, 0, 500, 0, 254);
        int val = int(value);
        val = constrain(val, 0, 254);
        //myBus.sendControllerChange(0, 10, int(val));
        //OscMessage message = new OscMessage("/composition/opacityandvolume");
        //message.add(1.0);
        //oscP5.send(message, MaxAddress);
      }
    }
  }*/
}

void serialEvent (Serial myPort) 
{
  // read serial buffer as string
  String myString = myPort.readString();
 
  // if we have any other bytes than linefeed
  if (myString != null) 
  {
    // trim crap
    myString = trim(myString);
    value1 = int(myString); //make string to integer
    println(value1);
  }
}
