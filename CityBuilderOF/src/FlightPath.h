#include "CityObject.h"

class FlightPath {
	
	public:

	CityObject* start;
	CityObject* end;

	int startx, starty;
	int endx, endy;
	int time;

	FlightPath( CityObject* s, CityObject* e, int time );
	~FlightPath();

	void draw();
	void update();

};