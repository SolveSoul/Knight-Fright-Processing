/*
 Based upon the code of Jose Salvatierra, thanks!
 This class represents the objects that will be able to be cut by the sword.
 */

class Knight {

  //fields
  private float x = 0;
  public float y = 0;
  private float speedX = 0;
  private float speedY = 0;

  private float r = 0;
  private PImage currentKnight;
  private float deg;
  private boolean isCut;
  private boolean isBomb;
  private int knightIndex;

  private ArrayList<PImage> images;
  private ArrayList<PImage> cutImages;
  private PImage bombImage;
  private PImage cutBombImage;
  Difficulty diff;

  //ctor
  public Knight(float x, float y) {
    listSetup();
    knightSetup();
    this.bombImage = loadImage("tonTnt.png");
    this.cutBombImage = loadImage("boom.png");
    this.x = x;
    this.y = y;
    
    this.speedX = random(-2, 2);
    this.speedY = random(-15, -10);
    this.r = 62;
  }

  //getters & setters
  public void setIsCut(boolean value) {
    this.isCut = value;
  }

  public boolean getIsCut() {
    return this.isCut;
  }

  public void setCurrentKnight(PImage knight) {
    this.currentKnight = currentKnight;
  }

  public PImage getCurrentKnight() {
    return this.currentKnight;
  }

  public float getX() {
    return this.x;
  }

  public float getY() {
    return this.y;
  }

  public float getRadius() {
    return this.r;
  }

  private void setKnightIndex(int index) {
    this.currentKnight = images.get(index);
  }

  //main logic
  public void run() {
    display();
    move();
    bounce();
    gravity();
  }

  private void listSetup() {
    //init lists
    this.images = new ArrayList<PImage>();
    this.cutImages = new ArrayList<PImage>();

    //add the images
    this.images.add(loadImage("blue.png"));
    this.cutImages.add(loadImage("blueCut.png"));
    this.images.add(loadImage("red.png"));
    this.cutImages.add(loadImage("redCut.png"));
    this.images.add(loadImage("green.png"));
    this.cutImages.add(loadImage("greenCut.png"));
    this.images.add(loadImage("yellow.png"));
    this.cutImages.add(loadImage("yellowCut.png"));
  }

  private void knightSetup() {
    this.knightIndex = (int)(random(0, 4));
    this.currentKnight = images.get(this.knightIndex);
    this.isBomb = (random(8)<1); 
  }

  private void gravity() {
    speedY += 0.2;
  }

  private void bounce() {
      
    if ((x >= width - r && speedX > 0) || (x < r && speedX < 0)) {
      speedX = speedX * (-0.2);
    }
    if (y <  0) {
      speedY = speedY * (-0.2);
    }
  }

  private void move() {
    x += speedX;
    y += speedY;
  }

  public void display() {
    if (!isBomb) {
      if (!isCut) {
        image(images.get(knightIndex), x, y);
      } else {
        image(cutImages.get(knightIndex), x, y);
      }
    } else {
      if (!isCut) {
        image(bombImage, x, y);
      } else 
        image(cutBombImage, x, y);
      }
    }
  }

