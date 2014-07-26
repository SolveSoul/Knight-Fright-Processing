import processing.video.*;

class WebcamHandler {

  //fields
  private final String acerName = "name=1.3M HD WebCam,size=640x480,fps=30";    //Acer Crystal Eye Webcam
  private final String hpName = "name=HP HD Webcam [Fixed],size=640x480,fps=30"; //HP webcam
  private boolean isCamAvailable;
  private Capture cam;

  //getters & setters
  public boolean getIsCamAvailable() {
    return this.isCamAvailable;
  }

  //ctor
  public WebcamHandler(PApplet applet) {
    //printAllWebcams();
    String[] cameras = Capture.list();

    if (cameras.length == 0) {
      this.isCamAvailable = false;
    } else {
      for (int i = 0; i < cameras.length; i++) {

        if (cameras[i].equals(acerName)) {
          isCamAvailable = true;
          cam = new Capture(applet, cameras[1]);
          cam.start();
          break;
        } else if (cameras[i].equals(hpName)) {
          isCamAvailable = true;
          cam = new Capture(applet, cameras[1]);
          cam.start();
          break;
        }
      }
    }
  }

  //methods
  public void drawCam() {
    if (cam != null && cam.available()) {
      cam.read();
    }
    image(cam, 0, 0);
  }

  public void stopCam(){
    cam.stop();
  }
  private void printAllWebcams() {
    println("available cameras:");
    String[] cameras = Capture.list();
    for (String s : cameras) {
      println(s);
    }
  }
}

