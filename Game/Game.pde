/* Game Class Starter File
 * Last Edit: 12/13/2022
 * Authors: _____________________
 */

//GAME VARIABLES
Grid grid = new Grid(10,10);
PImage bg;
PImage player1;
PImage endScreen;
String titleText = "Peter the Horse is here";
String extraText = "Whose Turn?";
AnimatedSprite exampleSprite;
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

  println("Game started...");

  //fullScreen();   //only use if not using a specfic bg image
}

//Required Processing method that automatically loops
//(Anything drawn on the screen should be called from here)
void draw() {

  updateTitleBar();
  updateScreen();
  populateSprites();
  moveSprites();
  
  if(isGameOver()){
    endGame();
  }

  checkExampleAnimation();

}

  //Known Processing method that automatically will run whenever a key is pressed
  void keyPressed(){

    //check what key was pressed
    System.out.println("Key pressed: " + keyCode); //keyCode gives you an integer for the key

    //What to do when a key is pressed?
    
    // W KEY (UP)
    if(keyCode == 87){
      System.out.println(grid.getTileWidthPixels());
      player1 = loadImage("images/LetterW.png");
      player1.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
      //check case where out of bounds

      if (player1Row != 0) {
      //change the field for player1Row
      player1Row--;

      //shift the player1 picture up in the 2D array
      GridLocation loc = new GridLocation(player1Row, player1Col);
      grid.setTileImage(loc, player1);

      //eliminate the picture from the old location
      }
    }
    
    // S KEY (DOWN)
    if(keyCode == 83){
      System.out.println(grid.getTileHeightPixels());
      player1 = loadImage("images/LetterS.png");
      player1.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
      //check case where out of bounds
      if (player1Row != grid.getRows()-1) {
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
      player1 = loadImage("images/LetterA.png");
      player1.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
      //check case where out of bounds
      if (player1Col != 0) {
      //change the field for player1Col
      player1Col--;

      //shift the player1 picture left in the 2D array
      GridLocation loc = new GridLocation(player1Row, player1Col);
      grid.setTileImage(loc, player1);

      //eliminate the picture from the old location
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
      player1 = loadImage("images/LetterD.png");
      player1.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
      //check case where out of bounds
      if (player1Col != grid.getCols()-1) {
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
  
  //update other screen elements


}

//Method to populate enemies or other sprites on the screen
public void populateSprites(){

}

//Method to move around the enemies/sprites on the screen
public void moveSprites(){


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
  exampleSprite = new AnimatedSprite("sprites/horse_run.png", 50.0, i*75.0, "sprites/horse_run.json");
}

//example method that animates the horse Sprites
public void checkExampleAnimation(){
  if(doAnimation){
    exampleSprite.animateVertical(1.0, 0.1, true);
  }
}