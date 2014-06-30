import JMyron.*;
import java.util.Calendar;

//fields
JMyron m;

float camWidth = 640;
float camHeight = 480;

void setup(){
  size(640,480);
  m = new JMyron();
  m.start(width,height);
  
  m.findGlobs(0);

  loadPixels();

}

void draw(){
  m.update();//update the camera view
  m.imageCopy(pixels);//draw image to stage
  updatePixels();
}

void mousePressed(){
  Calendar cal = Calendar.getInstance();
  String filename = cal.getTime().toString().replace(":","") + ".png";
  saveFrame(filename);
}

public void stop(){
  m.stop();//stop the object
  super.stop();
}
