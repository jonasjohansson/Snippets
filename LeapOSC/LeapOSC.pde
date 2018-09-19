import de.voidplus.leapmotion.*;
import oscP5.*;
import netP5.*;
import controlP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
ControlP5 cp5;
LeapMotion leap;

boolean handIsPresent = false;
boolean mouseClicked = false;
final String ADDR = "127.0.0.1";
final int PORT = 7000;
final int FRAMERATE = 30;

// name, inMin, inMax, outMin, outMax, resetAverage, isEnabled, osc
// click on Gesture tab for more settings
Gesture handPosY = new Gesture("handPosY",0,200,1.0,0.0,true,true,"/composition/layers/3/video/effects/transform/positiony");
Gesture handRoll = new Gesture("handRoll",-180,180,1.0,0.0,true,false,"/composition/layers/1/clips/1/video/source/lines/rotation");
Gesture handGrab = new Gesture("handGrab",0,1,0.1,1.0,true,false,"/composition/layers/1/clips/1/video/source/lines/fuzzyness");

Gesture[] gestures = {handPosY,handRoll,handGrab};

void setup() {
  
  frameRate(30);
  size(240,400);
  
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress(ADDR,PORT);  
  leap = new LeapMotion(this);
  
  cp5 = new ControlP5(this);
  
  int size = 120;
  int offsetX = 10;
  int offsetY = 10;
  int min = -360;
  int max = 360;
    
  for (int i = 0; i < gestures.length; i++){
    
    Group g = cp5.addGroup("g"+i)
      .setPosition(10,size*i + 20)
      .setBackgroundColor(color(255,50))
      .setLabel(gestures[i].name);
      
    cp5.addSlider(gestures[i].name+"InMin")
      .setValue(gestures[i].inMin)
      .setPosition(offsetX,offsetY)
      .setRange(min,max)
      .setGroup("g"+i);
      
    cp5.addSlider(gestures[i].name+"InMax")
      .setValue(gestures[i].inMax)
      .setPosition(offsetX,offsetY*2)
      .setRange(min,max)
      .setGroup("g"+i);
    
    cp5.addSlider(gestures[i].name+"OutMin")
      .setValue(gestures[i].outMin)
      .setPosition(offsetX,offsetY*3)
      .setRange(gestures[i].outMin,gestures[i].outMax)
      .setGroup("g"+i);
      
    cp5.addSlider(gestures[i].name+"OutMax")
      .setValue(gestures[i].outMax)
      .setPosition(offsetX,offsetY*4)
      .setRange(gestures[i].outMin,gestures[i].outMax)
      .setGroup("g"+i);
      
    cp5.addToggle(gestures[i].name+"ResetAverage")
      .setPosition(offsetX,offsetY*5)
      .setSize(20,10)
      .setValue(gestures[i].resetAverage)
      .setGroup("g"+i);
      
    cp5.addToggle(gestures[i].name+"IsEnabled")
      .setPosition(offsetX+102,offsetY*5)
      .setSize(20,10)
      .setValue(gestures[i].isEnabled)
      .setGroup("g"+i);
  }
}

void draw() {
  
  background(0);

  for (Hand hand : leap.getHands ()) {
    
    handPosY.read(hand.getStabilizedPosition().y);
    handRoll.read(hand.getRoll());
    handGrab.read(hand.getGrabStrength());
    
    if (!handIsPresent) handIsPresent = true;
  }
  
  if (handIsPresent){
    for (int i = 0; i < gestures.length; i++){
      gestures[i].ramp();
    }
  } else {
    handIsPresent = false;
  }
  
}

void mouseClicked(){
  handIsPresent = true;
  for (int i = 0; i < gestures.length; i++){
    if (mouseClicked){
      gestures[i].read(gestures[i].inMin);
    } else {
      gestures[i].read(gestures[i].inMax);
    }
  }
  mouseClicked = !mouseClicked;
}

void sendMessage(String addr, float val){
  OscMessage myMessage = new OscMessage(addr);
  myMessage.add(val);
  oscP5.send(myMessage, myRemoteLocation);
}

void controlEvent(ControlEvent theEvent) {
  
  // get the controller name
  String controllerName = theEvent.getController().getName();

  // loop through all the gestures
  for (int i = 0; i < gestures.length; i++){
    
    // get current gesture
    Gesture gesture = gestures[i];
    
    // get gesture name
    String gestureName = gesture.name;
    
    // check if controller is related to gesture
    if (controllerName.contains(gestureName)){
      
      // get new gesture parameter value
      float val = theEvent.getController().getValue();
      
      // get name of parameter      
      String param = controllerName.substring(gestureName.length());

      switch (param){
        case "InMin":
          gesture.updateInMin(val);
          break;
        case ("InMax"):
          gesture.updateInMax(val);
          break;
        case ("OutMin"):
          gesture.updateOutMin(val);
          break;
        case ("OutMax"):
          gesture.updateOutMax(val);
          break;
        case ("ResetAverage"):
          gesture.updateResetAverage(parseBoolean(int(val)));
          break;
        case ("IsEnabled"):
          gesture.updateIsEnabled(parseBoolean(int(val)));
          break;
       }
    }
  }
}
