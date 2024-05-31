params ["_side","_faction"];

_civs = (civHash get "Vanilla") select 0;


_garrison = [];
_center = [0,0,0];
_compound = [_center, 50] call CO_fnc_findHouse;
while {(count _compound) < 6} do
{
	_center = [nil, ["water","base_radius",[getMarkerPos "base_radius", 1300]]] call BIS_fnc_randomPos;
	_compound = [_center, 50] call CO_fnc_findHouse;
};

_garbage = [];
_task = ["hostageRescue",_center] call CO_fnc_taskCreator;


for "_i" from 0 to 5 do 
{
	_building = _compound select _i;
	_amount = count (_building call BIS_fnc_buildingPositions);
	_garrison = [_building,_side, format ["%1_Garrison_%2",_task,_i], _amount, _faction, "STANDARD"] call CO_fnc_garrisonBuilding;
	_fortifications = [_building] call CO_fnc_makeBuildingAttachments;
	_garbage append _garrison + _fortifications;
};


_civId = [format ["%1_Hostages",_task]];
_group = createGroup [civilian, true];
_group setGroupIdGlobal _civId;
_currentbuilding = _compound select (selectRandom [0,1,2,3,4,5]);
_buildingPositions = [_currentbuilding] call BIS_fnc_buildingPositions;
_civ = _group createUnit [selectRandom _civs, selectRandom _buildingPositions,[],0.1,"CAN_COLLIDE"];
_civ switchMove selectRandom ["Acts_AidlPsitMstpSsurWnonDnon05","Acts_AidlPsitMstpSsurWnonDnon04","Acts_AidlPsitMstpSsurWnonDnon03","Acts_AidlPsitMstpSsurWnonDnon02","Acts_AidlPsitMstpSsurWnonDnon01"];
_civ disableAI "MOVE";
_civ setCaptive true;
{_x addCuratorEditableObjects [[_civ],true]} forEach allCurators;
[_civ,
 "Untie",
 "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa",
 "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa",
 "_this distance _target <= 2.5", "_caller distance _target <= 2.5",
 {}, 
 {}, 
 { 
	[_target,_actionId ] remoteExecCall ["BIS_fnc_holdActionRemove",0];
	[_target] remoteExecCall ["CO_fnc_leadAI",0];
	_target playMoveNow "Acts_AidlPsitMstpSsurWnonDnon_out";
	_target enableAI "MOVE";
	_target disableAI "PATH";
	[_a0,["Good job finding the hostage! Take them back to the base and bring them to the <marker name='marker_medical'>field hospital</marker>","Rescue the hostage",""]] call BIS_fnc_taskSetDescription;
	[_a0, _target] call BIS_fnc_taskSetDestination;
	[_a0, "run"] call BIS_fnc_taskSetType;
	[_a0, "CREATED", true] call BIS_fnc_taskSetState;
	_a0 call BIS_fnc_taskSetCurrent;
 },
 {},
 [_task],
 1.5,
 10,
 true,
 false,
 true
] remoteExec ["BIS_fnc_holdActionAdd",0];

//_guards = [["PATROL_ROADS", 60, "RED", _center, "SAFE", [""], [5, "CIRCLE_L"]], 10, 50, 4, format ["%1_NearPatrol",_task], _side, _faction, "MEN", "STANDARD", "AAPLANE", "CAR", [3,2], ["COLUMN","FILE"], true] call CO_fnc_enemyAssault;

_guards = [["PATROL_ROADS", 60, "RED", _center, "SAFE", [""]], 10, 50, 5, format ["%1_NearPatrol",_task], _side, _faction, "STANDARD",6, "COLUMN", true] call CO_fnc_spawnMen;

_garbage append _guards;

//Fail condition:
_onFail = format ["['%1', 'Failed', true] call BIS_fnc_taskSetState;[%2,1500,(thisTrigger getVariable 'garbage'),[]] spawn CO_fnc_cleanup;{_x addScore -10} forEach allPlayers;deleteVehicle (thisTrigger getVariable 'otherTrigger'); deleteVehicle thisTrigger; ", _task, _center];
_failed = createTrigger ["EmptyDetector", (getPos _civ)];
_failed setVariable ["civ",_civ];
_failed setTriggerArea [5, 5, getDir base_tent, true, 20];
_failed setTriggerTimeout [5, 5, 5, false];
_failed setVariable ["garbage",_garbage];
_failed setTriggerStatements ["!alive (thisTrigger getVariable 'civ')" ,_onFail,""];

//Sucess condition:
_onClear = format ["['%1', 'Succeeded',true] call BIS_fnc_taskSetState;[%2,2500,(thisTrigger getVariable 'garbage'),[]] spawn CO_fnc_cleanup;{_x addScore 30} forEach allPlayers;deleteVehicle (thisTrigger getVariable 'civ');deleteVehicle (thisTrigger getVariable 'otherTrigger'); deleteVehicle thisTrigger; ", _task, _center];
_isClear = createTrigger ["EmptyDetector", (getPos base_tent)];
_isClear setVariable ["civ",_civ];
_isClear setTriggerArea [5, 5, getDir base_tent, true, 20];
_isClear setTriggerTimeout [1, 1, 1, false];
_isClear setVariable ["garbage",_garbage];
_isClear setTriggerStatements ["base_tent distance (thisTrigger getVariable 'civ') <= 10" ,_onClear,""];

_isClear setVariable ["otherTrigger",_failed];
_failed setVariable ["otherTrigger",_isClear];

