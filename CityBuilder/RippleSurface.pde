public class RippleSurface {

  float buffer1[][];
  float buffer2[][];
PImage b1, b2;

  float damping = 0.9999;

  public RippleSurface() {
    buffer1 = new float[W][H];
    buffer2 = new float[W][H];
b1=createImage(W,H,RGB);
b2=createImage(W,H,RGB);
  
    for ( int a=1; a<W-1; a++ ) {
      for ( int b=1; b<H-1; b++ ) {
        buffer1[a][b]=buffer2[a][b]=0;
      }
    }
  }

  public void disturb( int x, int y ) {
    buffer1[x][y] = 1.0;
    //b1.loadPixels();
    b1.set(x,y, color(1,1,1));
    
  }

  public void update() {
    float btemp[][] = buffer2;
    PImage ptmp=b2;
    
    buffer2=buffer1;
    buffer1=btemp;

    b2=b1;
    b1=ptmp;

    for ( int a=1; a<W-1; a++ ) {
      for ( int b=1; b<H-1; b++ ) {
        buffer2[a][b]=(buffer1[a-1][b]+buffer1[a+1][b]+buffer1[a][b-1]+buffer1[a][b+1]) / 2 - buffer2[a][b];
        buffer2[a][b] *= damping;
        
        
      }
    }
  }

  public void draw_surface() {
    loadPixels();

    for ( int a=1; a<W-1; a++ ) {
      for ( int b=1; b<H-1; b++ ) {
        color pc=pixels[b*W+a];
        float xo=buffer2[a-1][b] - buffer2[a+1][b];
        float yo=buffer2[a][b-1] - buffer2[a][b+1];
        float shading=xo;
        color t=pixels[(b+(int)yo)*W+(a+(int)xo)];
        float re=red(t); float gr=green(t); float bl=blue(t);
        //pixels[b*W+a]=t+color(xo,xo,xo);
        //set(a,b,t+color(xo,xo,xo));
        float effect=(xo+1);
        pixels[b*W+a]=color(effect*re,effect*gr,effect*bl);
      }
    }
    updatePixels();
  }
}

