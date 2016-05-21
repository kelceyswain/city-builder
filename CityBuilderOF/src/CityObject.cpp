#include "CityObject.h"

#include "ofMain.h"

CityObject::CityObject(int a, int b) {

	x = a; y = b;

	width = block_width;
	depth = block_width;
	height = zunit;

	xpos = xoffset + x*block_width;
	ypos = yoffset + y*block_width;
	//zpos = zoffset + (int)((float)height/2.0);
	zpos = zoffset + height/2;

	myOfBox.set(width,depth,height);
	myOfBox.setPosition(xpos,ypos,zpos);

    ofLog(OF_LOG_NOTICE, "x: %d, y: %d, xpos: %d, ypos: %d, zpos: %d", x, y, xpos, ypos, zpos);

    myMaterial.setShininess( 120 );
    // the light highlight of the material //
    myMaterial.setDiffuseColor(ofColor(255, 255, 255,120));
    myMaterial.setSpecularColor(ofColor(255, 255, 255, 120));

}

CityObject::~CityObject() {
	
}

void CityObject::grow() {

	height += zunit;
	xpos = xoffset + x*block_width;
	ypos = yoffset + y*block_width;
	zpos = zoffset + height/2;

	myOfBox.set(width,depth,height);
	myOfBox.setPosition(xpos,ypos,zpos);

	num_blocks++;
}

void CityObject::draw() {

	myMaterial.begin();
	ofFill();
	ofEnableAlphaBlending();
	// ofSetColor(40,40,40,10);

	myOfBox.setScale(0.95f);
	myOfBox.draw();
	ofDisableAlphaBlending(); 
	myMaterial.end();

	ofNoFill();
	ofSetColor(200);
	myOfBox.drawWireframe();
	myOfBox.setScale(1.f);
}