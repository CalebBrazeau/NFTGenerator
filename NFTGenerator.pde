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
  size(400,400);// Canvas size/NFT resolution
  gen(2); // Number of NFT's to generate
}

/**
* Generate passed in number of NFT's
* @param amount integer representing the number of NFT files to generate
* @exception Any exception
* @return No return value.
*/
void gen(int amount) {
  long startTime = System.currentTimeMillis(); // Log initial system time
  
  // Loop to generate specified number of NFT's
  for(int i = 0; i < amount; i++) {
    initializeMetaData(i);
    // Create new NFT Object
    NFT nft = new NFT();
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
      shareTotal += i;
      if(shareTotal > 100) throw new UhOh("Share total greater than 100! Total: " + shareTotal);
    } 
    if(shareTotal < 100) throw new UhOh("Share total less than 100! Total: " + shareTotal);
    // Check if seller royalties are valid
    if(sellerRoyalties > 10000 || sellerRoyalties < 0) throw new UhOh("Seller royalties greater than 10000 or less than 0! Royalties: " + sellerRoyalties);
    metaData.setString("name", NFTName + " #" + (id + 1));
    metaData.setString("description", NFTDescription);
    metaData.setInt("seller_fee_basis_points", sellerRoyalties);
    metaData.setString("symbol", "");
    metaData.setString("uri", NFTUri);

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
    else {
      throw new UhOh("Creator Address array and Creator Share array do not share the same length!" + 
      "\nCreator Address Length: " + creatorAddress.length + "\nCreator Share Length: " + creatorShare.length);
    }
  } catch(UhOh e) {
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
  
  int jsonIndex = 0;
  
 /**
 * Generate passed in number of NFT's
 * @exception Any exception
 * @return No return value.
 */
 NFT() {
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
   if(doRandomBgColor) { // If user wants random background colors
     // Generate random color using min and max numbers
     color bc = color(rand.random(bgMin,bgMax),rand.random(bgMin,bgMax),rand.random(bgMin,bgMax));
     background(bc); // Set canvas background color
     addAttributes("background", hex(bc,6)); // Add color to meta data
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
     String assetName = getAssetName(asset); // Get and store split asset name
     if(!assetName.equalsIgnoreCase("none"))
       addAttributes(assetName, getFolderName(assets[i][0].toString()));
       
     println(asset); // Print loaded asset
     
     PImage img = loadImage(assetPath + "/" + assets[i][0] + "/" + asset); // Load retrieved asset as an image
     image(img,0,0); // Load image on the canvas
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
   String[] rarity = asset.split("#"); // Cut asset name off of asset
   rarity = rarity[1].split("\\.png"); // Cut '.png' off of rarity number
   return float(rarity[0]); // Return rarity as float
 }
 
 /**
 * Parse and return asset name (waterfall #50.png = waterfall)
 * @param asset String containing original file name (waterfall #50.png)
 * @exception Any exception
 * @return String of properly parsed file name (waterfall)
 */
 String getAssetName(String asset) {
   String[] cutRarity = asset.split("#"); // Cut #<int>.png off asset
   cutRarity = cutRarity[0].split(" "); // Cut trailing space off asset
   return cutRarity[0]; // Return asset name (Crystal_Green_Gen5)
 }
 
 /**
 * Parse folder name (a - background) and return folder name to be used as trait type (background)
 * @param asset String containing complete file name of an asset (img #100.png)
 * @exception Any exception
 * @return String value of parsed folder name (background)
 */
 String getFolderName(String folder) {
   String[] parse = folder.split(" "); // Split on spaces
   // Return 3rd element, if following folder conventions will be trait_type (background)
   return parse[2];
 }
}

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
