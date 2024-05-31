params ["_position","_minDistance","_objects","_markers"];

waitUntil {_position distance2D ([_position] call CO_fnc_nearestPlayer) > _minDistance;};


if (count _objects > 0) then {
	{
	  [250,_x] spawn CO_fnc_objectSafeCleanup;
	} forEach _objects;
};
if (count _markers > 0) then {{deleteMarker _x} forEach _markers;};
true;