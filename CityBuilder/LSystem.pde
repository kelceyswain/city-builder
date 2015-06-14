class LSystem {

  /* Maximum deletion parameter for building new branches */
  final int def_del = 1000;
  
  /* Likelihood that a potential road will not be built */
  final float fudge_factor = 0.15;
  
  /* Gap to leave at the edge */
  final int border=10;
  
  /* Angle to search around the current road end to build the next section */
  final float density_search_angle = 0.1*PI;//(2.0/3.0)*PI; // figure 4 guess
  
  float startx = width/2;
  float starty = height/2;

  ArrayList<LBranch> branches;
  
  RoadMap roads;
  float[] population_density;
  float[] terrain;
  
  /* Constructor */
  public LSystem( float[] pd, float[] t ) {

    population_density = pd; terrain = t;

    /* Initial data structures */
    branches = new ArrayList<LBranch>();
    roads = new RoadMap();
    
    /* Get an initial proposed road from globalGoals */
    LRoadAttr initRoadAttr = globalGoals(startx, starty, 0.0);

    /* Create the rules in the first branch */
    LBranch root = new LBranch(new LRoadModule(0, new LRuleAttr()), new LInsertionQueryModule(initRoadAttr, 1), startx, starty,0.0 );

    branches.add(root);
  }
  
  /* update_branches: iterate over every branch in the array */
  public void update_branches() {

    for ( int b=0; b<branches.size (); b++ ) {
      LBranch tmp = branches.get(b);
      tmp.reset_turtle();
      updateBranch(tmp);
      tmp.drawMap();
    }
  }

  public void updateBranch(LBranch b) {

    for ( int c=0; c<b.modules.size (); c++) {
      applyRulesToBranchModule(b, c);
    }

    b.modules.clear();
    b.modules = b.working;
    b.working = new ArrayList<LModule>();
  }
  
  public void draw_roads() {
    for ( int b=0; b<branches.size (); b++ ) {
      branches.get(b).drawMap();
    }
    roads.draw_roads();
  }


  // ApplyRule: reads module at position, tries to apply all rules, stops when one hits and applies successor to working list
  public void applyRulesToBranchModule( LBranch b, int position ) {

    ArrayList<LModule> m_list = b.modules;
    ArrayList<LModule> m_work = b.working;

    int m_sz = m_list.size();

    LModule left_context = ( position-1>=0 ) ? m_list.get(position-1) : null;
    LModule predecessor = m_list.get(position);
    LModule right_context =( position+1<m_sz ) ? m_list.get(position+1) : null;

    //case 1:
    if ( predecessor.getType()==0 ) {
      if ( ((LRoadModule)predecessor).del<0 ) { 
        return; // the rule matches, produces an empty string
      }
    }
    //case 2:
    if ( predecessor.getType()==0 ) {
      if ( right_context.getType()==1 ) {
        if ( ((LInsertionQueryModule)right_context).state==0 ) { // STATE 0 == SUCCEED
          // the rule matches, produce terminals based on attributes
          LInsertionQueryModule iq = (LInsertionQueryModule)right_context;

          m_work.add(new LTerminal(iq.road_attr.angle, iq.road_attr.distance));
          //b.turtle_x += iq.road_attr.distance*cos(iq.road_attr.angle);
          //b.turtle_y += iq.road_attr.distance*-sin(iq.road_attr.angle);

          // branch at each end, and a potential road from the end as well?
          m_work.add(new LBranchModule((int)random(def_del), new LRuleAttr(), new LRoadAttr()));
          m_work.add(new LBranchModule((int)random(def_del), new LRuleAttr(), new LRoadAttr()));

          float end_x = b.turtle_x; 
          float end_y = b.turtle_y;
          LRoadAttr ra = globalGoals(end_x, end_y, b.turtle_angle);
          ra.angle -= b.turtle_angle;
          
          m_work.add(new LRoadModule((int)random(def_del), new LRuleAttr()));
          m_work.add(new LInsertionQueryModule(ra, 1 ));

          return;
        }
      }
    }
    //case 3:
    if ( predecessor.getType()==0 ) {
      if ( right_context.getType()==1 ) {
        if ( ((LInsertionQueryModule)right_context).state==-1 ) { // STATE -1 == FAILED
          return; // the rule matches, produce an empty string.
        }
      }
    }
    //case 4:
    if ( predecessor.getType()==2 ) {
      if ( ((LBranchModule)predecessor).del > 0 ) { // Not time for branch creation yet
        LBranchModule tmp = (LBranchModule)predecessor; 
        m_work.add( new LBranchModule( tmp.del-1, tmp.rule_attr, tmp.road_attr ) );
        return;
      }
    }
    //case 5:
    if ( predecessor.getType()==2 ) {
      if ( ((LBranchModule)predecessor).del == 0 ) { // Branch creation time
        if(b.children_remaining<1) return;
        LBranchModule tmp = (LBranchModule)predecessor;
        
        LRuleAttr new_road_rule_attributes = new LRuleAttr();
        LRoadModule new_road_in_branch = new LRoadModule(0, new_road_rule_attributes);
        LRoadAttr branch_attributes = new LRoadAttr();
        
        branch_attributes.angle = 0.0;
        LInsertionQueryModule new_iq = new LInsertionQueryModule(branch_attributes, 1); // state 1==unassigned
        
        LBranch tmp_b = new LBranch(new_road_in_branch, new_iq, b.turtle_x, b.turtle_y, b.turtle_angle );
        b.children_remaining--;
        //LBranch tmp_b = new LBranch(new LRoadModule(0, tmp.rule_attr), new LInsertionQueryModule(new LRoadAttr(), 1), b.turtle_x, b.turtle_y, b.turtle_angle ); // STATE 1 == UNASSIGNED
        branches.add(tmp_b);
        return;
      }
    }
    //case 6:
    if ( predecessor.getType()==2 ) {
      if ( ((LBranchModule)predecessor).del < 0 ) { // Branch module deletion time
        return; // empty string
      }
    }
    //case 7:
    if ( predecessor.getType()==1 ) {
      if ( left_context.getType()==0 ) {
        if ( ((LRoadModule)left_context).del < 0 ) {
          return; // empty string = delete this Insertion Query Rule
        }
      }
    }
    //case 8:
    if ( predecessor.getType()==1 ) {
      LInsertionQueryModule tmp = (LInsertionQueryModule)predecessor;
      if ( tmp.state == 1 ) { // UNASSIGNED
        // TODO Local Constraints
        // for now just everything is ok
        checkLocalConstraints(tmp, b.turtle_x, b.turtle_y,b.turtle_angle);
        m_work.add( tmp );
        return;
      }
    }
    //case 9:
    if ( predecessor.getType()==1 ) {
      LInsertionQueryModule tmp = (LInsertionQueryModule)predecessor;
      if ( tmp.state != 1 ) { // NOT UNASSIGNED
        return; // empty string => delete it
      }
    }
    if ( predecessor.getType()==-1 ) { // terminal string
      LTerminal tmp = (LTerminal)predecessor;
      float pre_x = b.turtle_x, pre_y = b.turtle_y; // start of road is where turtle is
      b.applyTerminalToTurtle(tmp);
      if( tmp.myRoad==null) tmp.myRoad = roads.addRoad(pre_x,     pre_y,     terrain[(int)(width*pre_y+pre_x)],
                                                       b.turtle_x,b.turtle_y,terrain[(int)(width*b.turtle_y+b.turtle_x)]); // add road to roads
      
      m_work.add( tmp ); // just copy it out
      return;
    }
    // if we get here, nothing matched so we just rewrite the module in the new list
    m_work.add( predecessor );
  }

  LRoadAttr globalGoals( float sx, float sy, float sa ) {

    LRoadAttr result = new LRoadAttr();

    // Distance around this end to search
    float max_search_radius = 18.0/population_density[(int)sx+(int)sy*width];
    float min_search_radius = 6.0/population_density[(int)sx+(int)sy*width];

    // number of rays to sample around the end
    int NUM_RAYS = 10;

    // number of samples along any one ray
    int NUM_SAMPLES = 10;

    float current_best = -MAX_FLOAT;
    float cbx=0.0, cby=0.0;
    float cb_angle=0.0, cb_distance=0.0;

    for (int c=0; c<NUM_RAYS; c++) {
      // Start our sample target at sx,sy
      float cx=sx, cy=sy; 
      float pdsum=0.0;
      float ray_length = min_search_radius+random(max_search_radius-min_search_radius);  
      float ray_angle = sa - (density_search_angle/2.0)+random(density_search_angle);

      for (int s=0; s<NUM_SAMPLES; s++) {
        cx+=ray_length/NUM_SAMPLES*cos(ray_angle);
        cy+=ray_length/NUM_SAMPLES*-sin(ray_angle);
        float dx=cx-sx, dy=cy-sy;
        // sum up pd from this sample weighted by distance from start point
        if ( cx<border || cy <border || cx >=width-border || cy>=height-border) pdsum -=100000.0; 
        else pdsum+=population_density[(int)cx+(int)cy*width]/(sqrt(dx*dx+dy*dy));
      }

      if ( pdsum > current_best ) {
        cbx=cx; 
        cby=cy; 
        current_best = pdsum; 
        cb_angle=ray_angle; 
        cb_distance=ray_length;
      }
    }

    result.angle = cb_angle; 
    result.distance = cb_distance;
    return result;
  }
  
  void checkLocalConstraints(LInsertionQueryModule q, float proposed_start_x, float proposed_start_y, float turtle_angle ) {
    q.state = -1; // SUCCEED; -1 = FAILED, 1 = UNASSIGNED
    int count=2;
    LRoadAttr tmp = q.road_attr;
    
    while( q.state==-1 && count-- > 0 ) {
      tmp = q.road_attr;
      tmp.angle+=(random(PI/2.0)-PI/4.0);
      tmp.distance+=(random(0.025*tmp.distance)-0.0125);
      q.state = test_proposed_road( proposed_start_x, proposed_start_y, tmp, turtle_angle );
    }
  }
  
  int test_proposed_road( float sx, float sy, LRoadAttr ra, float turtle_angle ) {
    
    if( random(1.0) < fudge_factor ) return -1;
    if(ra.angle>0) {
      if(ra.angle>PI/2.0*1.2) return -1; //ra.angle=PI/2.0*1.2;
      //if(ra.angle<PI/2.0*0.8) ra.angle=PI/2.0*0.8;
    }
    if(random(1.0) > population_density[(int)sx+(int)sy*width]) return -1;
    else {
      if(ra.angle<PI/2.0*-1.2) return -1; //ra.angle=PI/2.0*01.2;
      //if(ra.angle>PI/2.0*-0.8) ra.angle=PI/2.0*-0.8;
    }
    float gap_size=0.1;
    turtle_angle += ra.angle;
    float gapx=gap_size*cos(turtle_angle);
    float gapy=gap_size*-sin(turtle_angle);
    
    float dx=ra.distance*cos(turtle_angle)-gapx;
    float dy=ra.distance*-sin(turtle_angle)-gapy;
    float endx=dx+sx;
    float endy=dy+sy;
    if( roads.crosses_road(sx+gapx, sy+gapy, endx,endy) ) {
      return -1;
    }
    if( endx < border || endx >width-border || sx<border||sx>width-border) return -1;
    if( endy < border || endy >height-border || sy<border||sy>height-border) return -1;
    
    return 0;
  }
}

