class Tone {
  public ArrayList<Cell> cells = new ArrayList(CELLS_PER_TONE);
  public Oscil sound;
  private int index;
  private int base;
  private float votes = 0;
  private int voted = 0;
  public Tone(Oscil sound, int index) {
    this.sound = sound;
    this.base = BASE_FREQ;
  }
  //this voting function makes it easy to "unroll the loop", to minimize the total 
  //number of iterations.
  //Specifically, each Cell that this watches adds its deflection using this vote function.
  //When everybody has voted, the tone calculates the average and updates its state.
  public void vote(float deflection) {
    votes += deflection;
    voted++;
    if (voted == cells.size()) {
      draw();
      voted = 0; votes = 0;
    }
  }
  public void draw() {
    int averageDefl = (int)(votes / voted);
    averageDefl /= cells.size();
    sound.setPhase(map(averageDefl % 360, 0, 360, 0.0, 1.0));
    sound.setFrequency(base + averageDefl % FREQUENCY_WOBBLE - FREQUENCY_WOBBLE / 2);
  }
}
