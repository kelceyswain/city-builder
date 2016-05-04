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

    cam.orbit(angleH, angleV, distance);
    cam.roll(roll);

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
    		blocks[i][j].set(zunit, xwidth, ywidth );
    	}
    }
}

//--------------------------------------------------------------
void ofApp::update(){

	float lb;
	roll += 0.0f;
	angleV += 0.1f;
	angleH += 0.f;
	if (angleV > 360.f) angleV = 0.;
	if (angleH > 360.f) angleH = 0.;
    cam.orbit(angleH, angleV, distance);
    cam.roll(roll);

    if (bgc == 1000)
	{
		bgc = 0;
	}

	lb = sin(((float)bgc*2*PI)/1000.0);
	lb = (lb * 0.5) + 0.5;
	bg = (int)(lb * 255);

    pointLight.setPosition(800*cos((float)bgc*PI*0.002), 50 * sin((float)bgc*PI*0.002), 800*sin((float)bgc*PI*0.002));
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
			int x = blocks[i][j].getWidth();
			if (ofRandom(0.0, 1.0) > 0.999)
			{
				x += zunit;
			}
			if(x > (10*zunit)) x = zunit;
			// blocks[i][j].setPosition(ofRandom(0,1)*ofGetWidth(),ofRandom(0,1)*ofGetHeight(), 0);
			blocks[i][j].setPosition(300-(int)((float)x/2.0), i*xwidth+(int)xoffset, j*ywidth+(int)yoffset);
			blocks[i][j].set(x, xwidth, ywidth );

    		material.begin();
    		ofFill();
    		ofEnableAlphaBlending();
    		// ofSetColor(40,40,40,10);

    		blocks[i][j].setScale(0.95f);
    		blocks[i][j].draw();
    		ofDisableAlphaBlending(); 
    		material.end();

    		ofNoFill();
    		ofSetColor(200);
    		blocks[i][j].drawWireframe();
    		blocks[i][j].setScale(1.f);
		}
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
