import gab.opencv.*;
import java.awt.Rectangle;
int i = 1;
Table table; //Data
PImage img; //Pimage for current frame
//##boolean next = true;  //click
boolean ok;
int frameNumber;
String frameString = (nf(frameNumber, 8)); //string of frame number with Zeros
String frameName = "frame_" + frameString + ".jpg"; //string of frame name with frameNumber and '.jpg' suffix

//frameString = (nf(frameNumber,8));
//frameName = "frame_" + frameNumber + ".jpg";

int startTime;

OpenCV opencv;  //OpenCV initialize
Rectangle[] faces; //some rectangles bc we need them okay. 

void setup() {
  size (665, 360);
  startTime = millis();
  frameNumber = 10313; // counter starts at #
  //frameString = (nf(frameNumber,8));
  //frameName = "frame_" + frameNumber + ".jpg";
  ok = false;
  table = loadTable("data.csv", "header");
  println("Setup took: " + (millis() - startTime) + " ..." );
}

void draw() {
}

// click to select Steve's face
void mousePressed() {
  boolean ok = false;
  while (ok == false) {
    ok = updateFrame();
  }
  recordFace();
}

// if spacebar, no face and keep going
void keyPressed() {
  if (key == 32) {
    boolean ok = false;
    while (ok == false) {
      ok = updateFrame();
    }
  }
}

void recordFace() {  
  int mx = mouseX;
  int my = mouseY;
  // see which face is clicked

  table = loadTable("data.csv", "header"); //load the table
  for (int i = 0; i < faces.length; i++) { 
    if (mx >= faces[i].x && mx <= (faces[i].x + faces[i].width) && my >= faces[i].y && my <= (faces[i].y + faces[i].height)) {
      println(faces[i]);

      //store the data to a the csv-------------------------------------
      //if ( mx >= rectX && mx <= (rectX + rectW) && my >= rectY && rectY <= (rectY +rectH)){   //###############
      TableRow row = table.addRow();
      row.setString("frame", frameName);
      row.setInt("x", faces[i].x); // THIS IS BECOME THE RECT INFORMATION ONCE THE RECTS ARE DRAWN
      row.setInt("y", faces[i].y);
      row.setInt("width", faces[i].width);
      row.setInt("height", faces[i].height);
      
      println( frameName + ": face recorded at coords " + faces[i].x + " " + faces[i].y);
    }
  }
  // record data to file
  saveTable(table, "data/data.csv", "csv");  //save the table
  
}

boolean updateFrame() {

  // update frame num
  frameNumber += 1;
  frameString = (nf(frameNumber, 8)); //string of frame number with Zeros
  frameName = "frame_" + frameString + ".jpg"; //string of frame name with frameNumber and '.jpg' suffix

  try {
    // load the next frame
    //#loadImage(frameName);
    // run face detection

    opencv = new OpenCV( this, frameName);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    faces = opencv.detect();
    image(opencv.getInput(), 0, 0, 665, 360);

    // run face detection

    // draw the frame and faces to screen
    noFill();
    stroke(0, 255, 0);
    strokeWeight(2);
    for (int i = 0; i < faces.length; i++) { //loop for # of faces
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height); // draw rectangles
    }
    return true;
  }
  catch (NullPointerException npe) {
    println("NullPointer  " + frameName);
    println(i);
    i++;

    return false;
  }
}