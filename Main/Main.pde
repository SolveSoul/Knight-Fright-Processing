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
  //score tekenen
  textAlign(LEFT);
  fill(#ffffff);
  textSize(25);
  text("Score: " + pointCounter, 25, 45);

  indicateTime();

  if (timer%100 ==0) {
    System.gc();
  }

  if (timer!=0) {
    if (timer % 1800 == 0) {
      println("GEDAAN");
      //level complete
    }
  }

  timer++;

  if (System.currentTimeMillis() - counterTime > appearanceTime)
  {
    Knight myFruit = new Knight(random(width), random(height, height - 100));
    knightArray.add(myFruit);
    counterTime = System.currentTimeMillis();
  }

  Iterator i = knightArray.iterator();
  while (i.hasNext ()) {
    Knight knight = (Knight) i.next();
    knight.run();
    if (knight.y > height && !knight.getAppleString().equals("appleCut.png")) {
      i.remove();
    }
  }
}

void indicateTime() {

  stroke(144, 144, 144);
  strokeWeight(3);
  rectMode(CORNER);
  fill(144, 144, 144);
  rect(width - 40, 20, 20, 180);

 // fill(85, 172, 238, 180);
  fill(#458B00);
  rect(width - 40, 20, 20, rectHeight);
  noStroke();


  if (timer % 10 == 0) {
    rectHeight--;
    println(rectHeight);
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

void mouseDragged(){
  for (int i = 0; i < knightArray.size(); i++)
  {
    Knight myFruit = (Knight) knightArray.get(i);
    if (dist(myFruit.getX(), myFruit.getY(), mouseX, mouseY) < myFruit.getRadius())
    {
      myFruit.setAppleString("appleCut.png");
      myFruit.setApple(loadImage("appleCut.png"));
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

