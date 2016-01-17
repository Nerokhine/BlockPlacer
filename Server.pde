//imports
import java.util.*;
import java.io.*;
import java.awt.image.*;
import javax.imageio.ImageIO;
import java.util.ArrayList;
import java.lang.Math;
import java.text.DecimalFormat;
import javax.swing.JOptionPane;
import processing.net.*;

Server s;  // Start a simple server on a port
Client client;
String input;


DecimalFormat noDecimals = new DecimalFormat("#");
float xPos, yPos;//values of player 1
float xPos2, yPos2;//values of player 2
float radPlayer = 15, speed = 4, terminalVelocity = 20;//shared values between players
float sideSpeed = 0;
int blockOn = -1;
int currentID = 1;
int selectImage = 3;
int maxOB = 5000;
boolean[] BulletBool = new boolean[20];
float[] BulletsX = new float[20];
float[] BulletsY = new float[20];
float[] BulletsYT = new float[20];
float[] BulletsXT = new float[20];
ArrayList<String> newBlocks = new ArrayList();
ArrayList<Block> blocks = new ArrayList();
int b = 0;
float t = 0, t2 = 0, jh = 10, maxJH = 15;
int c = 0;
float d = 0;
Random r = new Random();
float acc = 0.4, velocity = 0;
boolean pressedKeyUp = false, pressedKeyDown = false, pressedKeyLeft = false, pressedKeyRight = false, pressedKeySpace = false, pressedKeyF = false, air = true, falling = true;
import ddf.minim.*;
AudioPlayer player;
Minim minim, minim2;//audio context
// Declaring a variable of type PImage
PImage[] img = new PImage[20];
String data;
File dir;




void setup() {//upon startup of the game
  // Folder that you want to traverse
  data = dataPath("");
  System.out.println(data);
  dir = new File(data + "\\Worlds\\");
  
  File inputFolder = dir;
  //frameRate(30);
  int p = traverse(inputFolder);
  String[] worlds = new String[p];
  traverse(inputFolder, worlds, -1);
  String newData = data + "\\Worlds\\" + worlds[JOptionPane.showOptionDialog(null, "Please choose a world to play in.", "World Select", JOptionPane.DEFAULT_OPTION, JOptionPane.QUESTION_MESSAGE, null, worlds, 1)];
  s = new Server(this, 12345);
  /*minim2 = new Minim(this);
   player = minim2.loadFile("some music", 2048);
   player.loop();*/
  //load up the images
  img[0] = loadImage("dirt.jpg");
  img[1] = loadImage("grass.jpg");
  img[2] = loadImage("stone.jpg");
  img[3] = loadImage("stonebrick.jpg");
  img[4] = loadImage("redwool.png");
  img[5] = loadImage("cute_face.png");
  //reads in the file containing all the block information
  readFile(newData);
  //sets the size of the game
  size(1000, 600);
  xPos = 500;
  yPos = 180;
  xPos2 = 600;
  yPos2 = 380;
  smooth();//makes the program look nice
}

int traverse(File parentNode) {
  File childNodes[] = parentNode.listFiles();
  int t = 0;
  for (File childNode : childNodes) {
    t += 1;
  }
  return t;
}

