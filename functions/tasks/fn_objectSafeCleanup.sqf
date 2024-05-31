params ["_minDistance","_object"];

waitUntil {(getPos _object) distance2D ([(getPos _object)] call CO_fnc_nearestPlayer) > _minDistance or isNil '_object'};

if (isNil '_object') exitWith {systemChat "Object was nil, exiting safe cleanup"};

{_object deleteVehicleCrew _x; sleep 0.01} forEach (crew _object);

sleep 0.01;

deleteVehicle _object;

true;