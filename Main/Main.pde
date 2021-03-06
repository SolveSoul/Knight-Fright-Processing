//imports
import com.onformative.leap.*;
import com.leapmotion.leap.*;
import com.leapmotion.leap.ScreenTapGesture;
import com.leapmotion.leap.CircleGesture;
import com.leapmotion.leap.SwipeGesture;
import com.leapmotion.leap.Gesture.State;
import java.util.Calendar;
import java.util.Iterator;

//general fields
AppState state = AppState.MAINMENU;
LeapMotionP5 leap;
PImage imgBack;
PImage imgGameBack;
PImage imgHiscores;
PFont font; 

//webcam fields
float camWidth = 640;
float camHeight = 480;
String filename;
PImage shareImage;
PImage shareBorder;

//Menu fields
Difficulty diff;
ArrayList<LeapButton> bGroup = new ArrayList<LeapButton>();
LeapButton startGame;
LeapButton btnHiscores;
LeapButton btnInfo;

//Game fields
int rectHeight = 180;
ArrayList knightArray = new ArrayList();
int pointCounter = 0;
int currentLvl = 1;
int lives = 3;
int timer;
int appearanceTime;    //the higher this field, the slower the knights spawn
int basePoints = 10;

//Game timer fields
long startTime;
long counterTime;

//Level transition fields
int transcounter;
PImage imgTransition;

//hiscore fields
ArrayList<HiscoreEntry> scores;
HiscoreHandler hh;
LeapButton btnBackToMenu;

//leap trail fields
PVector circlePosition;
ArrayList<PVector> circleTrail;
int trailSize = 10;

//Next level, Restart & Share buttons
LeapButton btnNextLevel;
LeapButton btnRestart;
LeapButton btnShare;
LeapButton btnPicOk;
LeapButton btnPicNok;

//Webcam fields
WebcamHandler webcam;
int counter = 0;

//movie fields
MoviePlayer infoMovie;
PImage movieBorder;

//new hiscore fields
LeapScoreSelector selector;
LeapButton selectLetter;
LeapButton endLetters;

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
  imgHiscores = loadImage("saveScore.png");
  movieBorder = loadImage("border.png");

  //general inits
  leap = new LeapMotionP5(this);
  leap.enableGesture(Gesture.Type.TYPE_SCREEN_TAP);
  leap.enableGesture(Gesture.Type.TYPE_CIRCLE);
  leap.enableGesture(Gesture.Type.TYPE_SWIPE);

  //main menu settings
  bGroup.add(new LeapButton(width/2 - 75, height/2 - 10, 150, 60, "Easy"));
  bGroup.add(new LeapButton(width/2 - 75, height/2 + 60, 150, 60, "Medium"));
  bGroup.add(new LeapButton(width/2 - 75, height/2 + 130, 150, 60, "Hard"));
  startGame = new LeapButton(width/2 - 90, height/2 - 80, 180, 60, "Start game");
  btnInfo = new LeapButton(width/2 + 100, height/2 -80, 50, 60, loadImage("i.png"));
  btnHiscores = new LeapButton(width - 150, height - 60, 140, 50, loadImage("goToHiScore.png"));
  changeDifficulty(Difficulty.MEDIUM);

  //game settings
  startTime = System.currentTimeMillis();
  counterTime = System.currentTimeMillis();

  //hiscores setup
  hh = new HiscoreHandler();
  scores = hh.getHiscores();
  btnBackToMenu = new LeapButton((width-150), height - 60, 140, 50, loadImage("goToMenu.png"));

  //next level, Restart & Share buttons
  btnNextLevel = new LeapButton(width/2 - 90, height/2 + 30, 180, 60, "Next level");
  btnRestart = new LeapButton(width/2 - 90, height/2 + 30, 180, 60, "Try again");
  btnShare = new LeapButton(width/2 - 90, height/2 + 100, 180, 60, "Share");
  btnPicOk = new LeapButton(120, 380, 200, 60, "Share on twitter");
  btnPicNok = new LeapButton(350, 380, 200, 60, "Take new picture");

  //leap trail setup
  circlePosition = new PVector(width*0.5, width*0.5);
  circleTrail = new ArrayList<PVector>();

  //webcam init
  webcam = new WebcamHandler(this);

  //font init
  font = createFont("Knights Quest", 25);

  //movie init
  infoMovie = new MoviePlayer(this, "movie.mov");

  //new hiscore init
  selector = new LeapScoreSelector();
  selectLetter = new LeapButton(width/2 +155, height/2 + 90, 155, 50, "PICK LETTER");
  endLetters = new LeapButton(width/2 +155, height/2 + 140, 155, 50, "SAVE");
}

