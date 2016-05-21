#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){

    ofSetVerticalSync(true);
    ofSetFrameRate(60);
    
    bg = 0;
    bgc = 0;

    xblocks = 10;
    yblocks = 10;
    xwidth = 100;
    ywidth = 100;
    zunit = 25;

	cam.setFov(60);
	cam.setNearClip(1);
	cam.setFarClip(5000);
  	    
  	ofDisableArbTex();

    bOrbit = bRoll = false;
  	angleH = 0.f;
  	angleV = 0.f;
  	roll = 90.f;
    distance = 1000.f;
    pointLight.enable();

    float camx=-500;
    float camy=-500;
    float camz=120;

    cam.setPosition(camx,camy,camz);
    cam.lookAt(ofVec3f(0,0,0), ofVec3f(0,0,1));
    //cam.orbit(angleH, angleV, distance);
    //cam.roll(roll);

    pointLight.setDiffuseColor( ofFloatColor(0.75,0.7,0.6) );
    pointLight.setSpecularColor( ofFloatColor(0.52,0.53,0.5) );

    material.setShininess( 120 );
    // the light highlight of the material //
    material.setDiffuseColor(ofColor(255, 255, 255,120));
    material.setSpecularColor(ofColor(255, 255, 255, 120));
    
    ofBackground(bg);
    for (int i = 0; i < xblocks; i++)
    {
    	for (int j = 0; j < yblocks; j++)
    	{
    		//blocks[i][j].set(zunit, xwidth, ywidth );
            blocks[i][j] = new CityObject(i,j);
    	}
    }
}

//--------------------------------------------------------------
void ofApp::update(){

	float lb, w, x1, x2, y1, y2;

    int rx, ry;

    int day;

    day = 100;
	roll += 0.0f;
	angleV += 0.1f;
	angleH += 0.f;
	if (angleV > 360.f) angleV = 0.;
	if (angleH > 360.f) angleH = 0.;
    //cam.orbit(angleH, angleV, distance);
  //  cam.roll(roll);
    float camx=cos(angleV)*distance;
    float camy=-sin(angleV)*distance;
    float camz=120.0;
    cam.setPosition(camx,camy,camz);
    cam.lookAt(ofVec3f(0,0,0), ofVec3f(0,0,1));


    if (bgc == day)
	{
        
		bgc = 0; currentDay++;

        do {
            x1 = 2.0 * ofRandom(0.f, 1.f) - 1.0;
            x2 = 2.0 * ofRandom(0.f, 1.f) - 1.0;
            w = x1 * x1 + x2 * x2;
        } while (w >= 1.0);

        w = sqrt( (-2.0 * log(w) ) / w);
        y1 = x1 * w;
        y2 = x2 * w;

        // ofLog(OF_LOG_NOTICE, "%f, %f", y1, y2);

        rx = (int)round(y1 * ((float)xblocks*0.1) + ((float)xblocks*0.5));
        ry = (int)round(y2 * ((float)yblocks*0.1) + ((float)yblocks*0.5));

        // ofLog(OF_LOG_NOTICE, "rx: %d \t ry: %d\n", rx, ry); 

        if (rx >= 0 && rx < xblocks && ry >= 0 && ry < yblocks)
        {
            //blocks[rx][ry].setWidth(blocks[rx][ry].getWidth()+zunit);
            blocks[rx][ry]->grow();
        }

        for (vector<FlightPath*>::iterator it = fps.begin() ; it != fps.end(); ++it) {
            delete (*it);
        }

        fps.clear();

        for(int x=0;x<xblocks;x++){
            for(int y=0; y<yblocks;y++) {
                for( int block=0;block<blocks[x][y]->num_blocks; block++ ) {
                    int ex = (int)(ofRandom(0.f,10.f)); int ey=(int)(ofRandom(0.f,10.f));

                    fps.push_back(new FlightPath(blocks[x][y], blocks[ex][ey], 25));
                }
            }
        }

	}

    for (vector<FlightPath*>::iterator it = fps.begin() ; it != fps.end(); ++it) {
        (*it)->update();
    }
    

	lb = sin(((float)bgc*2*PI)/(float)(day));
	lb = (lb * 0.5) + 0.5;
	bg = (int)(lb * 255);

    pointLight.setPosition(800*cos(2*PI*(float)bgc/(float)day), 400*sin(2*PI*(float)bgc/(float)day), 800*sin(2*PI*(float)bgc/(float)day));
	pointLight.setDiffuseColor( ofFloatColor(0.75) );
    pointLight.setSpecularColor( ofFloatColor(0.75) );

	bgc++;
}

//--------------------------------------------------------------
void ofApp::draw(){
	cam.begin();
	ofEnableDepthTest();
	ofEnableLighting();

	// ofBackground(bg);
	ofBackground(0);

	int xtotal;
	int ytotal;
	float xoffset;
	float yoffset;

	xtotal = xblocks * xwidth;
	ytotal = yblocks * ywidth;
	// xoffset = ((float)ofGetWidth()/2.0) - ((float)xtotal/2.0);
	// yoffset = ((float)ofGetHeight()/2.0) - ((float)ytotal/2.0);
	xoffset = (float)xtotal / -2.0;
	yoffset = (float)ytotal / -2.0;

	for (int i = 0; i < xblocks; i++)
	{
		for (int j = 0; j < yblocks; j++)
		{
			// int x = blocks[i][j].getWidth();

			// blocks[i][j].setPosition(300-(int)((float)x/2.0), i*xwidth+(int)xoffset, j*ywidth+(int)yoffset);

    		// material.begin();
    		// ofFill();
    		// ofEnableAlphaBlending();
    		// // ofSetColor(40,40,40,10);

    		// blocks[i][j].setScale(0.95f);
    		// blocks[i][j].draw();
    		// ofDisableAlphaBlending(); 
    		// material.end();

    		// ofNoFill();
    		// ofSetColor(200);
    		// blocks[i][j].drawWireframe();
    		// blocks[i][j].setScale(1.f);
            blocks[i][j]->draw();

		}
	}
    for (vector<FlightPath*>::iterator it = fps.begin() ; it != fps.end(); ++it) {
        (*it)->draw();
    }
    // box.setPosition(ofGetWidth() * 0.5, ofGetHeight() * 0.5, 0);
    // box.rotate(1, 1.0, 0.0, 0.0);
    // box.rotate(-1, 0.0, 1.0, 0.0);
    ofDisableLighting();
    ofDisableDepthTest();
	cam.end();

}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){

}
