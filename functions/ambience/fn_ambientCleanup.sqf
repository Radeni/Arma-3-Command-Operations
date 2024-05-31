params ["_unit","_object"];


_groupPos = getPosATL _unit;
_group = group _unit;
waitUntil {(_groupPos distance2D ([_groupPos] call CO_fnc_nearestPlayer)) > 1500 or isNull _group or !alive _object or isNull _object};
if (isNull _group) exitWith {[_object,true] spawn CO_fnc_ambientUnits;};
if (count units _group > 0) then {
{
  if (!isNil "_x") then {
    private _vehicle = _x;
    {_vehicle deleteVehicleCrew _x } forEach (crew _vehicle);
	sleep 0.05;
};
} forEach units _group;{deleteVehicle _x} forEach units _group;};

if (_object getVariable ["hasDied",false] or (COAllowAmbience == false)) exitWith {};
[_object,true] spawn CO_fnc_ambientUnits;