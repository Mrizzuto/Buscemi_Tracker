int i = 1; //movie Frame  //10327
String iString = "frame_" + (nf(i,8)) + ".png"; //movie frame as string
int dataCount = 1;  // dataset row
Table table; //Data frameName, coords x, coords y, width, height
PGraphics faces;
PImage img;
PImage frame;
int padding = 0;

void setup(){
  size(1280,720);
  faces = createGraphics(width,height);
  table = loadTable("data.csv", "header");
  //frameRate(15);
}

void draw() {
  loadFrame();
  //load data
  //try{
   
  TableRow row = table.getRow(dataCount);
  String frameName = row.getString("frame");
  println(frameName, iString);
  
  if (frameName.equals(iString)) {
    println("Buscemi Found | Buscemi Count: " + dataCount + " Current Frame: " + i);
    //cut out the face and add it to the PGraphic
    cropAndAdd();
    //advance to the next frame
    //advance to the next row in the data set
    dataCount += 1;
    
  }
  else{
    println("No Buscemi | Buscemi Count: " + dataCount + " Current Frame: " + i);
    //  okay, so the only files that will be lagging behind 
    //  the data set will be those of the movie. so if the Data set
    //  values are not equal to the movie values, its because the movie 
    //  values are less than the data set values. In this case the movie
    //  frame should advance and be saved following the "no face found" path.
    //  it will jump to draw the PGraphic to the sketch
    //loadFrame();
    image(faces,0,0); //load PGraphic of Buscemi Faces
  }
  ////savesFrame to subfolder "export"
  saveFrame("export/frame_########.png");
  
  // next frame in video
  i += 1;
}//draw


void loadFrame() {
 //load hi-res image of movie frame, name "frame_" + (nf(i,8)) + ".png" to screen
 iString = "frame_" + (nf(i,8)) + ".png";
 frame = loadImage("data/" + iString);
 image(frame,0,0);
}

void cropAndAdd() {
  //loadFrame();
  //Get table row information ----------------------
  TableRow row = table.getRow(dataCount);
  int X = row.getInt("x");
  int Y = row.getInt("y");
  int W = row.getInt("width");
  int H = row.getInt("height");
  //------------------------------------------------
  //make data work for 1280x720 rather than 665x360
  X *= 2;
  Y *= 2;
  W *= 2;
  H *= 2;
  //option of padding the face by a couple pixels
  X -= padding;
  Y -= padding;
  W += padding;
  H += padding;
  //------------------------------------------------
  //create a PImage of the Face
  img = frame.get(X,Y,W,H);
  //add the PImage of the Face to the PGraphic
  faces.beginDraw();
  //faces.image(img,X,Y);
  faces.image(img,X,Y);
  faces.endDraw();
  image(faces,0,0);
  //println("Face Cropped and Added");
  
}