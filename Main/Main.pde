import com.onformative.leap.*;
import com.leapmotion.leap.*;

import java.util.Calendar;
import java.util.Iterator;

//general fields
AppState state = AppState.MAINMENU;
LeapMotionP5 leap;
PImage imgBack;
PImage imgGameBack;
PFont font; 

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
int appearanceTime;    //the higher this field, the slower the knights spawn

long startTime;
long counterTime;

int transcounter; // level transition indicator
PImage imgTransition;

//hiscores
ArrayList<HiscoreEntry> scores;
HiscoreHandler hh;
LeapButton btnBackToMenu;

//Next level / Restart / Share
LeapButton btnNextLevel;
LeapButton btnRestart;

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
  imgBack = loadImage("menuBackground.png");
  imgTransition = loadImage("transition.png");
  imgGameBack = loadImage("gameBackground.png");
  
  //general inits
  leap = new LeapMotionP5(this);

  //main menu settings
  bGroup.add(new LeapButton(width/2 - 75, height/2 - 10, 150, 60, "Easy"));
  bGroup.add(new LeapButton(width/2 - 75, height/2 + 60, 150, 60, "Medium"));
  bGroup.add(new LeapButton(width/2 - 75, height/2 + 130, 150, 60, "Hard"));
  startGame = new LeapButton(width/2 - 90, height/2 - 80, 180, 60, "Start game");
  btnHiscores = new LeapButton(width - 120, height - 60, 100, 50, "hiscores");
  changeDifficulty(Difficulty.MEDIUM);

  //game settings
  startTime = System.currentTimeMillis();
  counterTime = System.currentTimeMillis();

  //scores
  hh = new HiscoreHandler();
  scores = hh.getHiscores();
  btnBackToMenu = new LeapButton((width - width + 50), height - 60, 100, 50, "back to menu");

  //next level / Restart / Share
  btnNextLevel = new LeapButton(width/2 - 90, height/2, 180, 60, "Next level");
  btnRestart = new LeapButton(width/2 - 90, height/2, 180, 60, "Restart level");

  //webcam
  webcam = new WebcamHandler(this);
  
  //font
  font = createFont("Knights Quest", 25);
}


void draw() {
  background(imgBack);
  textFont(font);
  
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
  } else if (state == AppState.HISCORES) {
    drawHiscores();
    drawLeapCursor();
  } else if (state == AppState.LEVELTRANSITION) {
    transcounter++;
    drawLevelTransition(transcounter);
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
  textSize(60);
  text("Knight Fright", width/2 - 160, 55);
  //draw start button  
  textSize(30);
  startGame.display();
  btnHiscores.display();
  
  //draw difficultybuttons
  for (LeapButton l : bGroup) {
    l.display();
  }
}

void drawGame() {
  background(imgGameBack);
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
  textSize(30);
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
    Knight myKnight = new Knight(random(width - 100), random(height, height - 100));
    knightArray.add(myKnight);
    counterTime = System.currentTimeMillis();
  }

  Iterator i = knightArray.iterator();
  while (i.hasNext ()) {
    Knight knight = (Knight) i.next();
    knight.run();
    if (knight.y > height && !knight.getIsCut()) {
      i.remove();
      livesChanged(true);
    }
  }
}

void draweLevelComplete() {
  btnNextLevel.display();
  knightArray.clear();
}

void drawGameOver() {
  btnRestart.display();
  knightArray.clear();
}

