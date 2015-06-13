class Road {

  float staX, staY;
  float endX, endY;

  public Road( float x1, float y1, float x2, float y2 ) {
    staX=x1; staY=y1; endX=x2; endY=y2;
  }  
  
  void drawMe() {
    strokeWeight(2.0);
    strokeCap(ROUND);
    stroke(0.24,0.85,0.23);
    line(staX,0,staY,endX,0,endY);
  }
  
  boolean crosses( Road r ) {
    if( get_line_intersection(r.staX,r.staY,r.endX,r.endY,staX,staY,endX,endY)==true) return true;
    
    return false;
  }
  
  // Returns 1 if the lines intersect, otherwise 0. In addition, if the lines 
// intersect the intersection point may be stored in the floats i_x and i_y.
boolean get_line_intersection(float p0_x, float p0_y, float p1_x, float p1_y, float p2_x, float p2_y, float p3_x, float p3_y)
{
   float i_x,  i_y;
    float s1_x, s1_y, s2_x, s2_y;
    s1_x = p1_x - p0_x;     s1_y = p1_y - p0_y;
    s2_x = p3_x - p2_x;     s2_y = p3_y - p2_y;

    float s, t;
    s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y);
    t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y);

    if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
    {
        // Collision detected
//        if (i_x != NULL)
//            i_x = p0_x + (t * s1_x);
//        if (i_y != NULL)
//            i_y = p0_y + (t * s1_y);
        return true;
    }

    return false; // No collision
}
}

