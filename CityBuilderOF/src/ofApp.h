#pragma once

#include "ofMain.h"
#include "CityObject.h"
#include "FlightPath.h"
#include "ofxOsc.h"

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void mouseEntered(int x, int y);
		void mouseExited(int x, int y);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);

		int xblocks;
		int yblocks;
		int xwidth;
		int ywidth;
		int zunit;
		int day = 1;
		int lday = 1;

		ofCamera cam;
		float angle;
    	bool bOrbit, bRoll;
    	float angleH, angleV, roll, distance;

	    CityObject* blocks[16][16];

		ofBoxPrimitive box;
		int bg;
		int bgc;

		ofLight pointLight;
		ofLight softLight;
		ofMaterial material;

		ofVboMesh boxSides[ofBoxPrimitive::SIDES_TOTAL];
    	ofVboMesh deformPlane;
    	ofVboMesh topCap, bottomCap, body;
    	vector<ofMeshFace> triangles;

    	vector<FlightPath*> fps;
    	int currentDay = 0;

		ofxOscSender oscSender;

};
