import java.util.Collections;

class RoadMap {

  int block_size = 20;
  int num_blocks_x = width / block_size;
  int num_blocks_y = height / block_size;

  
  ArrayList<Road> roads;


  public RoadMap() {
    
    // Set up variables
    roads=new ArrayList<Road>();

  }
  
  Road addRoad( float x1, float y1, float x2, float y2 ) {
    
    OscMessage msg = new OscMessage("/road");
    msg.add(x1/W);
    msg.add(y1/H);
    msg.add(x2/W);
    msg.add(y2/H);
    osc.send(msg, supercollider);
    
    Road r = new Road(x1,y1,x2,y2);
    roads.add(r);

    return r;
  }
  
  void draw_roads() {
    for( int c=0; c<roads.size();c++ ) {
      roads.get(c).drawMe();
    }
  }
  
  boolean crosses_road( float x1, float y1, float x2, float y2 ) {
    Road tmp = new Road(x1,y1,x2,y2);
    
    for( int c=0; c<roads.size();c++ ) {
      if( tmp.crosses(roads.get(c)) ) return true;
    }
    
    return false;
  }
}

