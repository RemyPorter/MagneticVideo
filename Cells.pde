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
  }
}
