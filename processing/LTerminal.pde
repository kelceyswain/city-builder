public class LTerminal implements LModule {

  public float angle;
  public float distance;
  public Road myRoad;
  
  public LTerminal( float a, float d ) { angle=a; distance=d; myRoad=null; }
  
  public int getType() { return -1; }
  public String toString() {
    return "+<"+angle+">F<"+distance+">";
  }
}

