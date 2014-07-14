//TODO: find a working webcam lib

import com.onformative.leap.*;
import java.util.Calendar;

//fields
AppState state = AppState.DIFFICULTYMENU;

float camWidth = 640;
float camHeight = 480;

//Difficulty fields
Difficulty dif = Difficulty.MEDIUM;
ArrayList<LeapButton> bGroup = new ArrayList<LeapButton>();

void setup() {
  size(640, 480);
  noStroke();

  //difficulty settings
  bGroup.add(new LeapButton(width/2, height/2 - 120, 150, 60, "Easy"));
  bGroup.add(new LeapButton(width/2, height/2 - 50, 150, 60, "Medium"));
  bGroup.add(new LeapButton(width/2, height/2 +20, 150, 60, "Hard"));
}

void draw() {

  background(177);

  println("Dit is een test");
  if (state == AppState.WEBCAM) {
    //drawCamera();
  } else if (state == AppState.MAINMENU) {
    drawMainMenu();
  } else if (state == AppState.DIFFICULTYMENU) {
    drawDifficultyMenu();
  }
}

void drawCamera() {
}

void drawMainMenu() {
  LeapButton startGame = new LeapButton(width/2, height/2 - 100, 150, 60, "Start game");
  startGame.display();
}

void drawDifficultyMenu() {

  for (LeapButton l : bGroup) {
    l.display();
  }
}


void mousePressed() {
  if (state == AppState.WEBCAM) {
    Calendar cal = Calendar.getInstance();
    String filename = cal.getTime().toString().replace(":", "") + ".png";
    saveFrame(filename);
  } else if (state == AppState.DIFFICULTYMENU) {
    rectMode(CORNER);
    for (LeapButton l : bGroup) {
      if (mouseX > l.bX && mouseX < l.bX + l.bWidth && mouseY > l.bY && mouseY < l.bY + l.bHeight) {
        l.setIsSelected(true);
      }
    }
  }
}

