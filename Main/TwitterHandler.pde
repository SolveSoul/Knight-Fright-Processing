import java.io.FileReader;

class TwitterHandler {

  //tokens
  private String apiConsumerKey;
  private String apiConsumerKeySecret;
  private String accessToken;
  private String accessTokenSecret;
  
  //fields
  private Twitter twitter;
  private static final String FILENAME = "twitterkeys.csv";

  //ctor
  public TwitterHandler() {

    boolean success = getApiKeys();

    if (success) {
      //configure
      ConfigurationBuilder cb = new ConfigurationBuilder();
      cb.setOAuthConsumerKey(apiConsumerKey);
      cb.setOAuthConsumerSecret(apiConsumerKeySecret);
      cb.setOAuthAccessToken(accessToken);
      cb.setOAuthAccessTokenSecret(accessTokenSecret);

      //assign local var
      TwitterFactory tf = new TwitterFactory(cb.build());
      twitter = tf.getInstance();
    } else {
      println("Could not load the apikeys, are you missing the " + FILENAME + " file?");
    }
  }

  public void tweetScore(int score, String imageName) {
    try {
      StatusUpdate status = new StatusUpdate("I just scored " + score + " on game X. Can you do better?");
      File img = new File(sketchPath(imageName));
      status.setMedia(img);
      twitter.updateStatus(status);
    } 
    catch (TwitterException ex) {
      println("Error: " + ex.getMessage());
    }
  }

  public boolean getApiKeys() {
    
    //Input file which needs to be parsed
    String fileToParse = dataPath(FILENAME);
    BufferedReader fileReader = null;

    //Delimiter used in CSV file
    final String DELIMITER = ";";
    try {
      String line = "";
      //Create the file reader
      fileReader = new BufferedReader(new FileReader(fileToParse));

      //Read the file line by line
      while ( (line = fileReader.readLine ()) != null) {
        //Get all tokens available in line
        String[] tokens = line.split(DELIMITER);
        
        for(int i = 0; i < tokens.length; i += 2){
          if(tokens[i].equals("apikey")){
            apiConsumerKey = tokens[i + 1];
          }else if(tokens[i].equals("apisecret")){
            apiConsumerKeySecret = tokens[i + 1];
          }else if(tokens[i].equals("accesstoken")){
            accessToken = tokens[i + 1];
          } else if(tokens[i].equals("accesstokensecret")){
            accessTokenSecret = tokens[i + 1];
          }
        }
      }
      
      return true;
      
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    } 
    finally{
      try {
        fileReader.close();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  }
}

