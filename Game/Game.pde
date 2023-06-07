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
String titleText = "Dungeon Knight";
String extraText = "Room 1";
AnimatedSprite exampleSprite;
AnimatedSprite exampleSprite2;
AnimatedSprite player;
boolean doAnimation;
AnimatedSprite ghoul;
boolean gameOver = false;
boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;

World world = new World("test", bg);

//HexGrid hGrid = new HexGrid(3);
//import processing.sound.*;
//SoundFile song;

//Required Processing method that gets run once
void setup() {

  //Match the screen size to the background image size
  size(960, 720);

  //Set the title on the title bar
  surface.setTitle(titleText);

  //Load images used
  bg = loadImage("images/walls_and_floor.png");
  bg.resize(960,720);
  player1 = loadImage("images/LetterS.png");
  player1.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
  endScreen = loadImage("images/youwin.png");

  // Load a soundfile from the /data folder of the sketch and play it back
  // song = new SoundFile(this, "sounds/Lenny_Kravitz_Fly_Away.mp3");
  // song.play();

  
  //Animation & Sprite setup
  animationSetup();

  imageMode(CORNER);    //Set Images to read coordinates at corners
  //fullScreen();   //only use if not using a specfic bg image

  // System.out.println("Adding sprites to world...");
  // world.addSpriteCopyTo(ghoul, 100,100);
  // world.addSpriteCopyTo(ghoul, 200, 200);
  // world.addSpriteCopyTo(ghoul, 300, 300);
  // world.printSprites();
  // System.out.println("Done adding sprites..");

  
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
  handleCollisions();
  updateScreen();
  
  if(isGameOver()){
    endGame();
  }

  checkExampleAnimation();
  //System.out.println("Player Coords: " + player.getCenterX() + ", " + player.getCenterY());
  //world.printSprites();
  //System.out.println(ghoul.getHealth());
  System.out.println("xD: " + (ghoul.getCenterX()-player.getCenterX()));
  System.out.println("yD: " + (ghoul.getCenterY()-player.getCenterY()));
  
  msElapsed +=1;
  grid.pause(1);

}

// Known Processing method that automatically will run whenever a key is pressed
// Based off of "Programming Keyboard Movement in Processing" by John McCaffrey
// https://youtu.be/ELyioGdxUZU
void keyPressed() {

  //check what key was pressed
  System.out.println("Key pressed: " + keyCode); //keyCode gives you an integer for the key
  System.out.println(player.getCenterX() + ", " + player.getCenterY());

  //What to do when a key is pressed?
   
  // A KEY (LEFT)
  if(keyCode == 65 || keyCode == 37) {
    if (player.getJsonFile().equals("sprites/slime_down.json") || player.getJsonFile().equals("sprites/slime_up.json") || player.getJsonFile().equals("sprites/slime_right.json")) {
      player = new AnimatedSprite("sprites/slime_left.png", player.getCenterX()-10.5, player.getCenterY()-7.5, "sprites/slime_left.json", player.getHealth());
    }
    left = true;
  }

  // W KEY (UP)
  else if(keyCode == 87 || keyCode == 38) {
    if (player.getJsonFile().equals("sprites/slime_down.json") || player.getJsonFile().equals("sprites/slime_left.json") || player.getJsonFile().equals("sprites/slime_right.json")) {
      player = new AnimatedSprite("sprites/slime_up.png", player.getCenterX()-10.5, player.getCenterY()-7.5, "sprites/slime_up.json", player.getHealth());
    }
    up = true;
  }

  // D KEY (RIGHT)
  else if(keyCode == 68 || keyCode == 39) {
    if (player.getJsonFile().equals("sprites/slime_down.json") || player.getJsonFile().equals("sprites/slime_left.json") || player.getJsonFile().equals("sprites/slime_up.json")) {
      player = new AnimatedSprite("sprites/slime_right.png", player.getCenterX()-10.5, player.getCenterY()-7.5, "sprites/slime_right.json", player.getHealth());
    }
    right = true;
  }
   
  // S KEY (DOWN)
  else if(keyCode == 83 || keyCode == 40) {
    if (player.getJsonFile().equals("sprites/slime_up.json") || player.getJsonFile().equals("sprites/slime_left.json") || player.getJsonFile().equals("sprites/slime_right.json")) {
      player = new AnimatedSprite("sprites/slime_down.png", player.getCenterX()-10.5, player.getCenterY()-7.5, "sprites/slime_down.json", player.getHealth());
    }
    down = true;
  }

  // P/Z KEYS (PUNCH)
   else if(keyCode == 80 || keyCode == 90) {
    // for each monster in the arraylist
    // run a punch method (player, each monster)
    player.attack(ghoul);
   }

  // HORIZONTAL
  // player left method
  if (left == true && right == false) {
    player.animateMove(-0.75, 0.0, 0.1, true);
  }

  // player right method
  if (right == true && left == false) {
    player.animateMove(0.75, 0.0, 0.1, true);
  }

  // if left and right are false then dont move
  if (left == false && right == false) {
    player.animateMove(0.0, 0.0, 0.1, true);
  }

  // VERTICAL
  // player up method
  if (up == true && down == false) {
    player.animateMove(0.0, -0.75, 0.1, true);
  }

  // player down method
  if (down == true && up == false) {
    player.animateMove(0.0, 0.75, 0.1, true);
  }

  // if up and down are false then dont move
  if (down == false && up == false) {
    player.animateMove(0.0, 0.0, 0.1, true);
  }

  // STOP METHODS
  // stop player up method
  if (up == false) {
    player.animateMove(0.0, 0.0, 0.1, true);
  }
    
  // stop player down method
  if (down == false) {
    player.animateMove(0.0, 0.0, 0.1, true);
  }

  // stop player left method
  if (left == false) {
    player.animateMove(0.0, 0.0, 0.1, true);
  }

  // stop player right method
  if (right == false) {
    player.animateMove(0.0, 0.0, 0.1, true);
  }
}

