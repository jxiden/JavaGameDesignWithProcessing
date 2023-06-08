/* Game Class Starter File
 * Last Edit: 12/13/2022
 * Authors: _____________________
 */

//import processing.sound.*;

//GAME VARIABLES
private int msElapsed = 0;
String titleText = "Dungeon Knight";
String extraText = "Room 1";
int roomNum = 1;

//Screens
Screen currentScreen;
World currentWorld;
Grid currentGrid;

//Splash Screen Variables
Screen splashScreen;
String splashBgFile = "images/Backrooms-Games.png";
PImage splashBg;

//main Screen Variables
Grid mainGrid;
String mainBgFile = "images/walls_and_floor.png";
PImage mainBg;

AnimatedSprite player;
PImage player1;
String player1File = "images/LetterS.png";
int player1Row = 3;
int player1Col = 4;
int health = 3;

PImage enemy;
AnimatedSprite ghoul;

AnimatedSprite exampleSprite;
AnimatedSprite exampleSprite2;
boolean doAnimation;

//EndScreen variables
World endScreen;
PImage endBg;
String endBgFile = "images/youwin.png";

//Example Variables
//HexGrid hGrid = new HexGrid(3);
//SoundFile song;

boolean gameOver = false;
boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;


//import processing.sound.*;
//SoundFile song;

//Required Processing method that gets run once
void setup() {

  //Match the screen size to the background image size
  size(960, 720);

  //Set the title on the title bar
  surface.setTitle(titleText);

  //Load BG images used
  splashBg = loadImage(splashBgFile);
  splashBg.resize(960, 720);
  mainBg = loadImage(mainBgFile);
  mainBg.resize(960, 720);
  endBg = loadImage(endBgFile);
  endBg.resize(960, 720);

  //setup the screens/worlds/grids in the Game
  splashScreen = new Screen("splash", splashBg);
  mainGrid = new Grid("room1", mainBg, 10,10);
  endScreen = new World("end", endBg);
  currentScreen = splashScreen;

  //setup the sprites/images
  player1 = loadImage(player1File);
  player1.resize(mainGrid.getTileWidthPixels(),mainGrid.getTileHeightPixels());
  animationSetup();
 
  //Other Setup
  // Load a soundfile from the /data folder of the sketch and play it back
  // song = new SoundFile(this, "sounds/Lenny_Kravitz_Fly_Away.mp3");
  // song.play();

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
  handleCollisions();
  updateScreen();
  
  if(isGameOver()){
    endGame();
  }

  System.out.println("Player Coords: " + player.getCenterX() + ", " + player.getCenterY());
  //world.printSprites();
  //System.out.println(ghoul.getHealth());
  System.out.println("xD: " + (ghoul.getCenterX()-player.getCenterX()));
  System.out.println("yD: " + (ghoul.getCenterY()-player.getCenterY()));
  
  msElapsed +=1;
  currentScreen.pause(1);

}

// Processing method that automatically will run whenever a key is pressed
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
    for (AnimatedSprite g : currentWorld.getSprites()) {
      player.attack(g);
    }
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
    if(currentGrid != null){
      System.out.println("Grid location: " + currentGrid.getGridLocation());
    }

    //what to do if clicked? (Make player1 disappear?)


    //Toggle the animation on & off
    doAnimation = !doAnimation;
    System.out.println("doAnimation: " + doAnimation);
    if(currentGrid != null){
      currentGrid.setMark("X",currentGrid.getGridLocation());
    }
    
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

  //Update the Background
  background(currentScreen.getBg());

  //splashScreen update
  if(splashScreen.getScreenTime() > 3000 && splashScreen.getScreenTime() < 5000){
    currentScreen = mainGrid;
  }

  //skyGrid Screen Updates
  if(currentScreen == mainGrid){
    currentWorld = mainGrid;

    checkAnimations();
    /**
    if (currentWorld.checkHealth()) {
      currentScreen.setBg()
    }
    **/

    // If the player is offscreen, update the room number, title bar.
    // PROBLEMS: Can sometimes cause the room to go up by 2 or up by 0, causing either 2 or 0 enemies to spawn
    // PLANNED: RNG rooms. If roomType = something, spawn specific types of enemies in specific amounts
    if (player.getCenterY() >= currentScreen.getBg().height) {
      roomNum++;
      extraText = "Room " + roomNum;
      currentWorld.addSpriteCopyTo(ghoul, 200, 200);
    }

    //Update other screen elements
    mainGrid.showImages();
    mainGrid.showSprites();
    mainGrid.showGridSprites();
  }
}

