final int W=1024;
final int H=768;

float[] populationDensityMap;

RoadMap rm;
LSystem l;
void setup()
{
  size(W, H, P3D);
  frameRate(20.0);
  colorMode(RGB, 1);
  color(1.0, 1.0, 0.0); 
  fill(1.0, 1.0, 0.0); 
  stroke(1.0, 1.0, 0.0);

  createPopulationDensityMap();

  l = new LSystem(populationDensityMap);
}

void draw()
{
  clear();
  drawPopulationDensityMap();

  l.update_branches();
  l.draw_roads();
}

float g(float x, float y) {
  float A=1.0;
  float sigx=100;
  float sigy=100;
  float x0=width/2;
  float y0=height/2;
  return A*exp( -( (((x-x0)*(x-x0))/(2*sigx*sigx)) + (((y-y0)*(y-y0))/(2*sigy*sigy)) ) );
}
void createPopulationDensityMap()
{

  /* This one is a gaussian around the centre of the window */
  populationDensityMap=new float[W*H];
  float xoff=0.0;
  for ( int x=0; x<W; x++) {
    float yoff=0.0;
    for (int y=0; y<H; y++) {
      
      /* Gaussian */
      populationDensityMap[x+y*W]=g(x, y);
      
      /* OR: */
      /* Perlin noise */
      float bright = noise(xoff, yoff);
     // populationDensityMap[x+y*W]=bright;
      yoff+=0.01;
    }
    xoff+=0.01;
  }
}

  void drawPopulationDensityMap()
  {
    loadPixels();
    for (int p=0; p<W*H; p++ ) pixels[p]=color(populationDensityMap[p]);
    updatePixels();
  }

