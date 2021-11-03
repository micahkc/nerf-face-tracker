//middle 120, top 90, bottom 140
//middle 100, left 135, right 65
#include <Servo.h>
Servo trigger;
Servo yServo;
Servo xServo;
int xPos = 100;
int yPos = 90;
int xIn = 0;
int yIn = 0;
int lastYin;
int lastXin;
bool fired = false, firing = false;
long int firedTime;
int c = 0,v = 0;
bool negative = false;

void setup() {
  Serial.begin(9600);
  trigger.attach(9);
  xServo.attach(10);
  yServo.attach(11);

  xServo.write(xPos);
  yServo.write(yPos);
  trigger.write(0);
}

void loop() {
  getData();
  //updateServoValues();
  moveNerf();
  checkTrigger();

}

void getData(){
  while (Serial.available()) {
    c = Serial.read();
    if ((c >= '0') && (c <= '9')) {
      v = 10 * v + c - '0';
    }
    else if (c == 'x') {
      xIn = v;
      v = 0;
      
    }
    else if (c == 'y'){
      yIn = v;
      v = 0;
      updateServoValues();
    }
  }
  
}

void updateServoValues(){
  xIn -= 320;
  if (abs(xIn) < 50 && !fired){
    firedTime = millis();
    firing = true;
    fired = true;
  }
  if(xIn > 0){
    if (xIn > 30){
      xPos-=3;
    }
    else{
      xPos-=1;
    }
  }
  else if(xIn <=0){
    if(xIn < -30){
      xPos+=3;
    }
    else{
      xPos+=1;
    }
  }
  
  
  yPos = map(yIn, 0, 480, 105, 155);
  lastYin = yIn;
  
}

void moveNerf(){
  xServo.write(xPos);
  yServo.write(yPos);
}

void checkTrigger(){
  if (firing && (millis() - firedTime < 1000)){
    trigger.write(70);
  }
  else{
    trigger.write(90);
  }
}
