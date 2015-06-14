import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import blobDetection.*;

// Settings
boolean draw_terrain_map = false;
boolean draw_road_map = true;
boolean draw_contours = true;
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
  //noSmooth();  
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
  noStroke();
  int stepSize=4;
  int x1,y1,x2,y2,x3,y3,x4,y4;
  float z1,z2,z3,z4;
  
  for(y1=0;y1<height-stepSize;y1+=stepSize) {
    beginShape(TRIANGLE_STRIP);
    for(x1=0;x1<width-stepSize;x1+=stepSize) {
      //draw two triangles
      x2=x1+stepSize; x3=x1;          x4=x1+stepSize;
      y2=y1;          y3=y1+stepSize; y4=y1+stepSize;
      z1=terrainMap[y1*width+x1];
      z2=terrainMap[y2*width+x2];
      z3=terrainMap[y3*width+x3];
      z4=terrainMap[y4*width+x4];
      
       
//      
        float b=z1/landscape_height_scale;
        
//if(b<.2) fill(color(0,0,0.6));
       //else
       fill(color(0.1,0.1+b,0.1));         
        vertex(x1,y1,z1);
       // vertex(x2,y2,z2);
//        vertex(x4,y4,z4);
      b=z3/landscape_height_scale;
      //if(b<.2) fill(color(0,0,0.6));
       //else
       fill(color(0.1,0.1+b,0.1));
        vertex(x3,y3,z3);

//     beginShape();
//       vertex(x3,y3,z3);
//       vertex(x2,y2,z2);
//       
//     endShape();
     
    }
    endShape();
  }
//  
//  int x,y;
//  for( y=0;y<height; y+=stepSize) {
//    for(x=0;x<width;x+=stepSize){
//      float val=terrainMap[y*width+x];
//      float b=val/landscape_height_scale;
//      if(val<20.0) stroke(color(0,0,0.6));
//       else stroke(color(0.1,0.1+b,0.1));      
//      point(x,y,val);
//      
//    }
//  }
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
            img.pixels[x+y*W] = color(bright*g(x,y));
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



