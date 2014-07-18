import com.onformative.leap.*;
import com.leapmotion.leap.*;

import java.util.Calendar;
import java.util.Iterator;

//general fields
AppState state = AppState.WEBCAM;
LeapMotionP5 leap;

//webcam fields
float camWidth = 640;
float camHeight = 480;

//Menu fields
Difficulty diff;
ArrayList<LeapButton> bGroup = new ArrayList<LeapButton>();
LeapButton startGame;
LeapButton btnHiscores;

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

//hiscores
ArrayList<HiscoreEntry> scores;
HiscoreHandler hh;
LeapButton btnBackToMenu;

//webcam
WebcamHandler webcam;

/*
=================================
 Processing Main methods
=================================
*/

void setup() {

  //general settings
  size(640, 480);
  noStroke();

  //general inits
  leap = new LeapMotionP5(this);

  //main menu settings
  bGroup.add(new LeapButton(width/2 - 75, height/2 - 50, 150, 60, "Easy"));
  bGroup.add(new LeapButton(width/2 - 75, height/2 + 20, 150, 60, "Medium"));
  bGroup.add(new LeapButton(width/2 - 75, height/2 + 90, 150, 60, "Hard"));
  startGame = new LeapButton(width/2 - 90, height/2 - 120, 180, 60, "Start game");
  btnHiscores = new LeapButton(width - 70, height - 60, 60, 50, "hiscores");
  changeDifficulty(Difficulty.MEDIUM);

  //game settings
  startTime = System.currentTimeMillis();
  counterTime = System.currentTimeMillis();
  
  //scores
  hh = new HiscoreHandler();
  scores = hh.getHiscores();
  btnBackToMenu = new LeapButton((width - width + 50), height - 60, 100, 50, "back to menu");
  
  //webcam
  webcam = new WebcamHandler(this);
  
}

void draw() {

  background(177);

  if (state == AppState.WEBCAM) {
    drawCamera();
  } else if (state == AppState.MAINMENU) {
    drawMainMenu();
    drawLeapCursor();
  } else if (state == AppState.GAME) {
    drawGame();
  } else if (state == AppState.GAMEOVER) {
    drawGameOver();
    drawLeapCursor();
  } else if (state == AppState.LEVELCOMPLETE) {
    draweLevelComplete();
    drawLeapCursor();
  } else if(state == AppState.HISCORES){
    drawHiscores();
    drawLeapCursor();
  }
}

/*=================================
 Processing draw methods
=================================
*/

void drawCamera() {
  webcam.drawCam();
}

void drawMainMenu() {

  //draw start button  
  startGame.display();
  btnHiscores.display();

  //draw difficultybuttons
  for (LeapButton l : bGroup) {
    l.display();
  }
}

void drawGame() {

  //Force garbage collection, just to be safe
  if (millis() % 150 == 0) {
    System.gc();
  }

  //Change appstate when lives equals zero
  if (lives == 0) {
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

void draweLevelComplete() {
  text("complete", width/2, height/2);
  knightArray.clear();
}

void drawGameOver() {
  text("game over", width/2, height/2);
  knightArray.clear();
}

void drawHiscores(){
  
  btnBackToMenu.display();
  
  //auto refresh every 1500 secs
  if(millis() % 1500 == 0){
    scores = hh.getHiscores();
  }
  
  if(scores.size() != 0){
    for(int i = 0; i < scores.size(); i++){
      text(i + 1, (width/2 - 50), (50 + (i*15)));
      text(scores.get(i).getName(), width/2, (50 + (i*15)));
      text(scores.get(i).getScore(), width/2 + 50, (50 + (i*15)));
    }
  } else {
    text("No scores available yet!", width/2, height/2);
  }

}

/*
=======================================
 (Almost) Always active draw methods
=======================================
*/

void drawLeapCursor() {

  for (Pointable p : leap.getPointableList()) {
    PVector position = leap.getTip(p);
    ellipse(position.x, position.y, 20, 20);
    break;
  }
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

  if (timer % 1800 > 1000) {
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

void changeDifficulty(Difficulty difficulty) {

  //change global difficulty var
  this.diff = difficulty;

  //reset all selected difficulty buttons
  for (LeapButton l : bGroup) {
    l.setIsSelected(false);
  }

  //set the correct difficulty button
  if (this.diff == Difficulty.EASY) {
    bGroup.get(0).setIsSelected(true);
  } else if (this.diff == Difficulty.MEDIUM) {
    bGroup.get(1).setIsSelected(true);
  } else {
    bGroup.get(2).setIsSelected(true);
  }
}


/*
=================================
 Processing + leap events
=================================
*/

void mouseDragged() {
  for (int i = 0; i < knightArray.size (); i++)
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
    
    //save the image
    Calendar cal = Calendar.getInstance();
    String filename = cal.getTime().toString().replace(":", "") + ".png";
    saveFrame(filename);
    
    //tweet the image
    TwitterHandler th = new TwitterHandler();
    th.tweetScore(666, filename);
    
  } else if (state == AppState.MAINMENU) {
    
    //the most dirty code you'll ever see of your life
    for (LeapButton l : bGroup) {
      if (mouseX > l.bX && mouseX < l.bX + l.bWidth && mouseY > l.bY && mouseY < l.bY + l.bHeight) {
        if (l.getLabelText().toLowerCase().equals("easy")) {
          changeDifficulty(Difficulty.EASY);
        } else if (l.getLabelText().toLowerCase().equals("medium")) {
          changeDifficulty(Difficulty.MEDIUM);
        } else {
          changeDifficulty(Difficulty.HARD);
        }
      }
    }

    //start game button
    if (mouseX > startGame.bX && mouseX < startGame.bX + startGame.bWidth && mouseY > startGame.bY && mouseY < startGame.bY + startGame.bHeight) {
      state = AppState.GAME;
    }
    
    //check hiscores button
    if (mouseX > btnHiscores.bX && mouseX < btnHiscores.bX + btnHiscores.bWidth && mouseY > btnHiscores.bY && mouseY < btnHiscores.bY + btnHiscores.bHeight) {
      state = AppState.HISCORES;
    }    
  } else if(state == AppState.HISCORES){
    //go back to menu from hiscores button 
    if (mouseX > btnBackToMenu.bX && mouseX < btnBackToMenu.bX + btnBackToMenu.bWidth && mouseY > btnBackToMenu.bY && mouseY < btnBackToMenu.bY + btnBackToMenu.bHeight) {
      state = AppState.MAINMENU;
    }
  }
}

public void screenTapGestureRecognized(ScreenTapGesture gesture) {

  println("detected");
  
  float leapX = gesture.position().getX();
  float leapY = gesture.position().getY();

  for (Pointable p : leap.getPointableList()) {
    PVector position = leap.getTip(p);
    leapX = position.x;
    leapY = position.y;
  }

  for (LeapButton l : bGroup) {
    if(leapX > l.bX && leapX < (l.bX + l.bWidth) && leapY > l.bY && leapY < (l.bY + l.bHeight)) {
      
      break;
    }
  }
}

void keyPressed(){
 /*
 HiscoreEntry e = new HiscoreEntry("JAN", 21000);
 hh.saveHiscore(e);
 */
}
