//TODO: find a working webcam lib

import com.onformative.leap.*;
import java.util.Calendar;
import java.util.Iterator;
//fields
AppState state = AppState.MAINMENU;

float camWidth = 640;
float camHeight = 480;

//Difficulty fields
Difficulty diff;
ArrayList<LeapButton> bGroup = new ArrayList<LeapButton>();
LeapButton startGame;

//Game fields
int rectHeight = 180;
ArrayList knightArray = new ArrayList();
int pointCounter = 0;
int currentLvl = 1;
int lives = 3;
int timer;
int appearanceTime = 500;    //the higher this field, the slower the knights spawn

long startTime;
long counterTime;

/*
=================================
      Processing Main methods
=================================
*/

void setup() {
  size(640, 480);
  noStroke();

  //difficulty settings
  bGroup.add(new LeapButton(width/2 - 75, height/2 - 50, 150, 60, "Easy"));
  bGroup.add(new LeapButton(width/2 - 75, height/2 + 20, 150, 60, "Medium"));
  bGroup.add(new LeapButton(width/2 - 75, height/2 + 90, 150, 60, "Hard"));
  startGame = new LeapButton(width/2 - 90, height/2 - 120, 180, 60, "Start game");
  
  changeDifficulty(Difficulty.MEDIUM);


  startTime = System.currentTimeMillis();
  counterTime = System.currentTimeMillis();
}

void draw() {

  background(177);

  if (state == AppState.WEBCAM) {
    //drawCamera();
  } else if (state == AppState.MAINMENU) {
    drawMainMenu();
  } else if (state == AppState.GAME) {
    drawGame();
  } else if (state == AppState.GAMEOVER){
    drawGameOver();
  } else if(state == AppState.LEVELCOMPLETE){
    draweLevelComplete();
  }
}


/*
=================================
      Processing draw methods
=================================
*/

void drawCamera() {
}

void drawMainMenu() {
  
  //draw start button  
  startGame.display();
  
  //draw difficultybuttons
  for (LeapButton l : bGroup) {
    l.display();
  }
}

void drawGame() {
  
  //Force garbage collection, just to be safe
  if(millis() % 150 == 0){
    System.gc();
  }
  
  //Change appstate when lives equals zero
  if(lives == 0){
    state = AppState.GAMEOVER;
  }
  
  livesChanged(false);
  
  //draw score + lives
  textAlign(LEFT);
  fill(#ffffff);
  textSize(25);
  text("Score: " + pointCounter, 25, 45);
  text("Lives: " + lives, 25, 70);
  
  //everything timer related goes here
  indicateTime();

  if (timer!=0) {
    if (timer % 1800 == 0) {
      state = AppState.LEVELCOMPLETE;
    }
  }
  timer++;

  //Spawn the knights
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

void draweLevelComplete(){
  text("complete",width/2,height/2);
  knightArray.clear();
}

void drawGameOver(){
  text("game over",width/2,height/2);
  knightArray.clear();
}

/*
=================================
      Helpful methods
=================================
*/

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


void livesChanged(boolean decreaseLives) {
  if (decreaseLives) {
    lives--;
  }
}

void changeDifficulty(Difficulty difficulty){
  
  //change global difficulty var
  this.diff = difficulty;
  
  //reset all selected difficulty buttons
  for(LeapButton l : bGroup){
    l.setIsSelected(false);
  }
  
  //set the correct difficulty button
  if(this.diff == Difficulty.EASY){
    bGroup.get(0).setIsSelected(true);  
  } else if(this.diff == Difficulty.MEDIUM){
    bGroup.get(1).setIsSelected(true);  
  } else {
    bGroup.get(2).setIsSelected(true); 
  }
}


/*
=================================
      Processing events
=================================
*/

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
  } else if (state == AppState.MAINMENU) {
    
    for (LeapButton l : bGroup) {
      if (mouseX > l.bX && mouseX < l.bX + l.bWidth && mouseY > l.bY && mouseY < l.bY + l.bHeight) {
        if(l.getLabelText().toLowerCase().equals("easy")){
          changeDifficulty(Difficulty.EASY);
        } else if(l.getLabelText().toLowerCase().equals("medium")){
          changeDifficulty(Difficulty.MEDIUM);
        } else{
          changeDifficulty(Difficulty.HARD);
        }
      }
    }
    
    if (mouseX > startGame.bX && mouseX < startGame.bX + startGame.bWidth && mouseY > startGame.bY && mouseY < startGame.bY + startGame.bHeight) {
        state = AppState.GAME;
      }
  }
}

