float speed   = 0.1;
boolean debug = true;

class Gesture {
  String name;
  float val;
  float oldVal;
  float inMin;
  float inMax;
  float outMin;
  float outMax;
  boolean resetAverage;
  boolean isEnabled;
  String osc;
  
  Gesture(String _name, float _inMin, float _inMax, float _outMin, float _outMax, boolean _resetAverage, boolean _isEnabled, String _osc){
    name = _name;
    this.updateInMin(_inMin);
    this.updateInMax(_inMax);
    this.updateOutMin(_outMin);
    this.updateOutMax(_outMax);
    resetAverage = _resetAverage;
    isEnabled = _isEnabled;
    osc = _osc;
  }
  
  void updateInMin(float val){
    this.inMin = val;
  }
  
  void updateInMax(float val){
    this.inMax = val;
  }
  
  void updateOutMin(float val){
    this.outMin = val;
  }
  
  void updateOutMax(float val){
    this.outMax = val;
  }
  
  void updateResetAverage(boolean val){
    this.resetAverage = val;
  }
  
  void updateIsEnabled(boolean val){
    this.isEnabled = val;
  }
  
  void read(float _val){
    if (debug) println(this.name," RAW: ",val);
    val = constrain(_val,this.inMin,this.inMax);
    val = map(val,this.inMin,this.inMax,this.outMin,this.outMax);
    if (debug) println(this.name," NEW: ",val);
    if (oldVal != val){
      oldVal = val;
      this.send();
    }
  }
  
  void ramp(){
    float average = (this.outMin+this.outMax)/2;
    if (this.val != average){
      if (this.resetAverage)
        this.val = lerp(this.val, average, speed);
      else
       this.val = lerp(this.val, this.outMin, speed);
        
      if (debug) println(this.name,": ",this.val);
      this.send();
    }
  }
  
  void send(){
      if (this.isEnabled)
        sendMessage(this.osc,this.val);
  }
}
