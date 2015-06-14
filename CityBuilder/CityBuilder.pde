import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import blobDetection.*;

// Settings
boolean draw_terrain_map = false;
boolean draw_road_map = true;
boolean draw_contours = false;
boolean draw_branches = false;
boolean draw_terrain = true;

// number of contours
int levels = 14;
PImage img;

PeasyCam cam;
float factor=1.0;

float landscape_height_scale = 100.0;

final int W=1024;
final int H=768;

float[] populationDensityMap;
float[] terrainMap;

// Array of BlobDetection Instances for contours
BlobDetection[] theBlobDetection = new BlobDetection[int(levels)];

RoadMap rm;
LSystem l;
void setup()
{
  
    size(W, H, P3D);
    frameRate(24.0);
    colorMode(RGB, 1);
    color(1.0, 1.0, 0.0); 
    fill(1.0, 1.0, 0.0); 
    stroke(1.0, 1.0, 0.0);
    createPopulationDensityMap();
    createTerrainMap();
    makeContours(levels);

    l = new LSystem(populationDensityMap, terrainMap);
    cam = new PeasyCam(this,200);
   // perspective();
  noSmooth();  
}

void draw()
{
    clear();
    //drawPopulationDensityMap();
    background(1.0, 1.0, 0.95);  
    
    translate(-width*factor/2,-height*factor/2);
    if(draw_terrain_map) image(img,0,0);
    if(draw_contours){
      pushMatrix();
      for (int i=0 ; i<levels ; i++) {
          translate(0,0,landscape_height_scale/(float)levels);  
          drawContours(i);
      }
    popMatrix();
    }
    
    l.update_branches(draw_branches);
    if(draw_terrain) draw_terrain();
    if(draw_branches) l.draw_branches();
    if(draw_road_map) l.draw_roads();
}

void draw_terrain()
{
  int x,y;
  for( y=0;y<height; y+=4) {
    for(x=0;x<width;x+=4){
      float val=terrainMap[y*width+x];
      float b=val/landscape_height_scale;
      stroke(color(b,b,b));      
      point(x,y,val);
      
    }
  }
}

float g(float x, float y) {
    float A=1.0;
    float sigx=250;
    float sigy=250;
    float x0=width/2;
    float y0=height/2;
    return A*exp( -( (((x-x0)*(x-x0))/(2*sigx*sigx)) + (((y-y0)*(y-y0))/(2*sigy*sigy)) ) );
}
void createPopulationDensityMap()
{

    /* This one is a gaussian around the centre of the window */
    populationDensityMap=new float[W*H];
    float xoff=0.0;
    img = createImage(W, H, RGB);
    for ( int x=0; x<W; x++) {
        float yoff=0.0;
        for (int y=0; y<H; y++) {

            /* Gaussian */
            //populationDensityMap[x+y*W]=g(x, y);

            /* OR: */
            /* Perlin noise */
            float bright = noise(xoff, yoff);
            populationDensityMap[x+y*W]=bright;
            populationDensityMap[x+y*W] *= g(x, y);
//            img.loadPixels();
//            img.pixels[x+y*W] = color((bright*bright));
//            img.updatePixels();
            populationDensityMap[x+y*W] *= 2;
            yoff+=0.005;
        }
        xoff+=0.005;
    }
}
void createTerrainMap()
{

    /* This one is a gaussian around the centre of the window */
    terrainMap=new float[W*H];
    float xoff=0.0;
    img = createImage(W, H, RGB);
    for ( int x=0; x<W; x++) {
        float yoff=0.0;
        for (int y=0; y<H; y++) {

            /* Gaussian */
            //populationDensityMap[x+y*W]=g(x, y);

            /* OR: */
            /* Perlin noise */
            float bright = noise(xoff, yoff);
            terrainMap[x+y*W]=bright * landscape_height_scale;
            terrainMap[x+y*W] *= g(x, y);
            img.loadPixels();
            img.pixels[x+y*W] = color((bright*bright));
            img.updatePixels();
            //terrainMap[x+y*W] *= 20;
            yoff+=0.005;
        }
        xoff+=0.005;
    }
}
void makeContours(int lev) {
    for (int i=0;  i<lev ; i++) {
        theBlobDetection[i] = new BlobDetection(img.width, img.height);
        theBlobDetection[i].setThreshold(i/(float)lev);
        theBlobDetection[i].computeBlobs(img.pixels);
    }
}

void drawContours(int i) {
    Blob b;
    EdgeVertex eA,eB;
	//image(img, 0, 0);
    for (int n=0 ; n<theBlobDetection[i].getBlobNb(); n++) {
        b=theBlobDetection[i].getBlob(n);
        if (b!=null) {
            strokeWeight(1.0);
            strokeCap(ROUND);
            stroke(0.85, 0.85, 0.75);      // coloring the contours
            for (int m=0;m<b.getEdgeNb();m++) {
                eA = b.getEdgeVertexA(m);
                eB = b.getEdgeVertexB(m);
                if (eA !=null && eB !=null) {
                    line(eA.x*W, eA.y*H, eB.x*W, eB.y*H);

                }
            }
        }
    }
}


void drawPopulationDensityMap()
{
    loadPixels();
    for (int p=0; p<W*H; p++ ) pixels[p]=color(populationDensityMap[p]);
    updatePixels();
}



