params ["_side","_faction"];

_zonePos = [0,0,0];
_crashPos = [0,0,0];

while {_crashPos select 0 == 0 && _crashPos select 1 == 0} do 
{
	_zonePos = [nil, ["water","base_radius",[getMarkerPos "base_radius", 3000]]] call BIS_fnc_randomPos;
	sleep 1;
	_crashPos = [_zonePos, 0, 1800, 20, 0, 0.25, 0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
};

_task = ["reconRescue",_zonePos] call CO_fnc_taskCreator;

_searchZone = [_task,"zone",_zonePos,"ELLIPSE","Border",format ["Color%1",_side],1,[2000,2000]] call CO_fnc_createMarker;

_wreck = createVehicle [selectRandom ["Land_Wreck_Heli_Attack_01_F","Land_Wreck_Heli_02_Wreck_01_F"],_crashPos,[],5,"NONE"];

_smoke = [_wreck] call CO_fnc_smokeStack;
_wreck addEventHandler ["Killed",{deleteVehicle (_unit getVariable "smoke");}];

_pilotId = [format ["%1_Pilot",_task]];
_group = createGroup [WEST, true];
_group setGroupIdGlobal _pilotId;
_pilot = _group createUnit [selectRandom ["B_HeliPilot_F","B_Helicrew_F"],(_wreck getRelPos [5,100]),[],2,"NONE"];
_pilot switchMove "AinjPpneMstpSnonWrflDnon";
_pilot disableAI "MOVE";
_pilot setCaptive true;

{_x addCuratorEditableObjects [[_pilot,_wreck]]} forEach allCurators;
_pilot setVariable ["smoke",_smoke];
_pilot addEventHandler ["Killed",{deleteVehicle (_unit getVariable "smoke");}];
[_pilot,
 "Revive",
 "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa",
 "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa",
 "_this distance _target <= 2.5", "_caller distance _target <= 2.5",
 {_caller playAction "medicStart"}, 
 {}, 
 {
	[_target,_caller] remoteExec ["CO_fnc_pilotRevive",2]; 
	[_target,_actionId ] remoteExecCall ["BIS_fnc_holdActionRemove",0];
	[_a1,["Good job finding the wreck! Take the pilot back to the base and bring them to the <marker name='marker_medical'>field hospital</marker>","Rescue the pilot",""]] call BIS_fnc_taskSetDescription;
	[_a1, _target] call BIS_fnc_taskSetDestination;
	[_a1, "run"] call BIS_fnc_taskSetType;
	[_a1, "CREATED", true] call BIS_fnc_taskSetState;
	_a1 call BIS_fnc_taskSetCurrent;
	deleteVehicle _a0;
 },
 {_caller switchMove "";},
 [_smoke,_task],
 5,
 10,
 true,
 false,
 true
] remoteExec ["BIS_fnc_holdActionAdd",0,true];

_taskPos = [_crashPos select 0,_crashPos select 1,0];

sleep 1;
_ambienceCount = 0;
if (COAllowAmbience) then {_ambienceCount = ("AmbientUnits" call BIS_fnc_getParamValue)};
//_patrols = [["PATROL", 200, "RED", _zonePos, "SAFE", [""], [5, "CIRCLE_L"]], 1, 1500, 12 - _ambienceCount, format ["%1_Patrol",_task], _side, _faction, "MEN", "STANDARD", "AAPLANE", "CAR", 4 + round random 2, ["STAG COLUMN","COLUMN","FILE"], true] call CO_fnc_enemyAssault;
_patrols = [["PATROL", 200, "RED", _zonePos, "SAFE", [""]], 100, 1500, 10 - _ambienceCount, format ["%1_Patrol",_task], _side, _faction, "STANDARD",[4,8,6], ["STAG COLUMN","COLUMN","FILE"], true] call CO_fnc_spawnMen;
sleep 1;
//_guards = [["PATROL", 50, "RED", _taskPos, "SAFE", [""], [5, "CIRCLE_L"]], 150, 300, 4, format ["%1_NearPatrol",_task], _side, _faction, "MEN", "STANDARD", "AAPLANE", "CAR", 4 + round random 2, ["STAG COLUMN","COLUMN","FILE"], true] call CO_fnc_enemyAssault;
_guards = [["PATROL", 50, "RED", _taskPos, "SAFE", [""]], 100, 300, 4, format ["%1_NearPatrol",_task], _side, _faction, "STANDARD",[4,8,6], ["STAG COLUMN","COLUMN","FILE"], true] call CO_fnc_spawnMen;

_enemies = _patrols + _guards + [_wreck];

//Fail condition:
_onFail = format ["['%1', 'Failed', true] call BIS_fnc_taskSetState;[%2,1500,(thisTrigger getVariable 'garbage'),(thisTrigger getVariable 'markers')] spawn CO_fnc_cleanup;{_x addScore -20} forEach allPlayers;deleteVehicle (thisTrigger getVariable 'otherTrigger'); deleteVehicle thisTrigger; ", _task, _zonePos];
_failed = createTrigger ["EmptyDetector", (getPos _pilot)];
_failed setVariable ["pilot",_pilot];
_failed setVariable ["markers",[_searchZone]];
_failed setTriggerArea [5, 5, getDir base_tent, true, 20];
_failed setTriggerTimeout [5, 5, 5, false];
_failed setTriggerActivation [WEST, "PRESENT", false];
_failed setVariable ["garbage",_enemies];
_failed setTriggerStatements ["!alive (thisTrigger getVariable 'pilot')" ,_onFail,""];

//Sucess condition:
_onClear = format ["['%1', 'Succeeded',true] call BIS_fnc_taskSetState;[%2,2500,(thisTrigger getVariable 'garbage'),(thisTrigger getVariable 'markers')] spawn CO_fnc_cleanup;{_x addScore 40} forEach allPlayers;deleteVehicle (thisTrigger getVariable 'pilot');deleteVehicle (thisTrigger getVariable 'otherTrigger'); deleteVehicle thisTrigger; ", _task, _zonePos];
_isClear = createTrigger ["EmptyDetector", (getPos base_tent)];
_isClear setVariable ["pilot",_pilot];
_isClear setVariable ["markers",[_searchZone]];
_isClear setTriggerArea [5, 5, getDir base_tent, true, 20];
_isClear setTriggerTimeout [1, 1, 1, false];
_isClear setTriggerActivation [WEST, "PRESENT", false];
_isClear setVariable ["garbage",_enemies];
_isClear setTriggerStatements ["base_tent distance (thisTrigger getVariable 'pilot') <= 10" ,_onClear,""];

_isClear setVariable ["otherTrigger",_failed];
_failed setVariable ["otherTrigger",_isClear];
