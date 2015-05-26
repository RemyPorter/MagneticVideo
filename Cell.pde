color BASE_COLOR = color(255,255,255);
color RED_COLOR = color(255,0,0, 0.1);
color GREEN_COLOR = color(0,255,0, 0.1);
color BLUE_COLOR = color(0,0,255, 0.1);

void strokeBase() { stroke(255,255,255,1.0); }
void strokeRed() { stroke(255,0,0,0.25); }
void strokeGreen() { stroke(0,255,0,0.25); }
void strokeBlue() { stroke(0,0,255,0.25); }

class Cell {
  public float deflection = 0, defR=0, defG=0, defB=0;
  public int x,y,w,h;
  private Tone parent;
  public Cell(int x, int y, int w, int h, Tone parent) {
    this.x = x; this.y = y; this.w = w; this.h = h;
    this.parent = parent;
  }
  public int[] mapCenterToPoint(int width, int height) {
    int cx = (x + w / 2);
    int cy = (y + h / 2);
    int ox = int(map(cx, 0, displayWidth, 0, width));
    int oy = int(map(cy, 0, displayHeight, 0, height));
    return new int[] {ox, oy};
  }
  public void draw(float angle) {
    pushMatrix();
    translate(x+w/2,y+h/2);
    rotate(radians(angle));
    line(-w/2,-h/2,w/2,h/2);
    popMatrix();
  }
  public void draw() {
    strokeBase();
    draw(deflection);
    strokeRed();
    draw(defR);
    strokeGreen();
    draw(defG);
    strokeBlue();
    draw(defB);
  }
  public void deflect(int r, int g, int b) {
    deflection = (r + g + b )%(360);
    defR = map(r, 0,255,0,360);
    defG = map(g, 0, 255, 0, 360);
    defB = map(b, 0, 255, 0, 360);
    parent.vote(deflection);
  }
}

class Cells {
  public ArrayList<Cell> cells;
  public ArrayList<Tone> sounds;

  private Tone newTone(AudioOutput io, int index) {
    float amp = 100.0f / (float)CELLS_PER_TONE;
    Tone t = new Tone(new Oscil(BASE_FREQ, amp , Waves.SINE), index);
    t.sound.patch(io);
    return t;
  }
  public Cells(int rows, int cols, AudioOutput io) {
    cells = new ArrayList<Cell>(rows * cols);
    sounds = new ArrayList<Tone>(rows * cols / CELLS_PER_TONE);
    int rowSize = displayHeight / rows;
    int colSize = displayWidth / cols;
    Tone t = null;
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if ((i * j) % CELLS_PER_TONE == 0) {
          t = newTone(io, i + j);
          sounds.add(t);
        }
        Cell c = new Cell(i * colSize, j * rowSize, colSize, rowSize, t);
        cells.add(c);
        t.cells.add(c);
      }
    } 
  }
  public void draw(Capture cam) { 
    int w = cam.width;
    int h = cam.height;
    Cell c;
    for (int i = 0, j = 0; i < cells.size(); i++) {
      c = cells.get(i);
      int[] xy = c.mapCenterToPoint(w, h);
      color argb = cam.get(xy[0], xy[1]);
      int a = (argb >> 24) & 0xFF;
      int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
      int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
      int b = argb & 0xFF;          // Faster way of getting blue(argb)
      c.deflect(r,g,b);
      c.draw();
    }
    /*for (Tone t: sounds) {
      t.draw();
    }*/
  }
}
