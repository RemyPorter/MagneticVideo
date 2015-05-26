import processing.video.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

int COL_COUNT = (int)(160*1);
int ROW_COUNT= (int)(90*1);
int BASE_FREQ = 60;
int CELLS_PER_TONE = 640;
int FREQUENCY_WOBBLE = 30;
int MAX_FREQ = BASE_FREQ + FREQUENCY_WOBBLE/2;
int MIN_FREQ = BASE_FREQ - FREQUENCY_WOBBLE/2;


Capture cam;
Cells cs;

int FPS = 60;

Minim minim = new Minim(this);
AudioOutput io = minim.getLineOut(minim.MONO, 512);

void setup() {
  colorMode(RGB,255,255,255,1.0);
  size(displayWidth, displayHeight, OPENGL);
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


