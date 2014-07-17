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
  private PImage knight;
  private float deg;
  private String knightString;

  //ctor
  public Knight(float _x, float _y) {
    x = _x;
    y = _y;
    speedX = random(-2, 2);
    speedY = random(-15, -10);
    r = 50;
    knightString = "apple.png";
    knight = loadImage("apple.png");
  }

  //getters & setters
  public void setKnightString(String knightString) {
    this.knightString = knightString;
  }

  public String getKnightString() {
    return this.knightString;
  }

  public void setKnight(PImage knight) {
    this.knight = knight;
  }

  public PImage getKnight() {
    return this.knight;
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


  //main logic
  public void run() {
    display();
    move();
    bounce();
    gravity();
  }

  private void gravity(){
    speedY += 0.2;
  }

  private void bounce(){
    if ((x >= width - r && speedX > 0) || (x < r && speedX < 0))
    {
      speedX = speedX * (-1);
    }
    if (y <  0)
    {
      speedY = speedY * (-1);
    }
  }


  private void move(){
    x += speedX;
    y += speedY;
  }

  public void display(){
    image(knight, x, y);
  }
}