void drawLevelTransition(int transcounter) {
  background(imgGameBack);
  image(imgTransition,120, -20);
  fill(#ffffff);
  textSize(80);
  if (transcounter <= 60) {
    text("3",300, 230);
  } else if (transcounter > 60 && transcounter <=120) {
    text("2", 310, 230);
  } else if (transcounter > 120 && transcounter <=180) {
    text("1", 310, 230);
  } else {
    text("GO!", 270, 230);
  }
  if (transcounter == 240) {
    state = AppState.GAME;
  }
}

void drawHiscores() {

  btnBackToMenu.display();

  //auto refresh every 1500 secs
  if (millis() % 1500 == 0) {
    scores = hh.getHiscores();
  }

  if (scores.size() != 0) {
    for (int i = 0; i < scores.size (); i++) {
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
  fill(255, 0, 0);
  for (Pointable p : leap.getPointableList ()) {
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
  noFill();
 // fill(144, 144, 144);
  rect(width - 40, 20, 20, 180);

  stroke(#458B00);
  fill(#458B00);
  rect(width - 40, 20, 20, rectHeight);
  
  if (timer % 10 == 0) {
    rectHeight--;
  }

  if (timer % 1800 > 1000) {
    stroke(#FF7F00);
    fill(#FF7F00);
    rect(width - 40, 20, 20, rectHeight);
  }

  if (timer %1800 > 1520) {
    stroke(#B20000);
    fill(#B20000);
    rect(width - 40, 20, 20, rectHeight);
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
    appearanceTime = 2300;
  } else if (this.diff == Difficulty.MEDIUM) {
    bGroup.get(1).setIsSelected(true);
    appearanceTime = 1800;
  } else {
    bGroup.get(2).setIsSelected(true);
    appearanceTime = 1000;
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
    if (dist(myKnight.getX(), myKnight.getY(), mouseX, mouseY) < myKnight.getRadius()) {
      myKnight.setIsCut(true);
      myKnight.setKnightIndex(myKnight.knightIndex);
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
    Thread tweet = new Thread(new TwitterHandler(799, filename));
    tweet.start();
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
      state = AppState.LEVELTRANSITION;
    }

    //check hiscores button
    if (mouseX > btnHiscores.bX && mouseX < btnHiscores.bX + btnHiscores.bWidth && mouseY > btnHiscores.bY && mouseY < btnHiscores.bY + btnHiscores.bHeight) {
      state = AppState.HISCORES;
    }
  } else if (state == AppState.HISCORES) {
    //go back to menu from hiscores button 
    if (mouseX > btnBackToMenu.bX && mouseX < btnBackToMenu.bX + btnBackToMenu.bWidth && mouseY > btnBackToMenu.bY && mouseY < btnBackToMenu.bY + btnBackToMenu.bHeight) {
      state = AppState.MAINMENU;
    }
  } else if (state == AppState.LEVELCOMPLETE) {
    if (mouseX > btnNextLevel.bX && mouseX < btnNextLevel.bX + btnNextLevel.bWidth && mouseY > btnNextLevel.bY && mouseY < btnNextLevel.bY + btnNextLevel.bHeight) {

      lives = 3;
      currentLvl++;
      rectHeight = 180;
      transcounter = 0;
      timer = 0;

      if (appearanceTime != 0 || appearanceTime > 0) {
        if (this.diff == Difficulty.EASY) {
          appearanceTime= appearanceTime - 300;
        } else if (this.diff == Difficulty.MEDIUM) {
          appearanceTime= appearanceTime - 150;
        } else {
          appearanceTime= appearanceTime - 50;
        }
      } else {
        appearanceTime = 100;
      }

      state = AppState.LEVELTRANSITION;
    }
  } else if (state == AppState.GAMEOVER) {
    //go back to menu 
    if (mouseX > btnRestart.bX && mouseX < btnRestart.bX + btnRestart.bWidth && mouseY > btnRestart.bY && mouseY < btnRestart.bY + btnRestart.bHeight) {
      state = AppState.MAINMENU;
      lives = 3;
      currentLvl = 1;
      rectHeight = 180;
      transcounter = 0;
      timer = 0;
    }
  }
}
public void screenTapGestureRecognized(ScreenTapGesture gesture) {

  println("detected");

  float leapX = gesture.position().getX();
  float leapY = gesture.position().getY();

  for (Pointable p : leap.getPointableList ()) {
    PVector position = leap.getTip(p);
    leapX = position.x;
    leapY = position.y;
  }

  for (LeapButton l : bGroup) {
    if (leapX > l.bX && leapX < (l.bX + l.bWidth) && leapY > l.bY && leapY < (l.bY + l.bHeight)) {
      break;
    }
    
  }
}

void keyPressed() {
  /*
 HiscoreEntry e = new HiscoreEntry("JAN", 21000);
   hh.saveHiscore(e);
   */
}

