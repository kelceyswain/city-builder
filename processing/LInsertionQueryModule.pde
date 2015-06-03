

public class LInsertionQueryModule implements LModule {
   public int getType() { return 1; }
   public int state; // -1, 0, 1 = UNASSIGNED
   public LRoadAttr road_attr;
   
   public LInsertionQueryModule( LRoadAttr ra, int s ) {
     state = s;
     road_attr = ra;
   }
   public String toString() { return "I"; }
}


