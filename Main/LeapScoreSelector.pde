class LeapScoreSelector {

  //fields
  private String[] alphabet = {
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "_"
  };
  private int selectedChar = 0;
  private String enteredName = "";

  //getters & setters
  public int getSelectedChar() {
    return this.selectedChar;
  }

  public void setSelectedChar(boolean isRight) {

    if (isRight) {

      if (this.selectedChar == alphabet.length - 1) {
        this.selectedChar = 0;
      } else {  
        this.selectedChar++;
      }
    } else {

      if (this.selectedChar == 0) {
        this.selectedChar = alphabet.length - 1;
      } else {
        this.selectedChar--;
      }
    }
  }
  
  public String getEnteredName(){
    return this.enteredName;
  }
  
  public void setEnteredName(String name){
     this.enteredName = name;
  }
  
  //methods
  public void drawScoreSelector() {
    textSize(75);
    noStroke();
    rectMode(CENTER);
    fill(255, 255, 255, 80);
    rect(width/2, height/2 - 15, 100, 100);
    rectMode(CORNER);
    fill(#3c2415);
    textAlign(CENTER);

    //draw the currently entered name
    text(enteredName, width/2, height/2 + 100);
    
    //draw the letters to select
    if (selectedChar == 0) {
      text(alphabet[alphabet.length - 1], width/2 - 100, height/2);
      text(alphabet[selectedChar], width/2, height/2);
      text(alphabet[selectedChar + 1], width/2 + 100, height/2);
    } else if (selectedChar == alphabet.length - 1) {
      text(alphabet[selectedChar - 1], width/2 - 100, height/2);
      text(alphabet[selectedChar], width/2, height/2);
      text(alphabet[0], width/2 + 100, height/2);
    } else {
      text(alphabet[selectedChar - 1], width/2 - 100, height/2);
      text(alphabet[selectedChar], width/2, height/2);
      text(alphabet[selectedChar + 1], width/2 + 100, height/2);
    }
  }
  
  public void addLetter(){
    this.enteredName += alphabet[selectedChar];
  }
}

