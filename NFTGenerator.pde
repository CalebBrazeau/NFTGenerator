/**
* NFTGenerator --- Program that layers assets together to generate NFT's and their meta data
* @author Caleb Brazeau
*/
import java.io.File;
import java.util.ArrayList;

// JSON Objects for NFT Meta Data
JSONObject metaData;
JSONArray metaAttributes;

// Generate random background color for NFT project
// RGB range 30-255 to prevent pitch black NFT's
boolean doRandomBgColor = true;
// Min max RGB Color for random background
int bgMin = 30;
int bgMax = 256;

// NFT Info for meta data generation
String NFTName = "Geode";
String NFTDescription = "An exclusive collection of <int> unique Geode NFT's grown in the Solana blockchain";
String collectionName = "Geode";
String NFTUri = "uri.uri.com";
// 0-10000 royalties are divided by 100 for percentage, i.e. 1000 would be 10%
int sellerRoyalties = 1000;

String[] creatorAddress = {"FDkhgyjVzJHjefCeHmTav4JgZiJqdQmEjMHjWk7FzvRe"}; // Address for share payment in metadata

int[] creatorShare = {100}; // Creator share should total no more than 100 

/**
* Setup canvas size and run initial code
* @exception Any exception
* @return No return value.
*/
void setup(){
  // Canvas size/NFT resolution
  size(400,400);
  // Number of NFT's to generate
  gen(2);
}

/**
* Generate passed in number of NFT's
* @param amount integer representing the number of NFT files to generate
* @exception Any exception
* @return No return value.
*/
void gen(int amount) {
  // Log initial system time
  long startTime = System.currentTimeMillis();
  
  // Loop to generate specified number of NFT's
  for(int i = 0; i < amount; i++) {
    // Initialize meta data file
    initializeMetaData(i);
    
    // Create new NFT Object
    NFT nft = new NFT();
    
    // Add generated attributes array to meta data file 
    metaData.setJSONArray("attributes", metaAttributes);
    
    // Save generated NFT
    save("gen/" + i + ".png");
    saveJSONObject(metaData, "gen/" + i + ".json");
    
    // Log saved image, helps show progression so you know the program is working
    println("Saved: " + i + ".png");
  } 
  // Log completion time in seconds and milliseconds
  println((System.currentTimeMillis() - startTime) / 1000 + " seconds");
  println((System.currentTimeMillis() - startTime) + " milliseconds");
}

/**
* Initializes meta data file with params assigned at top of file
* @param id Integer representing current id of NFT being generated
* @exception UhOh if certain values are out of range or incomplete
* @return No return value.
*/
void initializeMetaData(int id) {
  try {
    // Create/Reset meta data JSON object
    metaData = new JSONObject();
    metaAttributes = new JSONArray();
    
    // Check if creator shares are valid
    int shareTotal = 0;
    for(int i:creatorShare) {
      // Add share index to total 
      shareTotal += i;
      // If share total is greater than 100, Throw exception
      if(shareTotal > 100) throw new UhOh("Share total greater than 100! Total: " + shareTotal);
    } 
    // If share total is less than 100, Throw exception
    if(shareTotal < 100) throw new UhOh("Share total less than 100! Total: " + shareTotal);
    // Check if seller royalties are valid
    if(sellerRoyalties > 10000 || sellerRoyalties < 0) throw new UhOh("Seller royalties greater than 10000 or less than 0! Royalties: " + sellerRoyalties);
    
    metaData.setString("name", NFTName + " #" + (id + 1));
    metaData.setString("description", NFTDescription);
    metaData.setInt("seller_fee_basis_points", sellerRoyalties);
    metaData.setString("symbol", "");
    metaData.setString("uri", NFTUri);

    // If creator address array and creator share array are the same length
    if(creatorAddress.length == creatorShare.length) {
      // Array containing creator(s) address and share percentage
      JSONArray creatorInfo = new JSONArray();
      // Loop through each creatorAddress and add their address and share to meta data
      for(int i = 0; i < creatorAddress.length; i++) {
        JSONObject info = new JSONObject();
        info.setString("address", creatorAddress[i]);
        info.setInt("share", creatorShare[i]);
        creatorInfo.setJSONObject(i,info);
        metaData.setJSONArray("creators", creatorInfo);
      }
    }
    else { // Frowed Up
      throw new UhOh("Creator Address array and Creator Share array do not share the same length!" + 
      "\nCreator Address Length: " + creatorAddress.length + "\nCreator Share Length: " + creatorShare.length);
    }
  } catch(UhOh e) { // Uh Oh
    // Print and exit program
    println(e);
    System.exit(0);
  }
}
class NFT { 
  // New PRNG object
  Rand rand = new Rand();
  
  // Current path
  String path = sketchPath();
  // Append '/assets' to file path 
  File assetPath = new File(path + "/assets");
  
  // Array to initially store all asset files and their directories
  Object[][] assets;
  
  // Attribute index for JSON array
  int jsonIndex = 0;
  
 /**
 * Generate passed in number of NFT's
 * @exception Any exception
 * @return No return value.
 */
 NFT() {
   // Load assets from assets folder
   loadAssets();
 }
 /**
 * Load assets contained in 'assets' folder
 * @exception Any exception
 * @return No return value.
 */
 void loadAssets() {
   // Path to inside asset folder
   File tempPath = new File(assetPath + "/");
   // Array of contents in asset folder
   String[] assetFolders =  tempPath.list();
   
   //TODO: Dynamic length for second number
   // Array to contain assets
   assets = new Object[assetFolders.length][10];
   
   for(int i = 0; i < assetFolders.length; i++) {
     // Path to folder in assets folder
     File asset = new File(assetPath + "/" + assetFolders[i]);
     // array of contents inside the specified folder in assets folder
     String[] tmp = asset.list();
     
     // array list to store contents of each folder
     ArrayList<String> folderContents = new ArrayList<String>();
     
     // add folder name to arraylist
     folderContents.add(assetFolders[i]);
     
     // loop through each asset in contents array
     for(String s: tmp) {
       // add each asset to ArrayList
       folderContents.add(s);
     }
     // Convert ArrayList to array and append to assets array
     assets[i] = folderContents.toArray();
   }
   // Select assets to be used
   selectAssets(assets);
 }
 
