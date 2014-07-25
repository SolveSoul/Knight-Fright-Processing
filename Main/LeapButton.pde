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

  public LeapButton(float bX, float bY, float bWidth, float bHeight, String labelText) {
    this.bWidth = bWidth;
    this.bHeight = bHeight;
    this.bX = bX;
    this.bY = bY;
    this.labelText = labelText;
    this.labelColor = #3c2415;
    this.rectColor = 255;
    this.strokeColor = 0;
    this.strokeThickness = 3;
  }

  public void display() {
    textAlign(CENTER);

    if (isSelected) {
      stroke(strokeColor);
      strokeWeight(strokeThickness);
    }

    fill(rectColor,90);
    rect(bX, bY, bWidth, bHeight);

    fill(labelColor);
    text(labelText, bX + bWidth/2, bY + bHeight/2 + 5);

    noStroke();
    textAlign(CORNER);
    
  }

  @Override
    public String toString() {
    return this.labelText;
  }
}

