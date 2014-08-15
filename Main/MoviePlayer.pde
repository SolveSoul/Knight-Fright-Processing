import processing.video.*;

class MoviePlayer {

  //fields
  Movie infoMovie;
  String fileName;
  float duration;
  boolean isPlaying;

  //ctor
  public MoviePlayer(PApplet applet, String fileName) {
    this.infoMovie = new Movie(applet, fileName);
    this.isPlaying = false;
  }

  //methods
  void playMovie() {
    infoMovie.play();
    this.duration = infoMovie.duration();  //this must be called after play to be correct
    this.isPlaying = true;
  }

  void drawMovie() {
    if (isPlaying) {
      image(infoMovie, 0, 0);
    }
  }
}

