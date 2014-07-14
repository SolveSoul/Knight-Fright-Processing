/*

This class represents the objects that will be able to be cut by the sword.

*/

class Knight {

  // INSTANCE VARIABLES
  private float x = 0;
  public float y = 0;
  private float speedX = 0;
  private float speedY = 0;
  
  private float r = 0;
  private PImage apple;
  private float deg;
  private String appleString;

  // CONSTRUCTOR
  public Knight(float _x, float _y){
    x = _x;
    y = _y;
    speedX = random(-2, 2);
    speedY = random(-15, -10);
    r = 50;
    appleString = "apple.png";
    apple = loadImage("apple.png");
  }

  // METHODS
  
  private void gravity()
  {
    speedY += 0.2;
  }

  public void setAppleString(String appleString) {
    this.appleString = appleString;
  }

  public String getAppleString() {
    return this.appleString;
  }

  public void setApple(PImage apple) {
    this.apple = apple;
  }

  public PImage getApple() {
    return this.apple;
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

  public void run()
  {
    display();
    move();
    bounce();
    gravity();
  }


  private void bounce()
  {
    if ((x >= width - r && speedX > 0) || (x < r && speedX < 0))
    {
      speedX = speedX * (-1);
    }
    if (y <  0)
    {
      speedY = speedY * (-1);
    }
  }


  private void move()
  {
    x += speedX;
    y += speedY;
  }
  
  public void display()
  {
    image(apple, x, y);
  }
}