//Known Processing method that automatically will run whenever a key is released
void keyReleased() {

  //check what key was pressed
  System.out.println("Key released: " + keyCode); //keyCode gives you an integer for the key
  System.out.println(player.getCenterX() + ", " + player.getCenterY());

  // stop left
  if(keyCode == 65 || keyCode == 37) {
    left = false;
  }

  // stop up
  else if(keyCode == 87 || keyCode == 38) {
    up = false;
  }

  // stop right
  else if(keyCode == 68 || keyCode == 39) {
    right = false;
  }

  // stop down
  else if(keyCode == 83 || keyCode == 40) {
    down = false;
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

  if (player.getCenterY() >= bg.height) {
    extraText = "Room 2";
  }

  //Display the Player1 image
  //GridLocation player1Loc = new GridLocation(player1Row,player1Col);
  //grid.setTileImage(player1Loc, player1);
  
  //Loop through all the Tiles and display its images/sprites
  

      //Store temporary GridLocation
      
      //Check if the tile has an image/sprite 
      //--> Display the tile's image/sprite



  //Update other screen elements
  grid.showImages();
  grid.showSprites();
  grid.showGridSprites();

}

//Method to populate enemies or other sprites on the screen
public void populateSprites(){
  /**
  float randX = (float) (Math.abs(Math.random()*bg.width));
  float randY = (float) (Math.abs(Math.random()*bg.height));
  ghoul.setCenterX(randX);
  ghoul.setCenterY(randY);
  ghoul.show();
  **/
  //ghoul.animate(1.0);
  //System.out.println("Ghoul spawned:" + randX + ", " + randY);
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
  if(player.getTop() < ghoul.getBottom() && player.getBottom() > ghoul.getTop() && player.getRight() > ghoul.getLeft() && player.getLeft() < ghoul.getRight()) {
    //System.out.println("Collision!!!!!");
    ghoul.attack(player);
  }

  if (player.getHealth() == 0) {
    gameOver = true;
  }

  // WALL COLLISIONS

  if (ghoul.getHealth() == 0) {
    if (player.getTop() < 80) {
      player.animateMove(0.0, 1.25, 0.1, true);
    }

    if (player.getBottom() > bg.height-80.0 && (player.getCenterX() <= 400 || player.getCenterX() >= 560)) {
      player.animateMove(0.0, -1.25, 0.1, true);
    }

    if (player.getLeft() < 80.0) {
      player.animateMove(1.25, 0.0, 0.1, true);
    }

    if (player.getRight() > bg.width-80.0) {
      player.animateMove(-1.25, 0.0, 0.1, true);
    }
  }
  else {
    if (player.getTop() < 80) {
      player.animateMove(0.0, 1.25, 0.1, true);
    }

    if (player.getBottom() > bg.height-80.0) {
      player.animateMove(0.0, -1.25, 0.1, true);
    }

    if (player.getLeft() < 80.0) {
      player.animateMove(1.25, 0.0, 0.1, true);
    }

    if (player.getRight() > bg.width-80.0) {
      player.animateMove(-1.25, 0.0, 0.1, true);
    }
  }
}

//method to indicate when the main game is over
public boolean isGameOver(){
  if (gameOver) {
    return true;
  }
  return false; //by default, the game is never over
}

//method to describe what happens after the game is over
public void endGame(){
    //System.out.println("Game Over!");

    //Update the title bar

    //Show any end imagery
    image(endScreen, 100,100);

}

//example method that creates 5 horses along the screen
public void animationSetup(){  
  int i = 2;
  exampleSprite = new AnimatedSprite("sprites/ice_horse_run.png", 50.0, i*75.0, "sprites/ice_horse_run.json", 5);
  exampleSprite2 = new AnimatedSprite("sprites/horse_run.png", 50.0, i*75.0, "sprites/horse_run.json", 5);
  player = new AnimatedSprite("sprites/slime_down.png", 400.0, 400.0, "sprites/slime_down.json", 5);
  ghoul = new AnimatedSprite("sprites/ghoul_left.png", "sprites/ghoul_left.json", 5);
}

//example method that animates the horse Sprites
// move speed, animation speed, wrap around
public void checkExampleAnimation(){
  if(doAnimation){
    exampleSprite.animateVertical(1.0, 3.0, true);
    exampleSprite2.animateHorizontal(1.0, 3.0, true);
  }
  player.animate(0.1);

  if (ghoul.getHealth() == 0) {
    ghoul.setCenterX(-600);
    ghoul.setCenterY(-600);
    ghoul.animateMove(0.0, 0.0, 0.0, false);
  }
  else {
    ghoul.animateToPlayer(player, 1.0, true);
  }

  for (AnimatedSprite g : world.getSprites()) {
    g.animateToPlayer(player, 1.0, true);
  }

  if (ghoul.getJsonFile().equals("sprites/ghoul_left.json") && player.getCenterX() > ghoul.getCenterX()) {
    ghoul = new AnimatedSprite("sprites/ghoul_right.png", ghoul.getCenterX()-23.5, ghoul.getCenterY()-37.5, "sprites/ghoul_right.json", ghoul.getHealth());
  }
  if (ghoul.getJsonFile().equals("sprites/ghoul_right.json") && player.getCenterX() < ghoul.getCenterX()) {
    ghoul = new AnimatedSprite("sprites/ghoul_left.png", ghoul.getCenterX()-23.5, ghoul.getCenterY()-37.5, "sprites/ghoul_left.json", ghoul.getHealth());
  }

  //Difference Testing Code:
  //System.out.println("Difference:" + (player.getCenterX() - ghoul.getCenterX()) + ", " + (player.getCenterY() - ghoul.getCenterY()));
  
  /**
  Collision Testing Code:
  System.out.println("Player Top: " + player.getTop() + " Ghoul Top: " + ghoul.getTop());
  System.out.println("Player Bottom: " + player.getBottom() + " Ghoul Bottom: " + ghoul.getBottom());
  System.out.println("Player Left: " + player.getLeft() + " Ghoul Left: " + ghoul.getLeft());
  System.out.println("Player Right: " + player.getRight() + " Ghoul Right: " + ghoul.getRight());
  **/
}