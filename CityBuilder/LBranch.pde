public class LBranch {

  ArrayList<LModule> modules;
  ArrayList<LModule> working;
  
  OscMessage message;
  
  float start_x = 0.0;
  float start_y = 0.0;
  float start_angle = 0.0;
  float turtle_x = 0.0;
  float turtle_y = 0.0;
  float turtle_angle = 0.0;
  int children_remaining = 3;
  
  color c;
  
  public LBranch( LModule m1, LModule m2, float sx, float sy, float sa ) {
    modules = new ArrayList<LModule>();
    working = new ArrayList<LModule>();
    modules.add(m1);
    modules.add(m2);
    
    OscMessage msg = new OscMessage("/branch");
    msg.add(sx);
    msg.add(sy);
    msg.add(sa);
    osc.send(msg, supercollider);

    /* Is this the right place to control this? */
    /* The branch angle is how the road patterns are created? */
    float branch_angle = 0.5*PI;
    if( random(1.0)<0.5) branch_angle *= -1;
    
    start_x = sx; start_y = sy; start_angle = sa + branch_angle;
    turtle_x = start_x; turtle_y = start_y; turtle_angle = sa;
    c = color(random(1),random(1),random(1));
    
  }
  public void reset_turtle() {
    turtle_x = start_x; turtle_y = start_y;
    turtle_angle = start_angle;
   
  }
  void applyTerminalToTurtle( LTerminal t ) {
    turtle_angle += t.angle;
    
    float dx = t.distance*cos(turtle_angle);
    float dy = t.distance*-sin(turtle_angle);
    turtle_x += dx;
    turtle_y += dy;
  }
  
  public String toString() {
    String out = "[";
    for( int c=0; c<modules.size();c++ ) {
      out = out + modules.get(c);
    }
    out=out+"]";
    return out;
  }
  
  void drawMap() {
    stroke(c);
    float tx=start_x, ty=start_y, ta=start_angle;
    for(int c=0;c<modules.size();c++) {
      LModule m = modules.get(c);
      if(m.getType()==-1) {
        LTerminal t=(LTerminal)m;
        
        ta+=t.angle;
        float dx=t.distance*cos(ta);
        float dy=t.distance*-sin(ta);
        line(tx,ty,tx+dx,ty+dy);
        tx+=dx;ty+=dy;
      }
    }
  }
}

