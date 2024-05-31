params ["_enemySide", "_faction"];
/* Created by Broken_Algorithm on the 08/04/2020. Arma 3 version 1.96 */
_enemies = [];


_selectableLocations = nearestLocations [getPos selectRandom allPlayers, ["NameCityCapital", "NameCity", "NameVillage"], 25000];

_cacheArea = selectRandom _selectableLocations;

while {(getPos _cacheArea) distance2D markerPos "base_radius" < 1700} do {
   _cacheArea = selectRandom _selectableLocations;
};

_buildings = nearestObjects [getPos _cacheArea, ["Land_i_House_Small_02_V3_F", "Land_u_House_Small_01_V1_F", "Land_i_House_Small_01_V3_F", "Land_i_Stone_HouseSmall_V1_F"], 700];
_cacheBuilding = selectRandom _buildings;
_objects_in_cache = [_cacheBuilding, 1] call CO_fnc_makeCacheAttachments;
_enemies append _objects_in_cache;

_SabotageTask = ["sabotageInfantry", getPos _cacheBuilding] call CO_fnc_taskCreator;

_buildings_in_immediate_surrounding =  nearestObjects [getPos _cacheBuilding,["House", "Building"], 35];
_randomBuildings_further_away =  nearestObjects [getPos _cacheBuilding,["House", "Building"], 250];

_groupIterator = 0;
{
    _enemies_one = [_x, _enemySide, format ["garrisonedGroup_%1_%2", _SabotageTask, _groupIterator], 3 + random 7, _faction, "STANDARD"] call CO_fnc_garrisonBuilding;
    _enemies append _enemies_one;
    _groupIterator = _groupIterator + 1;
} forEach _buildings_in_immediate_surrounding;

for "_x" from 1 to 3 + random 5 do {
  _enemies_two =  [selectRandom _randomBuildings_further_away, _enemySide, format ["garrisonedGroup_%1_%2", _SabotageTask, _groupIterator], 3 + random 7, _faction, "STANDARD"] call CO_fnc_garrisonBuilding;
  _enemies append _enemies_two;
  _groupIterator = _groupIterator + 1;
};

_enemies_three =  [["PATROL_ROADS", 60, "RED", getPos _cacheBuilding, "SAFE", [""], [""]], 15, 40, 3 + round random 3, "patrolGroup_" + _SabotageTask, _enemySide, _faction, "RECON", 3,"STAG COLUMN",true] call CO_fnc_enemyAssault;
_enemies_four = [["PATROL_ROADS", 200, "RED", getPos _cacheBuilding, "SAFE", [""], [""]], 100, 200, 3 + round random 4, "patrolGroup_" + _SabotageTask, _enemySide, _faction, "STANDARD",[4,5,6],"STAG COLUMN",true] call CO_fnc_enemyAssault;
_enemies append _enemies_three;
_enemies append _enemies_four;

_supplyCrate = selectRandom _objects_in_cache;
{
 if(typeOf _x == "O_supplyCrate_F") then {
     _supplyCrate = _x;
 };
}forEach _objects_in_cache;

[_supplyCrate,
 "Sabotage",
 "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa",
 "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa",
 "_this distance _target < 3",
 "_caller distance _target < 3",
 {},
 {},
 {
  _target setDamage 1;
  [_target,1 ] remoteExecCall ["BIS_fnc_holdActionRemove",0];
 },
 {},
 [],
 10,
 0,
 true,
 false
] remoteExec ["BIS_fnc_holdActionAdd", 0, _supplyCrate];

	_reinforcementsInfil = [[[getPos _cacheBuilding, 600]],[]] call BIS_fnc_randomPos;
  _reinforcementsSpawnPos =  [[[getPos _cacheBuilding, 4000]],[]] call BIS_fnc_randomPos;

_isClear = createTrigger ["EmptyDetector", getPos _cacheBuilding];

if(_enemySide != east) then {
  _enemySide = "oogabooga";
  _isClear setTriggerActivation [str resistance, "PRESENT", false];
};

_onClear = format [
         "_enemies = (thisTrigger getVariable 'garbage'); if(1 + random 10 < 6) then {_enemies_five = [(thisTrigger getVariable 'positionReinforcements'),(thisTrigger getVariable 'positionReinforcementsInfil'),'FLY_IN',(thisTrigger getVariable 'positionReinforcementsSpawn'),'O_Heli_Transport_04_covered_F',
           []
           ,(thisTrigger getVariable 'task'), '%1', 0.5, (thisTrigger getVariable 'positionReinforcements'), true, true, true] call CO_fnc_reinforcements;{_x addScore 15} forEach allPlayers; _enemies append _enemies_five;};['%2', 'Succeeded'] call BIS_fnc_taskSetState;[%3,1000,_enemies,[]] spawn CO_fnc_cleanup;  deleteVehicle thisTrigger",_enemySide, _SabotageTask, getPos _cacheBuilding];
//systemChat _onClear;

_isClear setTriggerArea [250, 250, 0, false];
_isClear setVariable ["supplyCrate",_supplyCrate];
_isClear setVariable ["task", _SabotageTask];
_isClear setVariable ["positionReinforcements", getPos _cacheBuilding];
_isClear setVariable ["positionReinforcementsInfil", _reinforcementsInfil];
_isClear setVariable ["positionReinforcementsSpawn", _reinforcementsSpawnPos];
_isClear setTriggerTimeout [10, 10, 10, true];
_isClear setVariable ["garbage",_enemies];
_isClear setTriggerStatements ["!alive (thisTrigger getVariable 'supplyCrate')" ,_onClear,""];

_SabotageTask;
