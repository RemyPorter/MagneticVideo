import processing.video.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

//Cols/rows are in a 16:9 ratio.
//Adjust the multiplier to change the "resolution."
//This controls the number of "/" cells that will be drawn to the screen.
final int COL_COUNT = (int)(160*1);
final int ROW_COUNT= (int)(90*1);
//The root "Note" of the various tone oscilators
final int BASE_FREQ = 60;
//How much the core frequency can deviate IN TOTAL.
//a FREQUENCY_WOBBLE of 30 means +/-15.
final int FREQUENCY_WOBBLE = 40;
//Each Tone object is going to watch some number
//of cells, and average their deflection to decide
//what sound to make. Too small a value here means
//the minim oscilators get all cruddy.
final int CELLS_PER_TONE = 640;

final int MINIM_BUFFER = 512;

final int MAX_FREQ = BASE_FREQ + FREQUENCY_WOBBLE/2;
final int MIN_FREQ = BASE_FREQ - FREQUENCY_WOBBLE/2;
final int FPS = 60;

Capture cam;
Cells cs;

Minim minim = new Minim(this);
AudioOutput io = minim.getLineOut(minim.MONO, MINIM_BUFFER);

void setup() {
  colorMode(RGB,255,255,255,1.0);
  size(displayWidth, displayHeight, OPENGL); //even though this isn't 3D, the OpenGL renderer performs WAY better
  frameRate(FPS);
  cam = new Capture(this, Capture.list()[0]);
  cam.start();
  imageMode(CENTER);
  background(0,0,0,0);
  fill(0,0,0);
  strokeWeight(1.12);
  cs = new Cells(ROW_COUNT, COL_COUNT, io);
}

void draw() {
  clear();
  if (cam.available() ){
    cam.read();
  }
  cs.draw(cam);
}

void keyPressed() {
  saveFrame();
}