void draw() {
  background(imgBack);
  textFont(font);

  if (state == AppState.WEBCAM) {
    drawCamera();
    counter++;
    drawCountDown(counter);
  } else if (state == AppState.MAINMENU) {
    drawMainMenu();
    drawLeapCursor();
  } else if (state == AppState.GAME) {
    drawGame();
    drawLeapLine();
    drawMouseLine();
    checkKnightHit();
  } else if (state == AppState.GAMEOVER) {
    drawGameOver();
    drawLeapCursor();
  } else if (state == AppState.LEVELCOMPLETE) {
    drawLevelComplete();
    drawLeapCursor();
  } else if (state == AppState.HISCORES) {
    drawHiscores();
    drawLeapCursor();
  } else if (state == AppState.LEVELTRANSITION) {
    transcounter++;
    drawLevelTransition(transcounter);
  } else if (state == AppState.SHARE) {
    drawShareMenu(filename);
    drawLeapCursor();
  } else if (state == AppState.MOVIE) {
    drawMovie();
  } else if (state == AppState.NEWHISCORE) {
    drawNewHiscore();
    drawLeapCursor();
  }
}

/*=================================
 Processing draw methods
 ==================================
 */

void drawCamera() {
  webcam.drawCam();
}

void drawMainMenu() {
  textSize(60);
  fill(#3c2415);
  text("Knight Fright", width/2 - 150, 55);

  //draw start button  
  textSize(30);
  startGame.display();
  btnHiscores.display();
  btnInfo.display();

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

    if (hh.isHiscore(pointCounter)) {
      state = AppState.NEWHISCORE;
    } else {
      state = AppState.GAMEOVER;
    }
  }

  livesChanged(false);

  //draw score + lives
  textAlign(LEFT);
  fill(#3c2415);
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
  if (System.currentTimeMillis() - counterTime > appearanceTime) {
    Knight myKnight = new Knight(random(width - 100), random(height, height - 100));
    knightArray.add(myKnight);
    counterTime = System.currentTimeMillis();
  }

  Iterator i = knightArray.iterator();
  while (i.hasNext ()) {
    Knight knight = (Knight) i.next();
    knight.run();
    if (knight.y > height && !knight.getIsCut() && !knight.isBomb) {
      i.remove();
      livesChanged(true);
    }
  }
}

void drawLevelComplete() {
  textSize(50);
  fill(255);
  text("Well done!", width/2-95, 200);
  textSize(30);
  fill(#3c2415);
  btnNextLevel.display();
  knightArray.clear();
}

void drawGameOver() {
  fill(255);
  textSize(50);
  text("Too bad!", 250, 200);
  textSize(28);
  text("you scored " + pointCounter + " points!", width/2-112, 230);
  btnRestart.display();
  knightArray.clear();

  btnShare.display();
}

void drawLevelTransition(int transcounter) {
  background(imgGameBack);
  image(imgTransition, 120, -20);
  fill(#3c2415);
  textSize(80);
  if (transcounter <= 60) {
    text("3", 300, 230);
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
  fill(255);
  if (scores.size() != 0) {
    for (int i = 0; i < scores.size (); i++) {
      text(i + 1, (width/2 - 80), (170 + (i*20)));
      text(scores.get(i).getName(), width/2-50, (170 + (i*20)));
      text(scores.get(i).getScore(), width/2 +20, (170 + (i*20)));
    }
  } else {
    text("No scores available yet!", width/2-110, height/2);
  }
}


void drawCountDown(int counter) {
  fill(255);
  textSize(120);
  if (counter <= 60) {
    text("3", 300, 230);
  } else if (counter > 60 && counter <=120) {
    text("2", 310, 230);
  } else if (counter > 120 && counter <=180) {
    text("1", 310, 230);
  }  
  if (counter == 240) {
    takePicture();
  }
}

void drawShareMenu(String filename) {
  background(imgBack);
  shareImage = loadImage(filename);
  shareImage.resize(427, 320);
  image(shareImage, width/2-200, 50);

  btnPicOk.display();
  btnPicNok.display();
}

void drawMovie() {

  infoMovie.drawMovie();
  image(movieBorder, 0, 0);
  //if the movie is finished, return to main menu
  if (infoMovie.infoMovie.time() == infoMovie.duration) {
    state = AppState.MAINMENU;
    infoMovie.isPlaying = false;
  }
}

void drawNewHiscore() {
  background(imgHiscores);

  selector.drawScoreSelector();
  if (selector.getEnteredName().length() == 3) {
    endLetters.display();
  } else {
    selectLetter.display();
  }
}

/*
=======================================
 (Almost) Always active draw methods
 =======================================
 */

void drawLeapCursor() {
  fill(255, 0, 0);
  stroke(255, 255, 255);
  for (Pointable p : leap.getPointableList ()) {
    PVector position = leap.getTip(p);
    ellipse(position.x, position.y, 10, 10);
    break;
  }
  noStroke();
}

void drawLeapLine() {

  //trail setup
  fill(255, 0, 0);
  noStroke();

  int trailLength;
  float leapX = -1;
  float leapY = -1;

  for (Pointable p : leap.getPointableList ()) {
    PVector position = leap.getTip(p);
    leapX = position.x;
    leapY = position.y;
    break;
  }

  if (leapX != -1) {
    circlePosition = new PVector(leapX, leapY);
    circleTrail.add(circlePosition);

    trailLength = circleTrail.size() - 2;

    for (int i = 0; i < trailLength; i++) {
      PVector currentTrail = circleTrail.get(i);
      PVector previousTrail = circleTrail.get(i + 1);

      stroke(255, 255*i/trailLength);
      line(currentTrail.x, currentTrail.y, previousTrail.x, previousTrail.y);
    }

    ellipse(circlePosition.x, circlePosition.y, 10, 10);

    if (trailLength >= trailSize) {
      circleTrail.remove(0);
    }
  }
}

void drawMouseLine() {
  if (leap.getPointableList().size() == 0) {

    //trail setup
    fill(255, 0, 0);
    noStroke();

    int trailLength;


    circlePosition = new PVector(mouseX, mouseY);
    circleTrail.add(circlePosition);

    trailLength = circleTrail.size() - 2;

    for (int i = 0; i < trailLength; i++) {
      PVector currentTrail = circleTrail.get(i);
      PVector previousTrail = circleTrail.get(i + 1);

      stroke(255, 255*i/trailLength);
      line(currentTrail.x, currentTrail.y, previousTrail.x, previousTrail.y);
    }

    ellipse(circlePosition.x, circlePosition.y, 10, 10);

    if (trailLength >= trailSize) {
      circleTrail.remove(0);
    }
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

void takePicture() {
  //save the image
  shareBorder = loadImage("imageBorder.png");
  image(shareBorder, 0, 0);
  Calendar cal = Calendar.getInstance();
  filename = cal.getTime().toString().replace(":", "") + ".png";
  saveFrame(filename);

  File file = new File(filename);
  if (!file.exists()) {
    state = AppState.SHARE;
  }
}

void checkKnightHit() {
  float leapX = -1;
  float leapY = -1;

  for (Pointable p : leap.getPointableList ()) {
    PVector position = leap.getTip(p);
    leapX = position.x;
    leapY = position.y;
  }

  for (int i = 0; i < knightArray.size (); i++) {
    Knight myKnight = (Knight) knightArray.get(i);
    if (dist(myKnight.getX(), myKnight.getY(), leapX, leapY) < myKnight.getRadius() && !myKnight.getIsCut() && myKnight.isBomb) {

      //subtract 100 points for hitting a bomb, prevent going negative
      int tempScore = pointCounter - 100;

      if (tempScore > 0) {
        pointCounter -= 100;
      } else {
        pointCounter = 0;
      }

      myKnight.setIsCut(true);
    } else if (dist(myKnight.getX(), myKnight.getY(), leapX, leapY) < myKnight.getRadius() && !myKnight.getIsCut() && !myKnight.isBomb) {
      myKnight.setIsCut(true);
      myKnight.setKnightIndex(myKnight.knightIndex);
      pointCounter += ((basePoints * currentLvl) + (lives * 4));
    }
  }
}

void resetGame() {
  state = AppState.MAINMENU;
  lives = 3;
  currentLvl = 1;
  rectHeight = 180;
  transcounter = 0;
  pointCounter = 0;
  timer = 0;
}

void leapButtonTriggerEvent(float x, float y) {

  if (state == AppState.MAINMENU) {

    //the most dirty code you'll ever see in your life
    for (LeapButton l : bGroup) {
      if (x > l.bX && x < l.bX + l.bWidth && y > l.bY && y < l.bY + l.bHeight) {
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
    if (x > startGame.bX && x < startGame.bX + startGame.bWidth && y > startGame.bY && y < startGame.bY + startGame.bHeight) {
      state = AppState.LEVELTRANSITION;
      pointCounter = 0;
    }

    //check hiscores button
    if (x > btnHiscores.bX && x < btnHiscores.bX + btnHiscores.bWidth && y > btnHiscores.bY && y < btnHiscores.bY + btnHiscores.bHeight) {
      state = AppState.HISCORES;
    }

    if (x > btnInfo.bX && x < btnInfo.bX + btnInfo.bWidth && y > btnInfo.bY && y < btnInfo.bY + btnInfo.bHeight) {

      if (!infoMovie.isPlaying) {
        infoMovie = new MoviePlayer(this, "movie.mov");
        infoMovie.playMovie();
      }
      state = AppState.MOVIE;
    }
  } else if (state == AppState.HISCORES) {
    //go back to menu from hiscores button 
    if (x > btnBackToMenu.bX && x < btnBackToMenu.bX + btnBackToMenu.bWidth && y > btnBackToMenu.bY && y < btnBackToMenu.bY + btnBackToMenu.bHeight) {
      state = AppState.MAINMENU;
    }
  } else if (state == AppState.LEVELCOMPLETE) {
    if (x > btnNextLevel.bX && x < btnNextLevel.bX + btnNextLevel.bWidth && y > btnNextLevel.bY && y < btnNextLevel.bY + btnNextLevel.bHeight) {

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
    if (x > btnRestart.bX && x < btnRestart.bX + btnRestart.bWidth && y > btnRestart.bY && y < btnRestart.bY + btnRestart.bHeight) {
      resetGame();
    } else if (x > btnShare.bX && x < btnShare.bX + btnShare.bWidth && y > btnShare.bY && y < btnShare.bY + btnShare.bHeight) {
      state = AppState.WEBCAM;
    }
  } else if (state == AppState.SHARE) {
    if (x > btnPicOk.bX && x < btnPicOk.bX + btnPicOk.bWidth && y > btnPicOk.bY && y < btnPicOk.bY + btnPicOk.bHeight) {
      //tweet the image
      Thread tweet = new Thread(new TwitterHandler(pointCounter, filename));
      tweet.start();
      resetGame();
      state = AppState.MAINMENU;
    } else if (x > btnPicNok.bX && x < btnPicNok.bX + btnPicNok.bWidth && y > btnPicNok.bY && y < btnPicNok.bY + btnPicNok.bHeight) {
      state = AppState.WEBCAM;
      counter = 0;
    }
  } else if (state == AppState.NEWHISCORE) {
    if (x > endLetters.bX && x < endLetters.bX + endLetters.bWidth && y > endLetters.bY && y < endLetters.bY + endLetters.bHeight && selector.getEnteredName().length() == 3) {
      state = AppState.GAMEOVER;
      HiscoreEntry newEntry = new HiscoreEntry(selector.getEnteredName(), pointCounter);
      hh.saveHiscore(newEntry);
    } else if (x > selectLetter.bX && x < selectLetter.bX + selectLetter.bWidth && y > selectLetter.bY && y < selectLetter.bY + selectLetter.bHeight) {
      selector.addLetter();
    }
  }
}

/*
=================================
 Processing + leap events
 =================================
 */

void mouseDragged() {
  stroke(225, 225, 225);
  strokeWeight(4.0);
  strokeJoin(ROUND);
  line(pmouseX, pmouseY, mouseX, mouseY);

  for (int i = 0; i < knightArray.size (); i++) {
    Knight myKnight = (Knight) knightArray.get(i);

    if (dist(myKnight.getX(), myKnight.getY(), mouseX, mouseY) < myKnight.getRadius() && !myKnight.getIsCut() && myKnight.isBomb) {
      //subtract 100 points for hitting a bomb, prevent going negative
      int tempScore = pointCounter - 100;
      if (tempScore > 0) {
        pointCounter -= 100;
      } else {
        pointCounter = 0;
      }

      myKnight.setIsCut(true);
    } else if (dist(myKnight.getX(), myKnight.getY(), mouseX, mouseY) < myKnight.getRadius() && !myKnight.getIsCut() && !myKnight.isBomb) {
      myKnight.setIsCut(true);
      myKnight.setKnightIndex(myKnight.knightIndex);
      pointCounter += ((basePoints * currentLvl) + (lives * 4));
    }
  }
}

void mousePressed() {
  leapButtonTriggerEvent(mouseX, mouseY);
}

public void screenTapGestureRecognized(ScreenTapGesture gesture) {
  float leapX = gesture.position().getX();
  float leapY = gesture.position().getY();

  for (Pointable p : leap.getPointableList ()) {
    PVector position = leap.getTip(p);
    leapX = position.x;
    leapY = position.y;
  }

  leapButtonTriggerEvent(leapX, leapY);
}

public void circleGestureRecognized(CircleGesture gesture, String clockwiseness) {
  if (state == AppState.HISCORES || state == AppState.MAINMENU) {
    if ( clockwiseness == "clockwise") {
      state = AppState.HISCORES;
    } else if (clockwiseness == "counterclockwise") {
      state = AppState.MAINMENU;
    }
  }
}

public void swipeGestureRecognized(SwipeGesture gesture) {

  if (state == AppState.NEWHISCORE) {
    if (gesture.state() == State.STATE_STOP) {
      if (gesture.direction().get(0) <= 0) {
        selector.setSelectedChar(false);
      } else {
        selector.setSelectedChar(true);
      }
    }
  }
}

void keyPressed() {
  if (state == AppState.NEWHISCORE) {
    if (key == BACKSPACE) {
      //remove letter here
      if (selector.getEnteredName().length() != 0) {
        StringBuilder sb = new StringBuilder(selector.getEnteredName());
        sb.deleteCharAt(sb.length() - 1);
        selector.setEnteredName(sb.toString());
      }
    }
  }
}

void movieEvent(Movie m) {
  m.read();
}

