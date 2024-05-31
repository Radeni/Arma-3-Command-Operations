params ["_side","_faction"];

_zonePos = [0,0,0];
_aaPos = [0,0,0];

while {_aaPos select 0 == 0 && _aaPos select 1 == 0} do 
{
	_zonePos = [nil, ["water","base_radius",[getMarkerPos "base_radius", 1300]]] call BIS_fnc_randomPos;
	sleep 1;
	_aaPos = [_zonePos, 0, 2000, 30, 0, 0.25, 0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
};

_task = ["reconSabotage",_zonePos] call CO_fnc_taskCreator;

_searchZone = [_task,"zone",_zonePos,"ELLIPSE","Border",format ["Color%1",_side],1,[2500,2500]] call CO_fnc_createMarker;

_base = ["Camp_AA_01_Rad",_aaPos, random 360,true,true] call CO_fnc_spawnComposition;
_aaArows = nearestObjects [_aaPos,["Sign_Arrow_Direction_F"],30];
_arrow1 = _aaArows select 0;
_arrow2 = _aaArows select 1;
_arrow3 = nearestObject [_aaPos,"Sign_Arrow_Large_F"];


_samClass = "O_SAM_System_04_F";
_radarClass = "O_Radar_System_02_F";
if (_side == resistance) then {
_samClass = "I_E_SAM_System_03_F";
_radarClass = "I_E_Radar_System_01_F";
};

_aaUnit1 = createVehicle [_samClass,getPos _arrow1,[],2,"NONE"];
_aaUnit1 allowDamage false; _aaUnit1 setDir (getDir _arrow1);
_aaUnit2 = createVehicle [_samClass,getPos _arrow2,[],2,"NONE"];
_aaUnit2 allowDamage false; _aaUnit2 setDir (getDir _arrow2);

_radarUnit = createVehicle [_radarClass,getPos _arrow3,[],2,"NONE"];
_radarUnit allowDamage false; _radarUnit setDir (getDir _arrow3);
sleep 1;
_aaUnit1 setPos getPos _arrow1;_aaUnit2 setPos getPos _arrow2;_radarUnit setPos getPos _arrow3;
{createVehicleCrew _x; _x allowDamage true; _x setVehicleReceiveRemoteTargets true; _x setVehicleReportRemoteTargets true;} forEach [_aaUnit1,_aaUnit2,_radarUnit];
{deleteVehicle _x} forEach [_arrow1,_arrow2,_arrow3];
_radarUnit setVehicleRadar 1;
{_x addCuratorEditableObjects [[_aaUnit1,_aaUnit2,_radarUnit],true];} forEach allCurators;
{_x addEventHandler ["Fired",{(_this select 0) setVehicleAmmo 1}]} forEach [_aaUnit1,_aaUnit2];

_turn = [_radarUnit] spawn {	
params ["_radar"];
while {true} do 
	{
		if (count (_radar targets [true, 10000]) == 0) then {
		{
			_radar lookAt (_radar getRelPos [100, _x]);
			sleep 2.45;
		} forEach [120, 240, 0];};
	};
};


_taskPos = [_aaPos select 0,_aaPos select 1,0];

sleep 5;
//_patrols = [["PATROL", 200, "RED", _zonePos, "SAFE", [""], [5, "CIRCLE_L"]], 1, 2200, 12 - ("AmbientUnits" call BIS_fnc_getParamValue), format ["%1_Patrol",_task], _side, _faction, "MEN", "STANDARD", "AAPLANE", "CAR", [5,6,7,8], ["STAG COLUMN","COLUMN","FILE"], true] call CO_fnc_enemyAssault;
_patrols = [["PATROL", 200, "RED", _zonePos, "SAFE", [""]], 100, 2200, 8, format ["%1_Patrol",_task], _side, _faction, "STANDARD",[4,8,6], ["STAG COLUMN","COLUMN","FILE"], true] call CO_fnc_spawnMen;
sleep 5;
//_guards = [["PATROL", 30, "RED", _taskPos, "SAFE", [""], [5, "CIRCLE_L"]], 1, 30, 4, format ["%1_Guard",_task], _side, _faction, "MEN", "RECON", "AAPLANE", "CAR", 6, "FILE", true] call CO_fnc_enemyAssault;
_guards = [["PATROL", 30, "RED", _taskPos, "SAFE", [""]], 10, 40, 5, format ["%1_Guard",_task], _side, _faction, "RECON", 6, "FILE", true] call CO_fnc_spawnMen;

_enemies = _patrols + _guards + _base;

_onClear = format ["['%1', 'Succeeded'] call BIS_fnc_taskSetState;{_x addScore 20} forEach allPlayers;[%2,2500,(thisTrigger getVariable 'garbage'),(thisTrigger getVariable 'markers')] spawn CO_fnc_cleanup; deleteVehicle thisTrigger", _task, _zonePos];
_isClear = createTrigger ["EmptyDetector", _taskPos];
_isClear setTriggerArea [250, 250, 0, false];
_isClear setVariable ["aaunits",[_aaUnit1,_aaUnit2,_radarUnit]];
_isClear setTriggerTimeout [10, 10, 10, true];
_isClear setTriggerActivation [str _side, "PRESENT", false];
_isClear setVariable ["markers",[_searchZone]];
_isClear setVariable ["garbage",_enemies];
_isClear setTriggerStatements ["!alive (thisTrigger getVariable 'aaunits' select 0) && !alive (thisTrigger getVariable 'aaunits' select 1) && !alive (thisTrigger getVariable 'aaunits' select 2)" ,_onClear,""];