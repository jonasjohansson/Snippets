import processing.serial.*;
import processing.sound.*;
import cc.arduino.*;

Arduino arduino;

String[] Files = {
  "airplane-landing_daniel_simion.mp3",
  "alien-spaceship_daniel_simion.mp3",
  "harley-davidson-daniel_simon.mp3",
  "heavy-rain-daniel_simon.mp3",
  "labrador-barking-daniel_simon.mp3",
  "muscle-car-daniel_simon.mp3",
  "old-car-engine_daniel_simion.mp3",
  "service-bell_daniel_simion.mp3",
  "sos-morse-code_daniel-simion.mp3",
  "van-sliding-door-daniel_simon.mp3"
};

SoundFile[] soundFiles = new SoundFile[Files.length];
int[] buttonStates = new int[Files.length];

void setup() {
  size(470, 280);

  arduino = new Arduino(this, "/dev/tty.usbmodem1461", 57600);
  
  for (int i = 0; i < Files.length; i++){
    soundFiles[i] = new SoundFile(this, Files[i]);
    arduino.pinMode(i, Arduino.INPUT);
    buttonStates[i] = 0;
  }
  
}

void draw() {
  for (int i = 0; i < Files.length; i++) {
    int newState = arduino.digitalRead(i);
    int oldState = buttonStates[i];
    if (newState != oldState){
      print("Button: "+i);
      print(" ");
      println("State: "+newState);
      if (newState == 1){
        playSound(i);
      } else {
        //stopSound(i);
      }
      buttonStates[i] = newState;
    }
  }
}

void playSound(int index){
  println("Play: "+Files[index]);
  soundFiles[index].play();
}

void stopSound(int index){
  println("Stop: "+Files[index]);
  soundFiles[index].stop();
}