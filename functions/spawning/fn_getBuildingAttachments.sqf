params ["_building","_radius"];

_objects = _building nearObjects _radius;
_allObjects = [];
{
	_type = typeOf _x;
	_relPos = _building worldToModel getPosATL _x;
	_relDir = (getDir _x) - (getDir _building);
	_damage = isDamageAllowed _x;
	if (typeOf _x != typeOf _building) then
	{
		_allObjects = _allObjects + [[_type,_relPos,_relDir,_damage]];
	}; 
} forEach _objects;

_allObjects