//Method to populate enemies or other sprites on the screen
public void populateSprites(){
  // This was a bunch of testing code that didn't work
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
  /**
  if(player.getTop() < ghoul.getBottom() && player.getBottom() > ghoul.getTop() && player.getRight() > ghoul.getLeft() && player.getLeft() < ghoul.getRight()) {
    ghoul.attack(player);
  }
  **/

  // Constantly loop through all the sprites in the room to check if they can attack the player
  if (currentScreen != splashScreen) {
    for (AnimatedSprite g : currentWorld.getSprites()) {
      if(player.getTop() < g.getBottom() && player.getBottom() > g.getTop() && player.getRight() > g.getLeft() && player.getLeft() < g.getRight()) {
        g.attack(player);
      }
    }
  }

  // If the player's health is 0, gameOver is true.
  if (player.getHealth() == 0) {
    gameOver = true;
  }

  // WALL COLLISIONS
  if (currentScreen != splashScreen) {
    boolean dead = currentWorld.checkHealth();
    if (dead) {
      if (player.getTop() < 80) {
        player.animateMove(0.0, 1.25, 0.1, true);
      }

      if (player.getBottom() > currentScreen.getBg().height-80.0 && (player.getCenterX() <= 400 || player.getCenterX() >= 560)) {
        player.animateMove(0.0, -1.25, 0.1, true);
      }

      if (player.getLeft() < 80.0) {
        player.animateMove(1.25, 0.0, 0.1, true);
      }

      if (player.getRight() > currentScreen.getBg().width-80.0) {
        player.animateMove(-1.25, 0.0, 0.1, true);
      }
    }

    else {
      if (player.getTop() < 80) {
        player.animateMove(0.0, 1.25, 0.1, true);
      }

      if (player.getBottom() > currentScreen.getBg().height-80.0) {
        player.animateMove(0.0, -1.25, 0.1, true);
      }

      if (player.getLeft() < 80.0) {
        player.animateMove(1.25, 0.0, 0.1, true);
      }

      if (player.getRight() > currentScreen.getBg().width-80.0) {
        player.animateMove(-1.25, 0.0, 0.1, true);
      }
    }
  }
}

//method to indicate when the main game is over
public boolean isGameOver(){
  if (gameOver) {
    return true;
  }
  return false;
}

//method to describe what happens after the game is over
public void endGame(){
  //Show any end imagery
    currentScreen = endScreen;
    //image(endScreen, 100,100);
}

// Constructs the player, master ghoul
public void animationSetup(){  
  player = new AnimatedSprite("sprites/slime_down.png", 400.0, 400.0, "sprites/slime_down.json", 5);
  ghoul = new AnimatedSprite("sprites/ghoul_left.png", "sprites/ghoul_left.json", -600.0, -600.0, 5);
}

// Constantly checks if the animations should be happening, and what type of animations should occur
public void checkAnimations(){
  // Animate player, master ghoul
  player.animate(0.1);
  ghoul.animate(1.0);

  // Check ghoul copies animation for if they're dead or not
  for (AnimatedSprite g : currentWorld.getSprites()) {
    if (g.getHealth() == 0) {
      g.setCenterX(-600);
      g.setCenterY(-600);
      g.animateMove(0.0, 0.0, 0.0, false);
    }
    else {
      g.animateToPlayer(player, 1.0, true);
    }
  }

  // Switch direction of master ghoul image
  if (ghoul.getJsonFile().equals("sprites/ghoul_left.json") && player.getCenterX() > ghoul.getCenterX()) {
    ghoul = new AnimatedSprite("sprites/ghoul_right.png", ghoul.getCenterX()-23.5, ghoul.getCenterY()-37.5, "sprites/ghoul_right.json", ghoul.getHealth());
  }
  if (ghoul.getJsonFile().equals("sprites/ghoul_right.json") && player.getCenterX() < ghoul.getCenterX()) {
    ghoul = new AnimatedSprite("sprites/ghoul_left.png", ghoul.getCenterX()-23.5, ghoul.getCenterY()-37.5, "sprites/ghoul_left.json", ghoul.getHealth());
  }

  // Switch direction of appearance of ghoul copies
  if (currentScreen != splashScreen) {
    for (int i = 0; i < currentWorld.getSprites().size(); i++) {
      if (currentWorld.getSprites().get(i).getJsonFile().equals("sprites/ghoul_left.json") && player.getCenterX() > currentWorld.getSprites().get(i).getCenterX()) {
        currentWorld.getSprites().set(i, new AnimatedSprite("sprites/ghoul_right.png", currentWorld.getSprites().get(i).getCenterX()-23.5, currentWorld.getSprites().get(i).getCenterY()-37.5, "sprites/ghoul_right.json", currentWorld.getSprites().get(i).getHealth()));
      }

      if (currentWorld.getSprites().get(i).getJsonFile().equals("sprites/ghoul_right.json") && player.getCenterX() < currentWorld.getSprites().get(i).getCenterX()) {
        currentWorld.getSprites().set(i, new AnimatedSprite("sprites/ghoul_left.png", currentWorld.getSprites().get(i).getCenterX()-23.5, currentWorld.getSprites().get(i).getCenterY()-37.5, "sprites/ghoul_left.json", currentWorld.getSprites().get(i).getHealth()));
      }
    }
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