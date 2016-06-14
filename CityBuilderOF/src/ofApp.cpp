#include "ofApp.h"

int boxID(int x, int y)
{
    if (y == 0)
    {
        if ( x == 0 ) return 72;
        else if (x == 1) return 73;
        else if (x == 2) return 74;
        else if (x == 3) return 75;
        else if (x == 4) return 76;
        else if (x == 5) return 77;
        else if (x == 6) return 78;
        else if (x == 7) return 79;
        else if (x == 8) return 80;
    }

    else if (y == 1)
    {
        if (x == 0) return 71;
        else if (x == 1) return 42;
        else if (x == 2) return 43;
        else if (x == 3) return 44;
        else if (x == 4) return 45;
        else if (x == 5) return 46;
        else if (x == 6) return 47;
        else if (x == 7) return 48;
        else if (x == 8) return 49;
    }
    
    else if (y == 2)
    {
        if (x == 0) return 70;
        else if (x == 1) return 41;
        else if (x == 2) return 20;
        else if (x == 3) return 21;
        else if (x == 4) return 22;
        else if (x == 5) return 23;
        else if (x == 6) return 24;
        else if (x == 7) return 25;
        else if (x == 8) return 50;
    }
    
    else if (y == 3)
    {
        if (x == 0) return 69;
        else if (x == 1) return 40;
        else if (x == 2) return 19;
        else if (x == 3) return 6;
        else if (x == 4) return 7;
        else if (x == 5) return 8;
        else if (x == 6) return 9;
        else if (x == 7) return 26;
        else if (x == 8) return 51;
    }

    else if (y == 4)
    {
        if (x == 0) return 68;
        else if (x == 1) return 39;
        else if (x == 2) return 18;
        else if (x == 3) return 5;
        else if (x == 4) return 0;
        else if (x == 5) return 1;
        else if (x == 6) return 10;
        else if (x == 7) return 27;
        else if (x == 8) return 52;
    }

    else if (y == 5)
    {
        if (x == 0) return 67;
        else if (x == 1) return 38;
        else if (x == 2) return 17;
        else if (x == 3) return 4;
        else if (x == 4) return 3;
        else if (x == 5) return 2;
        else if (x == 6) return 11;
        else if (x == 7) return 28;
        else if (x == 8) return 53;
    }

    else if (y == 6)
    {
        if (x == 0) return 66;
        else if (x == 1) return 37;
        else if (x == 2) return 16;
        else if (x == 3) return 15;
        else if (x == 4) return 14;
        else if (x == 5) return 13;
        else if (x == 6) return 12;
        else if (x == 7) return 29;
        else if (x == 8) return 54;
    }

    else if (y == 7)
    {    
        if (x == 0) return 65;
        else if (x == 1) return 36;
        else if (x == 2) return 35;
        else if (x == 3) return 34;
        else if (x == 4) return 33;
        else if (x == 5) return 32;
        else if (x == 6) return 31;
        else if (x == 7) return 30;
        else if (x == 8) return 55;
    }

    else if (y == 8)
    {
        if (x == 0) return 64;
        else if (x == 1) return 63;
        else if (x == 2) return 62;
        else if (x == 3) return 61;
        else if (x == 4) return 60;
        else if (x == 5) return 59;
        else if (x == 6) return 58;
        else if (x == 7) return 57;
        else if (x == 8) return 56;
    }

    else return 100;
}

//--------------------------------------------------------------
void ofApp::setup(){

    ofSetVerticalSync(true);
    ofSetFrameRate(60);

    oscSender.setup("localhost", 57120);

    bg = 0;
    bgc = 0;

    xblocks = 9;
    yblocks = 9;
    xwidth = 100;
    ywidth = 100;
    zunit = 15;

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
    softLight.enable();

    float camx=-400;
    float camy=-400;
    float camz=120;

    cam.setPosition(camx,camy,camz);
    cam.lookAt(ofVec3f(0,0,0), ofVec3f(0,0,1));

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
    // float day_div = 10000.f;
    float day_div = 5000.f;
    float dur;
    int ldlen = 1000;

    // int day;

    // Write an OSC message
    ofxOscMessage m;
    m.setAddress( "/day" );
    m.addIntArg( bgc );
    oscSender.sendMessage( m );
    // OSC done

    //day = 600;
	roll += 0.0f;
	// angleV += 0.002f;
    angleV += 0.5/(float)day;
	angleH += 0.f;
	if (angleV > 2 * PI) angleV = 0.;
	if (angleH > 2 * PI) angleH = 0.;

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

        rx = (int)round(y1 * ((float)xblocks*0.2) + ((float)xblocks*0.5) - 0.5);
        ry = (int)round(y2 * ((float)yblocks*0.2) + ((float)yblocks*0.5) - 0.5);

        if (rx >= 0 && rx < xblocks && ry >= 0 && ry < yblocks)
        {
            blocks[rx][ry]->grow();
            day = (int) (day_div/ (float)blocks[rx][ry]->height);
            // OSC
            ofxOscMessage m;
            m.setAddress( "/blocks" + std::to_string(boxID(rx, ry)) );
            m.addIntArg( rx );
            m.addIntArg( ry );
            dur = day_div / 60.f;
            m.addFloatArg(( dur / (float)(blocks[rx][ry]->height)));
            // m.addIntArg(boxID(rx, ry));
            oscSender.sendMessage( m );
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

    // box.setPosition(800*sin(2*PI*(float)bgc/(float)day), 200*cos(2*PI*(float)bgc/(float)day), 800*-cos(2*PI*(float)bgc/(float)day));
    // pointLight.setPosition(800*sin(*PI*(float)bgc/(float)day), 200*cos(2*PI*(float)bgc/(float)day), 800*-cos(2*PI*(float)bgc/(float)day));
    // softLight.setPosition(800*sin(2*PI*(float)bgc/(float)day), 200*cos(2*PI*(float)bgc/(float)day), 800*cos(2*PI*(float)bgc/(float)day));

    pointLight.setPosition(800*sin(2*PI*(float)lday/(float)ldlen), 200*cos(2*PI*(float)lday/(float)ldlen), 800*-cos(2*PI*(float)lday/(float)ldlen));
    softLight.setPosition(800*sin(2*PI*(float)lday/(float)ldlen), 200*cos(2*PI*(float)lday/(float)ldlen), 800*cos(2*PI*(float)lday/(float)ldlen));

    lday++;
    if (lday >= ldlen) lday = 1;

    pointLight.setDiffuseColor( ofFloatColor(0.75) );
    pointLight.setSpecularColor( ofFloatColor(0.75) );

    softLight.setDiffuseColor( ofFloatColor(0.2, 0.25, 0.25) );
    softLight.setSpecularColor( ofFloatColor(0.2, 0.25, 0.25) );

	bgc++;
}

//--------------------------------------------------------------
void ofApp::draw(){
	cam.begin();
	ofEnableDepthTest();
	ofEnableLighting();

	ofBackground(0);

	for (int i = 0; i < xblocks; i++)
	{
		for (int j = 0; j < yblocks; j++)
		{
            blocks[i][j]->draw();
        }
	}
    for (vector<FlightPath*>::iterator it = fps.begin() ; it != fps.end(); ++it) {
        (*it)->draw();
    }
    // box.draw();
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
