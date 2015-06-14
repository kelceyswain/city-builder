import java.util.Collections;

class RoadMap {

  int block_size = 20;
  int num_blocks_x = width / block_size;
  int num_blocks_y = height / block_size;

  
  ArrayList<Road> roads;

  float[] terrain;
  
  public RoadMap(float[] t) {
    terrain=t;
    // Set up variables
    roads=new ArrayList<Road>();

  }
  
  Road addRoad( float x1, float y1, float z1, float x2, float y2, float z2 ) {
    Road r = new Road(x1,y1,z1,x2,y2,z2);
    roads.add(r);

    return r;
  }
  
  void draw_roads() {
    for( int c=0; c<roads.size();c++ ) {
      Road r =roads.get(c);//.drawMe();
      drawRoad(r);
    }
  }
   void drawRoad(Road r) {
    strokeWeight(2.0);
    strokeCap(ROUND);
    stroke(0.24,0.85,0.23);
    float drawn=0.0; float cx=r.staX; float cy=r.staY;

    int apx=(int)r.staX; int epx=(int)r.endX;
    int apy=(int)r.staY; int epy=(int)r.endY;
    float z1=terrain[apy*width+apx];
    float z2=terrain[epy*width+epx];
    line(r.staX,r.staY,z1,r.endX,r.endY,z2);
    //println("line("+staX+","+staY+","+staZ+","+endX+","+endY+","+endZ+");");
  }
  
  
  boolean crosses_road( float x1, float y1, float x2, float y2 ) {
    Road tmp = new Road(x1,y1,0,x2,y2,0);
    
    for( int c=0; c<roads.size();c++ ) {
      if( tmp.crosses(roads.get(c)) ) return true;
    }
    
    return false;
  }
}

