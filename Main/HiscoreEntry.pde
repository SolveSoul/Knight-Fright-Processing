class HiscoreEntry implements Comparable<HiscoreEntry> {

  //fields
  private String name;
  private int score;

  //getters & setters
  public String getName() {
    return this.name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public int getScore() {
    return this.score;
  }

  public void setScore(int score) {
    this.score = score;
  }

  //ctor
  public HiscoreEntry(String name, int score) {
    this.name = name;
    this.score = score;
  }

  @Override
  public String toString() {
    return this.name + " - " +  this.score;
  }

  @Override
  public boolean equals(Object obj) {
      
    if (obj == null || obj.getClass() != this.getClass()) {
      return false;
    }

    HiscoreEntry entry = (HiscoreEntry)obj;
    if (this.getScore() != entry.getScore()) {
      return false;
    } else {
      return true;
    }
  }
  
   @Override
    public int compareTo(HiscoreEntry other){
      return ((Integer)this.score).compareTo(other.score);
    }
  
  
}

