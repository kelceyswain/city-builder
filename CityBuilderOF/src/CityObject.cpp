#include "CityObject.h"

#include "ofMain.h"

CityObject::CityObject(int a, int b) {

	x = a; y = b;

	width = block_width;
	depth = block_width;
	height = zunit;
	max_height = 700;

	xpos = xoffset + x*block_width;
	ypos = yoffset + y*block_width;
	zpos = zoffset + height/2;

	myOfBox.set(width,depth,height);
	myOfBox.setPosition(xpos,ypos,zpos);

    // ofLog(OF_LOG_NOTICE, "x: %d, y: %d, xpos: %d, ypos: %d, zpos: %d", x, y, xpos, ypos, zpos);

    myMaterial.setShininess( 120 );
    // the light highlight of the material //
    myMaterial.setDiffuseColor(ofColor(255, 255, 255,120));
    myMaterial.setSpecularColor(ofColor(255, 255, 255, 120));

	oscSender.setup("localhost", 57120);

}

CityObject::~CityObject() {

}

void CityObject::grow() {
	if (height + zunit >= max_height)
	{
		height = 0;
	}
	height += zunit;
	xpos = xoffset + x*block_width;
	ypos = yoffset + y*block_width;
	zpos = zoffset + height/2;

	myOfBox.set(width,depth,height);
	myOfBox.setPosition(xpos,ypos,zpos);
	myMaterial.setDiffuseColor(ofColor(ofRandom(0, 255), ofRandom(0, 255), ofRandom(0, 255),120));

	// ofxOscMessage m;
 //    m.setAddress( "/blocks" );
 //    m.addIntArg( x );
	// m.addIntArg( y );
	// m.addIntArg( height );
 //    oscSender.sendMessage( m );

	num_blocks++;
}

void CityObject::draw() {

	ofColor block_color, add_color;
	myMaterial.begin();
	block_color = myMaterial.getDiffuseColor();
	add_color = ofColor(1, 1, 1, 0);
	
	if (block_color != ofColor(255, 255, 255, 120))
	{
		block_color += add_color;
		myMaterial.setDiffuseColor(block_color);
	}

	ofFill();
	ofEnableAlphaBlending();

	myOfBox.setScale(0.95f);
	myOfBox.draw();
	ofDisableAlphaBlending();
	myMaterial.end();

	ofNoFill();
	ofSetColor(200);
	myOfBox.drawWireframe();
	myOfBox.setScale(1.f);
}
