import java.util.Collections;

class HiscoreHandler {

  //fields
  private static final String FILENAME = "hiscores.csv";
  private ArrayList<HiscoreEntry> entries;

  //ctor
  public HiscoreHandler() {
    if (!doesFileExist()) {
      createHiscoreFile();
    }
    entries = new ArrayList<HiscoreEntry>();
  }
  
  //getters & setters
  private ArrayList<HiscoreEntry> getHiscores(){
    loadHiscores();
    sortHiscores();
    return this.entries;
  }
  
  //main logic
  private void loadHiscores() {
    String fileToParse = dataPath(FILENAME);
    BufferedReader fileReader = null;
    final String DELIMITER = ";";
    try {
      String line = "";
      //Create the file reader
      fileReader = new BufferedReader(new FileReader(fileToParse));

      //Read the file line by line
      while ( (line = fileReader.readLine ()) != null) {
        String[] entries = line.split(DELIMITER);

        for (int i = 0; i < entries.length; i += 2) {
          HiscoreEntry entry = new HiscoreEntry(entries[i], Integer.parseInt(entries[i + 1]));
          this.entries.add(entry);
        }
      }
    } 
    catch (Exception e) {
      e.printStackTrace();
    } 
    finally {
      try {
        fileReader.close();
      } 
      catch (IOException e) {
        e.printStackTrace();
      }
    }
  }
  
  public boolean saveHiscore(HiscoreEntry entry){
    
    //if the passed entry was null, there's no need to continue
    if(entry == null){
      println("The passed entry was null");
      return false;
    }
    
    //get all the up-to-date data from the csv file
    entries = getHiscores();
   
   //add the new entry and sort it
   entries.add(entry);
   sortHiscores();
   
   //remove the last entry if the list has become longer than 10 entries
   while(entries.size() >= 11){
     HiscoreEntry e = entries.get(entries.size() - 1);
     entries.remove(e);
   }
 
   //the list is perfect now, we can rewrite it to the csv file
   try{
     PrintWriter writer = new PrintWriter(dataPath(FILENAME), "UTF-8");
     for(HiscoreEntry e : entries){
       writer.println(e.getName() + ";" + e.getScore());

     }
  
         writer.close();
     
      return true; 
    } catch(Exception ex){
      ex.printStackTrace();
      return false;
    }
    
  }
  
  //Helpful methods
  private boolean doesFileExist() {
    File f = new File(dataPath(FILENAME));

    if (f.exists() && !f.isDirectory()) {
      return true;
    } else {
      return false;
    }
  }

  private void createHiscoreFile() {
    try {
      File f = new File(dataPath(FILENAME));
      f.createNewFile();
    } 
    catch(Exception ex) {
      println(ex.getMessage());
    }
  }
  
  private void sortHiscores(){
    Collections.sort(this.entries);
    Collections.reverse(this.entries);
  }
  
}

