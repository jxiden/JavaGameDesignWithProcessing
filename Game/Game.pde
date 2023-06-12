/* Game Class Starter File
 * Last Edit: 12/13/2022
 * Authors: Niko Baletin, Jaiden Kelly
 */

import processing.sound.*;

// GAME VARIABLES
private int msElapsed = 0;
int miniElapsed = 0;
String titleText = "Dungeon Knight";
String extraText = "Starting Room";
int roomNum = 0;

// Screens
Screen currentScreen;
World currentWorld;
Grid currentGrid;

// Splash Screen Variables
Screen splashScreen;
String splashBgFile = "images/splashScreen.png";
PImage splashBg;

// Main Screen Variables
Grid mainGrid;
String mainBgFile = "images/walls_and_floor.png";
PImage mainBg;
String doorBgFile = "images/door_open.png";
PImage doorBg;
Sprite healthBar;
Sprite controls;

AnimatedSprite player;
AnimatedSprite ghoul;
AnimatedSprite slime;
AnimatedSprite glaggle;

AnimatedSprite exampleSprite;
AnimatedSprite exampleSprite2;
boolean doAnimation;

// EndScreen variables
World endScreen;
PImage endBg;
String endBgFile = "images/endscreen.png";

// Example Variables
SoundFile song;

boolean gameOver = false;
boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;
boolean punchFlag = false;

// Required Processing method that gets run once
void setup() {

  // Match the screen size to the background image size
  size(960, 720);

  // Set the title on the title bar
  surface.setTitle(titleText);

  // Load BG images used
  splashBg = loadImage(splashBgFile);
  splashBg.resize(960, 720);
  mainBg = loadImage(mainBgFile);
  mainBg.resize(960, 720);
  doorBg = loadImage(doorBgFile);
  doorBg.resize(960,720);
  endBg = loadImage(endBgFile);
  endBg.resize(960, 720);

  // Setup the screens/worlds/grids in the Game
  splashScreen = new Screen("splash", splashBg);
  mainGrid = new Grid("room1", mainBg, 10,10);
  endScreen = new World("end", endBg);
  currentScreen = splashScreen;

  //setup the sprites/images
  animationSetup();
 

  //start the splashscreen
  updateScreen();

  // Sound Setup
  // Load a soundfile from the /data folder of the sketch and play it back
  song = new SoundFile(this, "sounds/Dungeon_Knight_Theme.mp3");
  song.loop();

  imageMode(CORNER); // Set Images to read coordinates at corners
  //fullScreen();    // Only use if not using a specfic bg image
  println("Game started...");

  //reset the splash timer
  splashScreen.resetTimer();
  
}

