params ["_side","_faction"];

_zonePos = [0,0,0];
_artyPos = [0,0,0];

while {_artyPos select 0 == 0 && _artyPos select 1 == 0} do 
{
	_zonePos = [nil, ["water","base_radius",[getMarkerPos "base_radius", 1300]]] call BIS_fnc_randomPos;
	sleep 1;
	_artyPos = [_zonePos, 0, 2000, 40, 0, 0.4, 0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
};

_task = ["reconSabotageArty",_zonePos] call CO_fnc_taskCreator;

_searchZone = [_task,"zone",_zonePos,"ELLIPSE","Border",format ["Color%1",_side],1,[2500,2500]] call CO_fnc_createMarker;

_base = ["Arty_FOB_01_Rad",_artyPos, random 360,true,true] call CO_fnc_spawnComposition;

_arrows = nearestObjects [_artyPos,["Sign_Arrow_Large_F"],50]; 

_mortars = [];
_artyGroup = createGroup [_side,true];
_artyGroup setGroupIdGlobal ["Artillery_" + _task];

{
	_mortarPos = getPosATL _x;
	deleteVehicle _x;
	_mortarClass = switch _side do
	{
		case EAST: {"O_Mortar_01_F"};
		case RESISTANCE: {"I_Mortar_01_F"};
	};
	_mortar = createVehicle [_mortarClass, _mortarPos,[],2,"NONE"];
	createVehicleCrew _mortar;
	units group _mortar join _artyGroup;
	_mortars append [_mortar];
	_mortar setPos _mortarPos;
	{_x addCuratorEditableObjects [[_mortar],true];} forEach allCurators;
} forEach _arrows;


_taskPos = [_artyPos select 0,_artyPos select 1,0];

sleep 2;
//_patrols = [["PATROL", 200, "RED", _zonePos, "SAFE", [""], [5, "CIRCLE_L"]], 1, 1200, 3, format ["%1_Patrol",_task], _side, _faction, "MEN", "RECON", "AAPLANE", "CAR", [5,6,7], ["STAG COLUMN","COLUMN","FILE"], true] call CO_fnc_enemyAssault;
_patrols = [["PATROL", 200, "RED", _zonePos, "SAFE", [""]], 100, 1200, 4, format ["%1_Patrol",_task], _side, _faction, "RECON",[4,8,6], ["STAG COLUMN","COLUMN","FILE"], true] call CO_fnc_spawnMen;
sleep 2;
//_guards = [["PATROL", 30, "RED", _taskPos, "SAFE", [""], [5, "CIRCLE_L"]], 1, 30, 4, format ["%1_Guard",_task], _side, _faction, "MEN", "RECON", "AAPLANE", "CAR", 6, "FILE", true] call CO_fnc_enemyAssault;
_guards = [["PATROL", 30, "RED", _taskPos, "SAFE", [""]], 10, 40, 4, format ["%1_Guard",_task], _side, _faction, "RECON",6, "FILE", true] call CO_fnc_spawnMen;

//_guards = [["PATROL", 20, "RED", _taskPos, "SAFE", [""], [5, "CIRCLE_L"]], 1, 50, 9, format ["%1_Guard",_task], _side, _faction, "MEN", "STANDARD", "AAPLANE", "CAR", [2,3,4], "FILE", true] call CO_fnc_enemyAssault;

_garbage = _patrols + _guards + _base;

_onClear = format ["['%1', 'Succeeded'] call BIS_fnc_taskSetState;{_x addScore 20} forEach allPlayers;[%2,2500,(thisTrigger getVariable 'garbage'),(thisTrigger getVariable 'markers')] spawn CO_fnc_cleanup; deleteVehicle thisTrigger", _task, _zonePos];
_isClear = createTrigger ["EmptyDetector", _taskPos];
_isClear setTriggerArea [250, 250, 0, false];
_isClear setVariable ["arty",_mortars];
_isClear setTriggerTimeout [10, 10, 10, true];
_isClear setTriggerActivation [str _side, "PRESENT", false];
_isClear setVariable ["markers",[_searchZone]];
_isClear setVariable ["garbage",_garbage];
_isClear setTriggerStatements ["!alive (thisTrigger getVariable 'arty' select 0) && !alive (thisTrigger getVariable 'arty' select 1) && !alive (thisTrigger getVariable 'arty' select 2) && !alive (thisTrigger getVariable 'arty' select 3)" ,_onClear,""];