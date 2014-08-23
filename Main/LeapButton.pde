/*
Custom buttons that'll work with the LeapMotion.
 The isSelected property indicates whether or not the button can be selected with a stroke highlight.
 */

class LeapButton {

  private float bWidth;
  private float bHeight;
  private float bX;
  private float bY;
  private String labelText;

  private boolean isSelected;
  private int strokeThickness;

  private color labelColor;
  private color rectColor;
  private color strokeColor;
  private PImage icon;


  public void setLabelColor(color lColor) {
    this.labelColor = lColor;
  }

  public void setRectColor(color rColor) {
    this.rectColor = rColor;
  }

  public void setIsSelected(boolean value) {
    this.isSelected = value;
  }

  public boolean getIsSelected() {
    return this.isSelected;
  }

  public String getLabelText() {
    return this.labelText;
  }

  public void setStrokeColor(int thickness) {
    this.strokeThickness = thickness;
  }

  //ctor with text
  public LeapButton(float bX, float bY, float bWidth, float bHeight, String labelText) {
    this.bWidth = bWidth;
    this.bHeight = bHeight;
    this.bX = bX;
    this.bY = bY;
    this.labelText = labelText;
    this.labelColor = #3c2415;
    this.rectColor = 255;
    this.strokeColor = #3c2415;
    this.strokeThickness = 3;
  }

  //ctor with image
  public LeapButton(float bX, float bY, float bWidth, float bHeight, PImage icon) {
    this.bWidth = bWidth;
    this.bHeight = bHeight;
    this.bX = bX;
    this.bY = bY;
    this.labelColor = #3c2415;
    this.rectColor = 255;
    this.strokeColor = #3c2415;
    this.strokeThickness = 3;
    this.icon = icon;
  }

  public void display() {
    textAlign(CENTER);
    textSize(30);
    
    if (isSelected) {
      stroke(strokeColor);
      strokeWeight(strokeThickness);
    }

    fill(rectColor, 90);
    rect(bX, bY, bWidth, bHeight);

    if (icon == null) {
      fill(labelColor);
      text(labelText, bX + bWidth/2, bY + bHeight/2 + 5);
    } else {
      image(icon, bX + bWidth/2 -50, bY + bHeight/2-20);
    }


    noStroke();
    textAlign(CORNER);
  }

  @Override
    public String toString() {
    return this.labelText;
  }
}

