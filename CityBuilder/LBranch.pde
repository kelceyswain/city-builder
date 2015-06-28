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
  int road_type=0;
  int number_of_roads = 0;
  color fc, bc;
  float branch_length=0.0;
  float type2_len = 50;
  float type1_len = 120;
  float type0_len = 150;
  public LBranch( LModule m1, LModule m2, float sx, float sy, float sa ) {
    modules = new ArrayList<LModule>();
    working = new ArrayList<LModule>();
    modules.add(m1);
    modules.add(m2);
    
    //float r = random(1.0);
    //if( r < 0.1 ) road_type = 0;
    //else if (r < 0.3) road_type = 1;
    //else if( r < 0.6) road_type =2;
    //else
    road_type=3;
    
    
    switch(road_type) {
      case(0):fc=color(0.0, 0.6, 0.2);bc=color(0.0, 0.3, 0.1); break;
      case(1):fc=color(1.0, 0.3, 0.3);bc=color(0.8, 0.1, 0.1); break;
      case(2):fc=color(1.0, 0.8, 0.4);bc=color(0.8, 0.6, 0.2); break;
      case(3):fc=color(1.0, 1.0, 1.0);bc=color(0.8, 0.8, 0.8); break;
    }
    //}
    /* Is this the right place to control this? */
    /* The branch angle is how the road patterns are created? */
    float branch_angle = 0.5*PI;
    if( random(1.0)<0.5) branch_angle *= -1;
    
    start_x = sx; start_y = sy; start_angle = sa + branch_angle;
    turtle_x = start_x; turtle_y = start_y; turtle_angle = sa;
    //c = color(random(1),random(1),random(1));
    
  }
  public void reset_turtle() {
    turtle_x = start_x; turtle_y = start_y;
    turtle_angle = start_angle;
    if(branch_length>type2_len) road_type=2;
    if(branch_length>type1_len) road_type=1;
    if(branch_length>type0_len) road_type=0;
      switch(road_type) {
      case(0):fc=color(0.0, 0.6, 0.2);bc=color(0.0, 0.3, 0.1); break;
      case(1):fc=color(1.0, 0.3, 0.3);bc=color(0.8, 0.1, 0.1); break;
      case(2):fc=color(1.0, 0.8, 0.4);bc=color(0.8, 0.6, 0.2); break;
      case(3):fc=color(1.0, 1.0, 1.0);bc=color(0.8, 0.8, 0.8); break;
    }  
   
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
    branch_length=0;
    float tx=start_x, ty=start_y, ta=start_angle;
    for(int c=0;c<modules.size();c++) {
      LModule m = modules.get(c);
      if(m.getType()==-1) {
        LTerminal t=(LTerminal)m;
        
        ta+=t.angle;
        float dx=t.distance*cos(ta);
        float dy=t.distance*-sin(ta);
        branch_length += t.distance;
        stroke(bc);
        strokeWeight(5);
        line(tx,ty,tx+dx,ty+dy);
        stroke(fc);
        strokeWeight(2);
        line(tx,ty,tx+dx,ty+dy);
        tx+=dx;ty+=dy;
      }
    }

  }
}

