params ["_object","_single"];

if (!hasInterface) exitWith {};
if (!alive _object) exitWith {if (COAllowAmbience) then {[player, _single] spawn CO_fnc_ambientVehicles};};

	waitUntil {_object distance2D (getMarkerPos "base_radius") > 2000};
if (!alive _object) exitWith {[player, _single] spawn CO_fnc_ambientVehicles};
	_squadCount = 1;
	_townPos = getPos _object;
	_center = [_townPos select 0, _townPos select 1, 0];
	if (!_single) then {
	_squadCount = round (("AmbientVehicles" call BIS_fnc_getParamValue)/(count ([_center,1500] call CO_fnc_nearPlayers)));
	};
	//_enemies = [["PATROL_ROADS", 1500, "YELLOW", _center, "SAFE", [""], [5, "CIRCLE_L"]], 350, 1800, _squadCount, ("AmbienceVeh_" + str (ambienceCount + 1) + "_group_"), [civilian,civilian,civilian,east,resistance,civilian,civilian], "RANDOM", "GROUND",["RECON","STANDARD","SPECIAL"], "AAPLANE", "CAR", 1,["COLUMN"], false] call CO_fnc_enemyAssault;
	_enemies = [["PATROL_ROADS", 1500, "YELLOW", _center, "SAFE", [""]], 350, 1800, _squadCount, ("AmbienceVeh_" + str (ambienceCount + 1) + "_group_"), [civilian,civilian,civilian,east,resistance,civilian,civilian], "RANDOM", "RANDOM", 1,"COLUMN", false] call CO_fnc_spawnVehicles;
	ambienceCount = ambienceCount + 1;
 if (count _enemies > 0) then {	{
		if (_x == leader group _x) then {
			[_x,[vehicle _x] + units group _x,_object] spawn CO_fnc_ambientVehCleanup;
		};
	} forEach _enemies;} else 
	{sleep 10; [_object,_single] spawn CO_fnc_ambientVehicles;};
		

