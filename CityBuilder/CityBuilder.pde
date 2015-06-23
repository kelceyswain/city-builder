import blobDetection.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;
int broadcastPort = 12000;

// number of contours
int levels = 10;
PImage img;

final int W=1024;
final int H=768;

float[] populationDensityMap;

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
    makeContours(levels);

    l = new LSystem(populationDensityMap);
    
    perspective();

    // OSCsetup
    oscP5 = new OscP5(this, broadcastPort);
    remoteLocation = new NetAddress("127.0.0.1", broadcastPort);
    
}

void draw()
{
    clear();
    //drawPopulationDensityMap();
    background(1.0, 1.0, 0.95);  
    
    for (int i=0 ; i<levels ; i++) {
        //translate(0,0,10/levels);  
        drawContours(i);
    }
    l.update_branches();
    l.draw_roads();
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
            img.loadPixels();
            img.pixels[x+y*W] = color((bright*bright));
            img.updatePixels();
            populationDensityMap[x+y*W] *= 2;
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

void oscEvent(OscMessage theOscMessage) {
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}
