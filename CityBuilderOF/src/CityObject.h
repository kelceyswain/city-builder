#ifndef CITYOBJECT__H
#define CITYOBJECT__H

#include "ofMain.h"
#include "ofxOsc.h"

class CityObject {

	public:

	ofBoxPrimitive myOfBox;
	ofxOscSender oscSender;

    int block_width = 100;

    int x, y;
    int xpos, ypos, zpos;

	int height;
	int max_height;
	int width;
	int depth;

	int xoffset=-400, yoffset=-400, zoffset = -300;

	int zunit=15;
	int num_blocks=0;

	ofMaterial myMaterial;

	CityObject(int a, int b);

	~CityObject();

	void grow();

	void draw();

};

#endif
