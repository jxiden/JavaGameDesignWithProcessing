/* Game Class Starter File
 * Last Edit: 12/13/2022
 * Authors: _____________________
 */

//GAME VARIABLES
private int msElapsed = 0;
Grid grid = new Grid(10,10);
PImage bg;
PImage player1;
PImage endScreen;
String titleText = "Peter the Horse is here";
String extraText = "Whose Turn?";
AnimatedSprite exampleSprite;
AnimatedSprite exampleSprite2;
AnimatedSprite slime;
boolean doAnimation;

//HexGrid hGrid = new HexGrid(3);
//import processing.sound.*;
//SoundFile song;

int player1Row = 0;
int player1Col = 0;


//Required Processing method that gets run once
void setup() {

  //Match the screen size to the background image size
  size(800, 600);

  //Set the title on the title bar
  surface.setTitle(titleText);

  //Load images used
  //bg = loadImage("images/chess.jpg");
  bg = loadImage("images/Backrooms-Games.png");
  bg.resize(800,600);
  player1 = loadImage("images/LetterS.png");
  player1.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
  endScreen = loadImage("images/youwin.png");

  // Load a soundfile from the /data folder of the sketch and play it back
  // song = new SoundFile(this, "sounds/Lenny_Kravitz_Fly_Away.mp3");
  // song.play();

  
  //Animation & Sprite setup
  exampleAnimationSetup();

  imageMode(CORNER);    //Set Images to read coordinates at corners
  //fullScreen();   //only use if not using a specfic bg image
  
  println("Game started...");
  
}

//Required Processing method that automatically loops
//(Anything drawn on the screen should be called from here)
void draw() {

  updateTitleBar();

  if (msElapsed % 300 == 0) {
    populateSprites();
    moveSprites();
  }

  updateScreen();
  
  if(isGameOver()){
    endGame();
  }

  checkExampleAnimation();
  
  msElapsed +=10;
  grid.pause(10);

}

  //Known Processing method that automatically will run whenever a key is pressed
  void keyPressed(){

    //check what key was pressed
    System.out.println("Key pressed: " + keyCode); //keyCode gives you an integer for the key

    //What to do when a key is pressed?
    
    // W KEY (UP)
    if(keyCode == 87){

    slime.animateMove(0.0, -0.5, 0.1, true);

      System.out.println(grid.getTileWidthPixels());
      player1 = loadImage("images/LetterW.png");
      player1.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
      //check case where out of bounds

      if (player1Row != 0) {
      //change the field for player1Row
      player1Row--;

      //shift the player1 picture up in the 2D array
      //GridLocation loc = new GridLocation(player1Row, player1Col);
      //grid.setTileImage(loc, player1);

      //eliminate the picture from the old location
      }
    }
    
    // S KEY (DOWN)
    if(keyCode == 83){

    slime.animateMove(0.0, 0.5, 0.1, true);

      System.out.println(grid.getTileHeightPixels());
      player1 = loadImage("images/LetterS.png");
      player1.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
      //check case where out of bounds
      if (player1Row != grid.getNumRows()-1) {
      //change the field for player1Row
      player1Row++;

      //shift the player1 picture down in the 2D array
      GridLocation loc = new GridLocation(player1Row, player1Col);
      grid.setTileImage(loc, player1);

      //eliminate the picture from the old location
      }
    }
    
    // A KEY (LEFT)

    if(keyCode == 65){

      slime.animateMove(-0.5, 0.0, 0.1, true);

      player1 = loadImage("images/LetterA.png");
      player1.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
      //check case where out of bounds
      if (player1Col != 0) {
      //change the field for player1Col
      player1Col--;

      //shift the player1 picture left in the 2D array
      GridLocation loc = new GridLocation(player1Row, player1Col+1);

      //eliminate the picture from the old location
      grid.clearTileImage(loc);
      }

      //This is example code for if you want the player to loop around!
      /**
      else {
        GridLocation loc = new GridLocation(player1Row, grid.getCols()-1);
        grid.setTileImage(loc,player1);
        player1Col = grid.getCols()-1;
      }
      **/
    }

    // D KEY (RIGHT)
    if(keyCode == 68){

      slime.animateMove(0.5, 0.0, 0.1, true);


      player1 = loadImage("images/LetterD.png");
      player1.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
      //check case where out of bounds
      if (player1Col != grid.getNumCols()-1) {
      //change the field for player1Col
      player1Col++;

      //shift the player1 picture right in the 2D array
      GridLocation loc = new GridLocation(player1Row, player1Col);
      grid.setTileImage(loc, player1);

      //eliminate the picture from the old location
      }
    }
  }

  //Known Processing method that automatically will run when a mouse click triggers it
  void mouseClicked(){
  
    //check if click was successful
    System.out.println("Mouse was clicked at (" + mouseX + "," + mouseY + ")");
    System.out.println("Grid location: " + grid.getGridLocation());

    //what to do if clicked? (Make player1 disappear?)


    //Toggle the animation on & off
    doAnimation = !doAnimation;
    System.out.println("doAnimation: " + doAnimation);
    grid.setMark("X",grid.getGridLocation());
    
  }



