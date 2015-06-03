public class LBranchModule implements LModule {
    int del;
    LRuleAttr rule_attr;
    LRoadAttr road_attr;
    
    public int getType() { return 2; }
    public String toString() { return "B"; }
    
    public LBranchModule( int d, LRuleAttr ru, LRoadAttr ro ) {
      del=d; rule_attr=ru; road_attr=ro;
    }
}

