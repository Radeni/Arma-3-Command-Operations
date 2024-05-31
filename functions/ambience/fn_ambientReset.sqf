
if (!hasInterface) exitWith {};
_currentsize = count ([position player,1500] call CO_fnc_nearPlayers);
_oldSize = player getVariable ["ambientSize",_currentsize];
if (_oldSize != _currentsize) then 
{
	player setVariable ["hasDied",true];
	sleep 2;
	player setVariable ["hasDied",false];
	[player,false] spawn CO_fnc_ambientUnits;
	[player,false] spawn CO_fnc_ambientVehicles;

};