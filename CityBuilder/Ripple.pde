public class Ripple {
  float centre_x, centre_y;
  float speed = 12.0;
  float diameter;
  float MAX_DIAMETER=500.0;
  float FADEAT=100.0;
  
  public Ripple( float cx, float cy ) {
    centre_x = cx;
    centre_y = cy;
    diameter=1;
  }

  public void drawme() {
    noFill();

    float alpha=0.4;
    float ratio = FADEAT/diameter;
    
    if( diameter > FADEAT ) alpha=0.4 *ratio*ratio;
        stroke(.5, .5, .5, alpha);
        strokeWeight(10.0);
    ellipse(centre_x, centre_y, diameter, diameter);
    diameter+=speed;
  }
}

