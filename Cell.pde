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
    int ox = int(map(cx, 0, displayWidth, width, 0));
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