void traverse(File parentNode, String[] worlds, int c) {
  if (parentNode.isDirectory()) {
    File childNodes[] = parentNode.listFiles();
    for (File childNode : childNodes) {
      traverse(childNode, worlds, ++c);
    }
  } 
  else {
    worlds[c] = parentNode.getName();
  }
}
void draw() {
  //server stuff
  // Receive data from server
  //s.write(xPos + "|" + yPos + "!"); //sends the other person your co-ordinates
  s.write(xPos + " " + yPos + "\n");
  client = s.available();
  if (client != null) {
    input = client.readStringUntil('\n');
    if (input != null) {
      int pos =  input.indexOf(' ');
      xPos2 = Float.parseFloat(input.substring(0, pos));
      yPos2 = Float.parseFloat(input.substring(pos + 1, input.length()));
    }
  }
  //server stuff ends

  c+= 1;    
  t2 = 400 - radPlayer - yPos;
  t = 500 - xPos;
  if (sideSpeed > 0) {
    sideSpeed -= .03;
    if (sideSpeed <= 0) {
      sideSpeed = 0;
    }
  } 
  else if (sideSpeed < 0) {
    sideSpeed += .03;
    if (sideSpeed >= 0) {
      sideSpeed = 0;
    }
  }
  translate(t, t2);
  background(#030202);
  fill(#A20B8F);
  fill(#FC42D5);
  //ground
  for (int x = -5000; x < 5000; x+= 20) {
    image(img[0], x, 580, 20, 20);
    image(img[0], x, 560, 20, 20);
    image(img[0], x, 540, 20, 20);
    image(img[0], x, 520, 20, 20);
    image(img[0], x, 500, 20, 20);
    image(img[0], x, 480, 20, 20);
    image(img[0], x, 460, 20, 20);
    image(img[0], x, 440, 20, 20);
    image(img[0], x, 420, 20, 20);
    image(img[1], x, 400, 20, 20);
  }
  //for moving objects
  for (int x = 0; x < blocks.size(); ++x) {
    if (blocks.get(x).getMoving() == 1) {
      blocks.get(x).setxPos(blocks.get(x).getxPos() + blocks.get(x).getSpeedX());
      blocks.get(x).setyPos(blocks.get(x).getyPos() + blocks.get(x).getSpeedY());
    }
  } 
  //space reserved for moving objects
  if (c == 1) {//makes a circular motion platform
    c = 0;
    if (d == 360) {
      d = 0;
    }
    d+= 1;
    float h = 1.5 * (float)(Math.cos((d * Math.PI)/180));
    float l = 1.5 * (float)(Math.sin((d * Math.PI)/180));
    blocks.get(3).setSpeedX(l);
    blocks.get(3).setSpeedY(h);
    blocks.get(4).setSpeedX(l);
    blocks.get(4).setSpeedY(h);
    blocks.get(5).setSpeedX(l);
    blocks.get(5).setSpeedY(h);
  } 
  //space reserved ends
  //moves character with the block he is on.
  if (blockOn != -1) {
    xPos += blocks.get(blockOn).getSpeedX();
    yPos = blocks.get(blockOn).getyPos() - radPlayer - blocks.get(blockOn).getWid();
  }
  //draws player 1
  image(img[5], xPos - radPlayer, yPos - radPlayer, radPlayer * 2, radPlayer * 2);
  //draws player 2
  image(img[5], xPos2 - radPlayer, yPos2 - radPlayer, radPlayer * 2, radPlayer * 2);
  //draws all of the objects (very important)
  for (int x = 0; x < blocks.size(); ++x) {
    if (abs(xPos - blocks.get(x).getxPos()) <= 600 && abs(yPos - blocks.get(x).getyPos()) <= 600) {//only renders image if you are close enough (when block is on screen)
      image(img[blocks.get(x).getType()], blocks.get(x).getxPos() - blocks.get(x).getLen(), blocks.get(x).getyPos() - blocks.get(x).getWid(), blocks.get(x).getLen() * 2, blocks.get(x).getWid() * 2);
    }
  }
  fill(#EEFF05);
  stroke(#EEFF05);
  //draws bullets
  for (int x = 0; x < 20; x ++) {
    if (BulletBool[x] == true) {
      BulletsX[x] += BulletsXT[x];
      BulletsY[x] += BulletsYT[x];
      ellipse(BulletsX[x], BulletsY[x], 5, 5);
    }
  }

  checkAir();
  xPos += sideSpeed;
  if (pressedKeyRight) {
    xPos = xPos + speed;
  }
  xPos = rightCollision();
  if (pressedKeyLeft) {
    xPos = xPos - speed;
  }
  xPos = leftCollision();
  if (air && !falling) {
    velocity -= acc;
    yPos = upCollision();
    if (velocity <= 0) {
      falling = true;
    }
  }
  if (air && falling) {
    yPos = downCollision();
    if (velocity <= terminalVelocity) {
      velocity += acc;
    }
  }
}

void checkAir() {
  for (int x = 0; x < blocks.size(); x ++) {
    if (((yPos + radPlayer == blocks.get(x).getyPos() - blocks.get(x).getWid()) && 
      ((xPos + radPlayer < blocks.get(x).getxPos() - blocks.get(x).getLen()) || (xPos - radPlayer > blocks.get(x).getxPos() + blocks.get(x).getLen())))) {
      air = true;
      falling = true;
      blockOn = -1;
    }
  }
}

public float upCollision() {
  for (int x = 0; x < blocks.size(); x ++) {
    if (((yPos - radPlayer - velocity < blocks.get(x).getyPos() + blocks.get(x).getWid()) && 
      !(yPos - radPlayer - velocity < blocks.get(x).getyPos() - blocks.get(x).getWid())) && 
      ((xPos + radPlayer > blocks.get(x).getxPos() - blocks.get(x).getLen()) && 
      (xPos - radPlayer < blocks.get(x).getxPos() + blocks.get(x).getLen()))) {
      velocity = 0;
      return blocks.get(x).getyPos() + blocks.get(x).getWid() + radPlayer + 1;
    }
  }
  return yPos - velocity;
}
public float downCollision() {
  //collision with ground
  if (yPos + radPlayer + velocity >= 400) {
    velocity = 0;
    falling = false;
    air = false;
    return 400 - radPlayer;
  }
  //collision with blocks
  for (int x = 0; x < blocks.size(); x ++) {
    if (((yPos + radPlayer + velocity > blocks.get(x).getyPos() - blocks.get(x).getWid()) && 
      !(yPos + radPlayer + velocity > blocks.get(x).getyPos() + blocks.get(x).getWid())) && 
      ((xPos + radPlayer > blocks.get(x).getxPos() - blocks.get(x).getLen()) && 
      (xPos - radPlayer < blocks.get(x).getxPos() + blocks.get(x).getLen()))) {
      velocity = 0;
      air = false;
      falling = false;
      blockOn = x;
      return blocks.get(x).getyPos() - blocks.get(x).getWid() - radPlayer;
    }
  }
  return yPos + velocity;
}

public float leftCollision() {
  for (int x = 0; x < blocks.size(); x ++) {
    if (((xPos - radPlayer < blocks.get(x).getxPos() + blocks.get(x).getLen()) && 
      !(xPos - radPlayer < blocks.get(x).getxPos() - blocks.get(x).getLen())) && 
      ((yPos + radPlayer > blocks.get(x).getyPos() - blocks.get(x).getWid()) && 
      (yPos - radPlayer < blocks.get(x).getyPos() + blocks.get(x).getWid()))) {
      return blocks.get(x).getxPos() + blocks.get(x).getLen() + radPlayer;
    }
  }
  return xPos;
}
public float rightCollision() {
  for (int x = 0; x < blocks.size(); x ++) {
    if (((xPos + radPlayer > blocks.get(x).getxPos() - blocks.get(x).getLen()) && 
      !(xPos + radPlayer > blocks.get(x).getxPos() + blocks.get(x).getLen())) && 
      ((yPos + radPlayer > blocks.get(x).getyPos() - blocks.get(x).getWid()) && 
      (yPos - radPlayer < blocks.get(x).getyPos() + blocks.get(x).getWid()))) {
      return blocks.get(x).getxPos() - blocks.get(x).getLen() - radPlayer;
    }
  }
  return xPos;
}

//if a key is pressed
void keyPressed() {
  if (key == 'w') {
    pressedKeyUp = true;
  } 
  if (key == 's') {
    pressedKeyDown = true;
  }
  if (key == 'a') {
    pressedKeyLeft = true;
  }
  if (key == 'd') {
    pressedKeyRight = true;
  }
  if (key == 'p') {
    String name = JOptionPane.showInputDialog(null, "What do you want to name your file?", "Save", JOptionPane.OK_CANCEL_OPTION);
    if (name != null) {
      try {
        FileWriter fw = new FileWriter("Worlds\\" + name + ".txt");
        BufferedWriter bw = new BufferedWriter(fw);
        //writes every single highscore to the file
        for (int x = 0; x < newBlocks.size(); x ++) {
          bw.write(newBlocks.get(x));
          bw.newLine();
        }
        bw.close();
        fw.close();
        //closes the file writer
        System.out.println("Save was successful.");
      }
      catch(IOException e) {
        System.out.println("Save was not successful.");
      }
    }
  }
  if (key == ' ') {
    if (!air) {
      pressedKeySpace= true;
      air = true;
      yPos -= 5;
      if (blockOn != -1) {
        sideSpeed = blocks.get(blockOn).getSpeedX();
      }
      blockOn = -1;
      velocity = jh;//governs jump height
      minim = new Minim(this);
      player = minim.loadFile("Jump.mp3", 2048);
      player.shiftGain(-20.0, 0.0, 10000);
      player.play();
    }
  }
  if (key == 'f') {
    pressedKeyF = true;
  }
}
//if a key is released
void keyReleased() {
  if (key == 'w') {
    pressedKeyUp = false;
  } 
  if (key == 's') {
    pressedKeyDown = false;
  }
  if (key == 'a') {
    pressedKeyLeft = false;
  }
  if (key == 'd') {
    pressedKeyRight = false;
  }  
  if (key == ' ') {
    pressedKeySpace= false;
  }
  if (key == '1') {
    System.out.println("Selected Block: Dirt");
    selectImage = 0;
  }
  if (key == '2') {
    System.out.println("Selected Block: Grass");
    selectImage = 1;
  }
  if (key == '3') {
    System.out.println("Selected Block: Stone");
    selectImage = 2;
  }
  if (key == '4') {
    System.out.println("Selected Block: Stone Brick");
    selectImage = 3;
  }

  if (key == 'f') {
    pressedKeyF = false;
    float mousex = mouseX - t, mousey = mouseY - t2;
    if (b == 20) {
      b = 0;
    }
    float dirX = abs(mousex - xPos);
    float dirY = abs(mousey - yPos);
    float tot = dirX + dirY;
    BulletBool[b] = true;
    if (mousex > xPos) {
      BulletsXT[b] = 20 * dirX/tot;
    } 
    else {
      BulletsXT[b] = 20 * (-1 * dirX)/tot;
    }
    if (mousey > yPos) {
      BulletsYT[b] = 20 * dirY/tot;
    } 
    else {
      BulletsYT[b] = 20 * (-1 * dirY)/tot;
    }
    BulletsX[b] = xPos;
    BulletsY[b] = yPos;
    b += 1;
    /*minim = new Minim(this);
    player = minim.loadFile("Laser.mp3", 2048);
    player.shiftGain(-20.0, 0.0, 10000);
    player.play();*/
  }
}
void mousePressed() {
  float mousex = mouseX - t, mousey = mouseY - t2;
  float xPosNew = Math.round(mousex) + 10;
  float yPosNew = Math.round(mousey) + 10;
  xPosNew = xPosNew - (xPosNew - 10) % 20;
  yPosNew = yPosNew - (yPosNew - 10) % 20;
  if (mouseButton == LEFT) {//block creation
    //makes sure you don't create a block on top of a block
    Boolean overlap = false;
    for (int x = 0; x < blocks.size(); ++x) {
      if (abs(xPosNew - blocks.get(x).getxPos()) <= 0.0001 && abs(yPosNew - blocks.get(x).getyPos()) <= 0.0001) {
        overlap = true;
      }
    }
    if (overlap == false) {
      Block b = new Block(currentID, 10, 10, selectImage, xPosNew, yPosNew, 0, 0, 0);
      blocks.add(b);
      newBlocks.add(currentID + ", " + 10 + ", " + 10 + ", " + selectImage + ", " + noDecimals.format(xPosNew)
        + ", " + noDecimals.format(yPosNew) + ", " + 0 + ", " + 0 + ", " + 0 + ":");
      currentID += 1;
    }
  } 
  else if (mouseButton == RIGHT) {//block deletion
    for (int x = 0; x < blocks.size(); ++x) {
      if (abs(xPosNew - blocks.get(x).getxPos()) <= 0.0001 && abs(yPosNew - blocks.get(x).getyPos()) <= 0.0001) {
        for (int y = 1; y < newBlocks.size(); ++y) {//takes the block out of the string memory
          int num = Integer.parseInt(newBlocks.get(y).substring(0, newBlocks.get(y).indexOf( "," )));
          if (num == blocks.get(x).getID()) {
            newBlocks.remove(y);
          }
        }
        blocks.remove(x);
      }
    }
  }
}

void readFile(String newData) {
  try {
    //reads in the file
    FileReader fr = new FileReader(newData);
    BufferedReader br = new BufferedReader(fr);
    String line = "";
    boolean eof = false;
    line = br.readLine();
    newBlocks.add(line);
    while (eof == false) {
      line = br.readLine();
      if (line != null) {
        newBlocks.add(line);
        int ID;
        float len;
        float wid;
        int type;
        float xPos;
        float yPos;
        float speedX;
        float speedY; 
        int moving;
        int ind = line.indexOf( "," );
        ID = Integer.parseInt(line.substring(0, ind));
        line = line.substring(ind + 2, line.length());
        ind = line.indexOf( "," );
        len = Integer.parseInt(line.substring(0, ind));
        line = line.substring(ind + 2, line.length());
        ind = line.indexOf( "," );
        wid = Integer.parseInt(line.substring(0, ind));
        line = line.substring(ind + 2, line.length());
        ind = line.indexOf( "," );
        type = Integer.parseInt(line.substring(0, ind));
        line = line.substring(ind + 2, line.length());
        ind = line.indexOf( "," );
        xPos = Integer.parseInt(line.substring(0, ind));
        line = line.substring(ind + 2, line.length());
        ind = line.indexOf( "," );
        yPos = Integer.parseInt(line.substring(0, ind));
        line = line.substring(ind + 2, line.length());
        ind = line.indexOf( "," );
        speedX = Float.parseFloat(line.substring(0, ind));
        line = line.substring(ind + 2, line.length());
        ind = line.indexOf( "," );
        speedY = Float.parseFloat(line.substring(0, ind));
        line = line.substring(ind + 2, line.length());
        ind = line.indexOf( "," );
        moving = Integer.parseInt(line.substring(0, line.indexOf( ':' )));        
        Block b = new Block(ID, len, wid, type, xPos, yPos, speedX, speedY, moving);
        blocks.add(b);
        currentID = ID + 1;
      } 
      else {
        eof = true;
      }
    }
    //closes the file
    br.close();
    fr.close();
  }
  catch(IOException e) {//displays an error message if the file can't be found
    System.out.println("System: Lol I can't find the file 0_o");
  }
}

