#ifndef CITYOBJECT__H
#define CITYOBJECT__H

#include "ofMain.h"

class CityObject {
	
	public:

	ofBoxPrimitive myOfBox;

    int block_width = 100;

    int x, y;
    int xpos, ypos, zpos;

	int height;
	int width;
	int depth;

	int xoffset=-500, yoffset=-500, zoffset = -300;

	int zunit=25;
	int num_blocks=0;
	
	ofMaterial myMaterial;

	CityObject(int a, int b);

	~CityObject();

	void grow();

	void draw();

};

#endif
