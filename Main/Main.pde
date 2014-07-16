//TODO: find a working webcam lib

import com.onformative.leap.*;
import java.util.Calendar;
import java.util.Iterator;
//fields
AppState state = AppState.GAME;

float camWidth = 640;
float camHeight = 480;

//Difficulty fields
Difficulty dif = Difficulty.MEDIUM;
ArrayList<LeapButton> bGroup = new ArrayList<LeapButton>();

//Game fields
int rectHeight = 180;
ArrayList knightArray = new ArrayList();
int pointCounter = 0;
int currentLvl = 1;
int lives = 3;
int timer;
//hoe hoger, hoe trager de ridders komen
int appearanceTime = 500;

long startTime;
long counterTime;

void setup() {
  size(640, 480);
  noStroke();

  //difficulty settings
  bGroup.add(new LeapButton(width/2, height/2 - 120, 150, 60, "Easy"));
  bGroup.add(new LeapButton(width/2, height/2 - 50, 150, 60, "Medium"));
  bGroup.add(new LeapButton(width/2, height/2 +20, 150, 60, "Hard"));


  startTime = System.currentTimeMillis();
  counterTime = System.currentTimeMillis();
}

void draw() {

  background(177);

  if (state == AppState.WEBCAM) {
    //drawCamera();
  } else if (state == AppState.MAINMENU) {
    drawMainMenu();
  } else if (state == AppState.DIFFICULTYMENU) {
    drawDifficultyMenu();
  } else if (state == AppState.GAME) {
    drawGame();
  } else if (state == AppState.GAMEOVER){
    drawGameOver();
  } else if(state == AppState.LEVELCOMPLETE){
    draweLevelComplete();
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

void drawGame() {
  
  //leventjes
  if(lives == 0){
    state = AppState.GAMEOVER;
  }
  
  livesChanged(false);
  
  //score tekenen + leventjes
  textAlign(LEFT);
  fill(#ffffff);
  textSize(25);
  text("Score: " + pointCounter, 25, 45);
  text("Lives: " + lives, 25, 70);
  
  //alles ivm de timer
  indicateTime();

  if (timer%100 ==0) {
    System.gc();
  }

  if (timer!=0) {
    if (timer % 1800 == 0) {
      state = AppState.LEVELCOMPLETE;
    }
  }
  timer++;

  //ridders tonen
  if (System.currentTimeMillis() - counterTime > appearanceTime)
  {
    Knight myKnight = new Knight(random(width), random(height, height - 100));
    knightArray.add(myKnight);
    counterTime = System.currentTimeMillis();
  }

  Iterator i = knightArray.iterator();
  while (i.hasNext ()) {
    Knight knight = (Knight) i.next();
    knight.run();
    if (knight.y > height && !knight.getKnightString().equals("appleCut.png")) {
      i.remove();
      livesChanged(true);
    }
  }
}

void indicateTime() {

  stroke(144, 144, 144);
  strokeWeight(3);
  rectMode(CORNER);
  fill(144, 144, 144);
  rect(width - 40, 20, 20, 180);

  fill(#458B00);
  rect(width - 40, 20, 20, rectHeight);
  noStroke();

  if (timer % 10 == 0) {
    rectHeight--;
  }
  
  if(timer % 1800 > 1000){
    fill(#FF7F00);
    rect(width - 40, 20, 20, rectHeight);
    noStroke();
  }
  
  if (timer %1800 > 1520) {
    fill(#B20000);
    rect(width - 40, 20, 20, rectHeight);
    noStroke();
  }
}

//leventjes aanpassen
void livesChanged(boolean decreaseLives) {
  if (decreaseLives) {
    lives--;
  }
}
void draweLevelComplete(){
  text("complete",width/2,height/2);
  knightArray.clear();
}

void drawGameOver(){
  text("game over",width/2,height/2);
  knightArray.clear();
}

void mouseDragged(){
  for (int i = 0; i < knightArray.size(); i++)
  {
    Knight myKnight = (Knight) knightArray.get(i);
    if (dist(myKnight.getX(), myKnight.getY(), mouseX, mouseY) < myKnight.getRadius())
    {
      myKnight.setKnightString("appleCut.png");
      myKnight.setKnight(loadImage("appleCut.png"));
      pointCounter++;
    }
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