 /**
 * Randomly select assets from array and load them if their rarity is matched by the PSRG number
 * @param assets Object array containing every loaded asset from 'assets' folder
 * @exception Any exception
 * @return No return value
 */
 void selectAssets(Object[][] assets) {
   // If user wants random background colors
   if(doRandomBgColor) {
     // Generate random color using min and max numbers
     color bc = color(rand.random(bgMin,bgMax),rand.random(bgMin,bgMax),rand.random(bgMin,bgMax));
     // Set canvas background color
     background(bc);
     // Add color to meta data
     addAttributes("background", hex(bc,6));
   }
   
   // Loop through assets array
   for(int i = 0; i < assets.length - 1; i++) {
     // Get random asset from assets array
     String asset = assets[i][int(rand.random(1, assets[i].length))].toString();
     
     // While rarity of retreived asset is less than returned random number
     while(getRarity(asset) < rand.random(0,100)) {
       // Reload random asset from assets array
       asset = assets[i][int(rand.random(1, assets[i].length))].toString();
     }
     // Get and store split asset name
     String assetName = getAssetName(asset);
     
     // If returned asset name is not equal to 'none'
     if(!assetName.equalsIgnoreCase("none"))
       // Add the attribute to meta data
       addAttributes(getFolderName(assets[i][0].toString()), assetName);
       
     println(asset); // Print loaded asset ****** to be removed ******
     
     // Load retrieved asset as an image
     PImage img = loadImage(assetPath + "/" + assets[i][0] + "/" + asset);
     // Load image on the canvas
     image(img,0,0);
   }
 }

 /**
 * Add selected asset attributes to NFT meta data
 * @param attr String containing attribute value to be added to meta data (waterfall)
 * @param folder String containing trait type value for meta data (background)
 * @exception Any exception
 * @return No return value
 */
 void addAttributes(String attr, String traitType) {
   // Crete new JSON object for asset attributes
   JSONObject attribute = new JSONObject();
   
   // Set asset trait_type and value
   attribute.setString("trait_type", traitType);
   attribute.setString("value", attr);
   
   // Add attribute object to metaAttributes array
   metaAttributes.setJSONObject(jsonIndex, attribute);
   
   // Increment jsonIndex for proper placement in metaAttributes array
   jsonIndex++;
 } //<>//
 /**
 * Parse and return rarity of an asset
 * @param asset String containing complete file name of an asset (img #100.png)
 * @exception Any exception
 * @return Float value of parsed asset rarity
 */
 float getRarity(String asset) {
   try {
     // Cut asset name off of asset
     String[] rarity = asset.split("#");
     
     // If there was no defined rarity throw exception
     if(rarity.length == 1) throw new UhOh("No rarity found, defaulting to 100!");
     
     // Cut '.png' off of rarity number
     rarity = rarity[1].split("\\.png");
     
     // Return rarity as float
     return float(rarity[0]);
   } catch(UhOh e) { // I frowed up :(
     // Print and return default value
     println(e);
     return 100.0;
   }
 }
 
 /**
 * Parse and return asset name (waterfall #50.png = waterfall)
 * @param asset String containing original file name (waterfall #50.png)
 * @exception Any exception
 * @return String of properly parsed file name (waterfall)
 */
 String getAssetName(String asset) {
   try { //<>//
     // Cut #<rarity>.png off asset
     String[] assetName = asset.split("#");
     
     // If there is no defined rarity throw exception
     if(assetName.length == 1) throw new UhOh("No rarity found!");
     
     // Cut trailing space off asset
     assetName = assetName[0].split(" ");
     
     // Return asset name (Crystal_Green_Gen5)
     return assetName[0];
   } catch(UhOh e) { // Throws when missing rarity
   // ******************* Still in Development :) **************
     println(e);
     //return "idkman"; // Return asset name
     return "idkman";
   }
 }
 
 /**
 * Parse folder name (a - background) and return folder name to be used as trait type (background)
 * @param asset String containing complete file name of an asset (img #100.png)
 * @exception Any exception
 * @return String value of parsed folder name (background)
 */
 String getFolderName(String folder) {
   // Split on spaces
   String[] parse = folder.split(" ");
   
   // Return 3rd element, if following folder conventions will be trait_type (background)
   return parse[2];
 }
}

// 100% Stole this from somwhere, idk where the link went
class Rand { 
  long seed;
  long a;
  long c;
  long m32;
  
  Rand() {
    this(System.currentTimeMillis());
  }
  Rand(long seed) {
    this.a = 1664525;
    this.c = 1013904223;
    this.m32 = 0xFFFFFFFFL;
    this.randomSeed(seed);
  }
  long nextLong() {
    this.seed = this.seed * a + c & m32;
    return this.seed;
  }
  int nextInt() {
    return (int)(this.nextLong()%Integer.MAX_VALUE);
  }
  void randomSeed(long newSeed) {
    this.seed = newSeed%Integer.MAX_VALUE;
  }
  float random() {
    return random(0,1);
  }
  float random(float max) {
    return random(0, max);
  }
  float random(float min, float max) {
    return map(this.nextInt(), 0, Integer.MAX_VALUE, min, max);
  }
}
public class UhOh extends Exception {
  public UhOh(String errorMessage) {
    super(errorMessage);
  }
}