//------------------ CUSTOM  METHODS --------------------//

//method to update the Title Bar of the Game
public void updateTitleBar(){

  if(!isGameOver()) {
    //set the title each loop
    surface.setTitle(titleText + "    " + extraText);

    //adjust the extra text as desired
  
  }

}

//method to update what is drawn on the screen each frame
public void updateScreen(){

  //update the background
  background(bg);

  //Display the Player1 image
  GridLocation player1Loc = new GridLocation(player1Row,player1Col);
  grid.setTileImage(player1Loc, player1);
  
  //Loop through all the Tiles and display its images/sprites
  

      //Store temporary GridLocation
      
      //Check if the tile has an image/sprite 
      //--> Display the tile's image/sprite



  //Update other screen elements
  grid.showImages();
  grid.showSprites();

}

//Method to populate enemies or other sprites on the screen
public void populateSprites(){
  
  //What is the index for the last column?
  

  //Loop through all the rows in the last column
  
    //Generate a random number
    

    //10% of the time, decide to add an enemy image to a Tile
    

}

//Method to move around the enemies/sprites on the screen
public void moveSprites(){

//Loop through all of the rows & cols in the grid
  
      //Store the 2 tile locations to move

      //Check if the current tile has an image that is not player1      


        //Get image/sprite from current location


        //CASE 1: Collision with player1


        //CASE 2: Move enemy over to new location

        
        //Erase image/sprite from old location
        
        //System.out.println(loc + " " + grid.hasTileImage(loc));


      //CASE 3: Enemy leaves screen at first column

}

//Method to handle the collisions between Sprites on the Screen
public void handleCollisions(){


}

//method to indicate when the main game is over
public boolean isGameOver(){
  return false; //by default, the game is never over
}

//method to describe what happens after the game is over
public void endGame(){
    System.out.println("Game Over!");

    //Update the title bar

    //Show any end imagery
    image(endScreen, 100,100);

}

//example method that creates 5 horses along the screen
public void exampleAnimationSetup(){  
  int i = 2;
  exampleSprite = new AnimatedSprite("sprites/ice_horse_run.png", 50.0, i*75.0, "sprites/ice_horse_run.json");
  exampleSprite2 = new AnimatedSprite("sprites/horse_run.png", 50.0, i*75.0, "sprites/horse_run.json");
  slime = new AnimatedSprite("sprites/slime_down.png", 200.0, i*75.0, "sprites/slime_down.json");
}

//example method that animates the horse Sprites
public void checkExampleAnimation(){
  if(doAnimation){
    exampleSprite.animateVertical(1.0, 1.0, true);
    exampleSprite2.animateHorizontal(1.0, 1.0, true);
  }
  slime.animate(0.1);
}