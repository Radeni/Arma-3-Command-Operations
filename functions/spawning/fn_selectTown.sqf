_locations = nearestLocations [(getMarkerPos "base_radius"), ["NameCity","NameCityCapital", "NameVillage"], 30000];
_town = selectRandom _locations;
_townPos = locationPosition _town;
while {_townPos distance2D markerPos "base_radius" < 2000} do
{
	_town = selectRandom _locations;
	_townPos = locationPosition _town
};
_town;