// Required Processing method that automatically loops
// Anything drawn on the screen should be called from here
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

  // Player should only be able to move in the main screens
  if (currentScreen != splashScreen && currentScreen != endScreen) {
    // A KEY (LEFT)
    if(keyCode == 65 || keyCode == 37) {
      if (player.getJsonFile().equals("sprites/knight_down_idle.json") || player.getJsonFile().equals("sprites/knight_up_idle.json") || player.getJsonFile().equals("sprites/knight_right_idle.json") || player.getJsonFile().equals("sprites/knight_spin.json")) {
        player = new AnimatedSprite("sprites/knight_left_idle.png", player.getCenterX()-16.5, player.getCenterY()-31.5, "sprites/knight_left_idle.json", player.getHealth());
      }
      left = true;
    }

    // W KEY (UP)
    else if(keyCode == 87 || keyCode == 38) {
      if (player.getJsonFile().equals("sprites/knight_down_idle.json") || player.getJsonFile().equals("sprites/knight_left_idle.json") || player.getJsonFile().equals("sprites/knight_right_idle.json") || player.getJsonFile().equals("sprites/knight_spin.json")) {
        player = new AnimatedSprite("sprites/knight_up_idle.png", player.getCenterX()-16.5, player.getCenterY()-31.5, "sprites/knight_up_idle.json", player.getHealth());
      }
      up = true;
    }

    // D KEY (RIGHT)
    else if(keyCode == 68 || keyCode == 39) {
      if (player.getJsonFile().equals("sprites/knight_down_idle.json") || player.getJsonFile().equals("sprites/knight_left_idle.json") || player.getJsonFile().equals("sprites/knight_up_idle.json") || player.getJsonFile().equals("sprites/knight_spin.json")) {
        player = new AnimatedSprite("sprites/knight_right_idle.png", player.getCenterX()-16.5, player.getCenterY()-31.5, "sprites/knight_right_idle.json", player.getHealth());
      }
      right = true;
    }
   
    // S KEY (DOWN)
    else if(keyCode == 83 || keyCode == 40) {
      if (player.getJsonFile().equals("sprites/knight_up_idle.json") || player.getJsonFile().equals("sprites/knight_left_idle.json") || player.getJsonFile().equals("sprites/knight_right_idle.json") || player.getJsonFile().equals("sprites/knight_spin.json")) {
        player = new AnimatedSprite("sprites/knight_down_idle.png", player.getCenterX()-16.5, player.getCenterY()-31.5, "sprites/knight_down_idle.json", player.getHealth());
      }
      down = true;
    }

    // P/Z KEYS (PUNCH)
    if (punchFlag == false){
    if(keyCode == 80 || keyCode == 90) {
      punchFlag = true;
      for (AnimatedSprite g : currentWorld.getSprites()) {
        player.attack(g);
      }
      player = new AnimatedSprite("sprites/knight_spin.png", player.getCenterX()-16.5, player.getCenterY()-31.5, "sprites/knight_spin.json", player.getHealth());
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
}

//Known Processing method that automatically will run whenever a key is released
void keyReleased() {

  // check what key was pressed
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

  // P/Z KEYS (PUNCH)
   if(keyCode == 80 || keyCode == 90) {
    punchFlag = false;
   }
  }

  //Known Processing method that automatically will run when a mouse click triggers it
  void mouseClicked(){
  }
//------------------ CUSTOM  METHODS --------------------//

//method to update the Title Bar of the Game
public void updateTitleBar(){
  if(!isGameOver()) {
    //set the title each loop
    surface.setTitle(titleText + "    " + extraText);
  }
}

//method to update what is drawn on the screen each frame
public void updateScreen(){

  //Update the Background
  background(currentScreen.getBg());

  //splashScreen update
  //System.out.println("splashTime" + splashScreen.getScreenTime());
  if(splashScreen.getScreenTime() > 3000 && splashScreen.getScreenTime() < 5000){
    currentScreen = mainGrid;
  }

  //skyGrid Screen Updates
  if(currentScreen == mainGrid){
    currentWorld = mainGrid;
    
  // Switch the image of healthBar from health1 to health0 if player dies
  if (player.getHealth() == 0 && healthBar.getImagePath().equals("sprites/health1.png")) {
    healthBar = new Sprite("sprites/health0.png", healthBar.getCenterX(), healthBar.getCenterY());
  }

  checkAnimations();
    
  if (currentWorld.checkHealth()) {
    currentScreen.setBg(doorBg);
  }
  else {
    currentScreen.setBg(mainBg);
  }

  // If the player is offscreen, update the room number, title bar
  if (player.getCenterY() >= (currentScreen.getBg().height+18.0)) {
    roomNum++;
    extraText = "Room " + roomNum;
    currentScreen.pause(20);

    // 1 in 1000 chance to spawn the glognut :)
    int theRides = (int) (Math.random()*1000);
    if (theRides == 0) {
      currentWorld.addSpriteCopyTo(glaggle, 880, 640);
    }

    // Create rooms based on the random number roomBag
    int roomBag = (int) (Math.random()*10);
    if (roomBag == 0) {
      currentWorld.addSpriteCopyTo(ghoul, 200, 200);
      currentWorld.addSpriteCopyTo(ghoul, 200, 400);
      currentWorld.addSpriteCopyTo(ghoul, 200, 600);
      currentWorld.addSpriteCopyTo(slime, 700, 300);
      currentWorld.addSpriteCopyTo(slime, 700, 500);
      currentWorld.addSpriteCopyTo(slime, 700, 400);
      currentWorld.addSpriteCopyTo(slime, 700, 200);
    }

    if (roomBag == 1) {
      currentWorld.addSpriteCopyTo(slime, 200, 500);
      currentWorld.addSpriteCopyTo(slime, 400, 500);
      currentWorld.addSpriteCopyTo(slime, 600, 500);
      currentWorld.addSpriteCopyTo(ghoul, 300, 500);
      currentWorld.addSpriteCopyTo(ghoul, 500, 500);
      currentWorld.addSpriteCopyTo(slime, 200, 200);
      currentWorld.addSpriteCopyTo(slime, 600, 200);
    }

    if (roomBag == 2) {
      currentWorld.addSpriteCopyTo(ghoul, 100, 100);
      currentWorld.addSpriteCopyTo(ghoul, 800, 600);
      currentWorld.addSpriteCopyTo(ghoul, 800, 100);
      currentWorld.addSpriteCopyTo(ghoul, 100, 600);
      currentWorld.addSpriteCopyTo(slime, 400, 400);
      currentWorld.addSpriteCopyTo(slime, 500, 500);
      currentWorld.addSpriteCopyTo(slime, 300, 300);
    }

    if (roomBag == 3) {
      currentWorld.addSpriteCopyTo(slime, 200, 200);
      currentWorld.addSpriteCopyTo(slime, 200, 400);
      currentWorld.addSpriteCopyTo(slime, 200, 600);
      currentWorld.addSpriteCopyTo(slime, 700, 200);
      currentWorld.addSpriteCopyTo(slime, 700, 400);
      currentWorld.addSpriteCopyTo(slime, 700, 600);
      currentWorld.addSpriteCopyTo(slime, 400, 600);
    }

    if (roomBag == 4) {
      currentWorld.addSpriteCopyTo(ghoul, 200, 500);
      currentWorld.addSpriteCopyTo(ghoul, 200, 400);
      currentWorld.addSpriteCopyTo(ghoul, 200, 300);
      currentWorld.addSpriteCopyTo(ghoul, 200, 200);
      currentWorld.addSpriteCopyTo(ghoul, 600, 200);
      currentWorld.addSpriteCopyTo(ghoul, 600, 300);
      currentWorld.addSpriteCopyTo(ghoul, 600, 400);
    }

    if (roomBag == 5) {
      currentWorld.addSpriteCopyTo(slime, 100, 100);
      currentWorld.addSpriteCopyTo(slime, 800, 600);
      currentWorld.addSpriteCopyTo(slime, 800, 100);
      currentWorld.addSpriteCopyTo(slime, 100, 600);
      currentWorld.addSpriteCopyTo(ghoul, 400, 400);
      currentWorld.addSpriteCopyTo(ghoul, 500, 300);
      currentWorld.addSpriteCopyTo(ghoul, 300, 500);
    }

    if (roomBag == 6) {
      currentWorld.addSpriteCopyTo(ghoul, 700, 200);
      currentWorld.addSpriteCopyTo(ghoul, 700, 400);
      currentWorld.addSpriteCopyTo(ghoul, 700, 600);
      currentWorld.addSpriteCopyTo(slime, 200, 300);
      currentWorld.addSpriteCopyTo(slime, 200, 500);
      currentWorld.addSpriteCopyTo(slime, 200, 400);
      currentWorld.addSpriteCopyTo(slime, 200, 200);
    }

    if (roomBag == 7) {
      currentWorld.addSpriteCopyTo(ghoul, 100, 400);
      currentWorld.addSpriteCopyTo(ghoul, 700, 400);
      currentWorld.addSpriteCopyTo(ghoul, 500, 600);
      currentWorld.addSpriteCopyTo(ghoul, 500, 200);
      currentWorld.addSpriteCopyTo(slime, 500, 400);
      currentWorld.addSpriteCopyTo(slime, 200, 400);
      currentWorld.addSpriteCopyTo(slime, 600, 400);
    }

    if (roomBag == 8) {
      currentWorld.addSpriteCopyTo(ghoul, 100, 650);
      currentWorld.addSpriteCopyTo(slime, 200, 600);
      currentWorld.addSpriteCopyTo(ghoul, 300, 500);
      currentWorld.addSpriteCopyTo(slime, 400, 400);
      currentWorld.addSpriteCopyTo(ghoul, 500, 300);
      currentWorld.addSpriteCopyTo(slime, 600, 200);
      currentWorld.addSpriteCopyTo(ghoul, 700, 150);
    }

    if (roomBag == 9) {
      currentWorld.addSpriteCopyTo(slime, 100, 150);
      currentWorld.addSpriteCopyTo(ghoul, 200, 200);
      currentWorld.addSpriteCopyTo(slime, 300, 300);
      currentWorld.addSpriteCopyTo(ghoul, 400, 400);
      currentWorld.addSpriteCopyTo(slime, 500, 500);
      currentWorld.addSpriteCopyTo(ghoul, 600, 600);
      currentWorld.addSpriteCopyTo(slime, 700, 650);
    }
  }

  //Update other screen elements
  mainGrid.showImages();
  mainGrid.showSprites();
  mainGrid.showGridSprites();
  }
}

//Method to populate enemies or other sprites on the screen (Not Used)
public void populateSprites(){
}

//Method to move around the enemies/sprites on the screen (Not Used)
public void moveSprites(){
}

//Method to handle the collisions between Sprites on the Screen
public void handleCollisions(){
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

// Method to indicate when the main game is over
public boolean isGameOver(){
  if (gameOver) {
    return true;
  }
  return false;
}

// Method to describe what happens after the game is over
public void endGame(){
  //Show any end imagery
    currentScreen = endScreen;
    //image(endScreen, 100,100);
}

// Constructs the player, master ghoul, master slime
// Note: Ghoul and slime are offscreen because this game uses copies of these two sprites
// We do not want these master sprites to die, so that the game can function correctly
public void animationSetup(){  
  player = new AnimatedSprite("sprites/knight_down_idle.png", 480.0, 360.0, "sprites/knight_down_idle.json", 5);
  ghoul = new AnimatedSprite("sprites/ghoul_left.png", "sprites/ghoul_left.json", -600.0, -600.0, 5);
  slime = new AnimatedSprite("sprites/slime_left.png", "sprites/slime_left.json", -600.0, -600.0, 5);
  glaggle = new AnimatedSprite("sprites/glaggle.png", "sprites/glaggle.json", -600.0, -600.0, 5);
  healthBar = new Sprite("sprites/health5.png", 90.0, 40.0);
  controls = new Sprite("sprites/controls.png", 700.0, 450.0);
}

// Constantly checks if the animations should be happening, and what type of animations should occur
public void checkAnimations() {
  // Animate player, master ghoul, master slime.
  player.animate(0.1);
  ghoul.animate(1.0);
  slime.animate(0.6);
  glaggle.animate(2.0);
  healthBar.show();
  if (extraText.equals("Starting Room")) {
    controls.show();
  }

  // Check ghoul copies animation for if they're dead or not. If dead, move off screen and stop animating
  for (AnimatedSprite g : currentWorld.getSprites()) {
    if (g.getHealth() == 0) {
      g.setCenterX(-600);
      g.setCenterY(-600);
      g.animateMove(0.0, 0.0, 0.0, false);
    }
    else {
      // If not dead, animate
      if (g.getJsonFile().equals("sprites/ghoul_left.json") || g.getJsonFile().equals("sprites/ghoul_right.json")) {
        g.animateToPlayer(player, 1.0, true);
      }

      if (g.getJsonFile().equals("sprites/slime_left.json") || g.getJsonFile().equals("sprites/slime_right.json")) {
        g.rigidToPlayer(player, 0.4, 0.6, false);
      }

      if (g.getJsonFile().equals("sprites/glaggle.json")) {
        g.rigidToPlayer(player, 0.4, 2.0, false);
      }
    }
  }

  if (currentScreen != splashScreen) {
    for (int i = 0; i < currentWorld.getSprites().size(); i++) {

      // Switch direction of appearance of ghoul copies based on player location
      if (currentWorld.getSprites().get(i).getJsonFile().equals("sprites/ghoul_left.json") && player.getCenterX() > currentWorld.getSprites().get(i).getCenterX()) {
        currentWorld.getSprites().set(i, new AnimatedSprite("sprites/ghoul_right.png", currentWorld.getSprites().get(i).getCenterX()-23.5, currentWorld.getSprites().get(i).getCenterY()-37.5, "sprites/ghoul_right.json", currentWorld.getSprites().get(i).getHealth()));
      }

      if (currentWorld.getSprites().get(i).getJsonFile().equals("sprites/ghoul_right.json") && player.getCenterX() < currentWorld.getSprites().get(i).getCenterX()) {
        currentWorld.getSprites().set(i, new AnimatedSprite("sprites/ghoul_left.png", currentWorld.getSprites().get(i).getCenterX()-23.5, currentWorld.getSprites().get(i).getCenterY()-37.5, "sprites/ghoul_left.json", currentWorld.getSprites().get(i).getHealth()));
      }

      // Switch direction of appearance of slime copies based on player location
      if (currentWorld.getSprites().get(i).getJsonFile().equals("sprites/slime_left.json") && player.getCenterX() > currentWorld.getSprites().get(i).getCenterX()) {
        currentWorld.getSprites().set(i, new AnimatedSprite("sprites/slime_right.png", currentWorld.getSprites().get(i).getCenterX()-23.5, currentWorld.getSprites().get(i).getCenterY()-14.5, "sprites/slime_right.json", currentWorld.getSprites().get(i).getHealth()));
      }

      if (currentWorld.getSprites().get(i).getJsonFile().equals("sprites/slime_right.json") && player.getCenterX() < currentWorld.getSprites().get(i).getCenterX()) {
        currentWorld.getSprites().set(i, new AnimatedSprite("sprites/slime_left.png", currentWorld.getSprites().get(i).getCenterX()-23.5, currentWorld.getSprites().get(i).getCenterY()-14.5, "sprites/slime_left.json", currentWorld.getSprites().get(i).getHealth()));
      }
    }
  }

  // Switch the image file of healthBar based on player's health
  if (player.getHealth() == 4 && healthBar.getImagePath().equals("sprites/health5.png")) {
    healthBar = new Sprite("sprites/health4.png", healthBar.getCenterX(), healthBar.getCenterY());
  }

  if (player.getHealth() == 3 && healthBar.getImagePath().equals("sprites/health4.png")) {
    healthBar = new Sprite("sprites/health3.png", healthBar.getCenterX(), healthBar.getCenterY());
  }

  if (player.getHealth() == 2 && healthBar.getImagePath().equals("sprites/health3.png")) {
    healthBar = new Sprite("sprites/health2.png", healthBar.getCenterX(), healthBar.getCenterY());
  }

  if (player.getHealth() == 1 && healthBar.getImagePath().equals("sprites/health2.png")) {
    healthBar = new Sprite("sprites/health1.png", healthBar.getCenterX(), healthBar.getCenterY());
  }
}