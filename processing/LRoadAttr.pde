public class LRoadAttr {
  
  public float angle;
  public float distance;
  
  public LRoadAttr() {
    angle = PI/2.0; if(random(1.0)<0.5) angle*=-1.0;
    distance = random(64.0)+16.0;
  }
}
