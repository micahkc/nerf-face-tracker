import processing.serial.*;
Serial port;

import processing.video.*;
import gab.opencv.*;
import java.awt.*;

Capture cam;
OpenCV opencv;

int xDot = 0;
int yDot = 0;
int howMuchToMoveX;
int howMuchToMoveY;



void setup(){
  size(640, 480);
  String[] cameras = Capture.list();
  
  cam = new Capture(this, cameras[7]);// cam = new Capture(this, 640, 480,32);
  opencv = new OpenCV(this, 640, 480);//opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
 
  cam.start();
  
  port = new Serial(this, Serial.list()[0], 9600);//0 or 3 depending on BT module
}

void draw(){
  image(cam, 0, 0);
  //opencv.loadImage(cam);
  if(cam.width > 0 && cam.height > 0){//check if the cam instance has loaded pixels
      opencv.loadImage(cam);//send the cam
      noFill();
      strokeWeight(2);
      stroke(255,0,0);
      ellipse(width/2, yDot, 50,50);
      line(width/2, yDot-15, width/2, yDot-20);
      line(width/2, yDot+15, width/2, yDot+20);
      line(width/2 -20, yDot, width/2-10, yDot);
      line(width/2 + 20, yDot, width/2+10, yDot);
      Rectangle[] faces = opencv.detect();//put all humans in this arrray//micah is in loc x = 32, kyle loc x = 80
      
    
      if (faces.length >0){
        xDot = faces[0].x + faces[0].width/2;
        yDot = faces[0].y + faces[0].height/2;
        howMuchToMoveX = xDot;
        howMuchToMoveY = yDot;
        print(Integer.toString(howMuchToMoveX));
        print(", ");
        println(howMuchToMoveY);
        port.write(Integer.toString(howMuchToMoveX));
        port.write('x');
        port.write(Integer.toString(howMuchToMoveY));
        port.write('y');
        fill(255,125,0);
        strokeWeight(0);
        ellipse(xDot, yDot, 5, 5); 
        delay(10);
      
      }
  
 
  } 
}

void captureEvent(Capture c) {
  c.read();
}
