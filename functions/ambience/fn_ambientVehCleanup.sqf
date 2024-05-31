params ["_unit","_allUnits","_object"];


_groupPos = getPosATL _unit;
_group = group _unit;
waitUntil {(_groupPos distance2D ([_groupPos] call CO_fnc_nearestPlayer)) > 1700 or isNull _group or !alive _object or isNull _object};
if (isNull _group) exitWith {[_object,true] spawn CO_fnc_ambientVehicles;};
if (count _allUnits > 0) then {
	{
	[250,_x] spawn CO_fnc_objectSafeCleanup;
	} forEach _allUnits;
};

if (_object getVariable ["hasDied",false] or (COAllowAmbience == false)) exitWith {};
[_object,true] spawn CO_fnc_ambientVehicles;