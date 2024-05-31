params ["_side","_faction"];



_zonePos = [nil, ["water","base_radius",[getMarkerPos "base_radius", 1300]]] call BIS_fnc_randomPos;

_task = ["reconAntirecon",_zonePos] call CO_fnc_taskCreator;

_searchZone = [_task,"zone",_zonePos,"ELLIPSE","Border",format ["Color%1",_side],1,[1600,1600]] call CO_fnc_createMarker;


_camp_1_pos = ([_zonePos, 0, 1500, 10, 0, 0.25, 0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos) + [0];
_camp_2_pos = ([_zonePos, 0, 1500, 10, 0, 0.25, 0,[[_camp_1_pos,200]],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos) + [0];
_camp_3_pos = ([_zonePos, 0, 1500, 10, 0, 0.25, 0,[[_camp_1_pos,200],[_camp_2_pos,200]],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos) + [0];


_taskDescription = ["Take out enemy soldiers in the camp","Kill scouts",""];
_taskActivation = "!alive ((thisTrigger getVariable 'campGrp') select 0) && !alive ((thisTrigger getVariable 'campGrp') select 1) && !alive ((thisTrigger getVariable 'campGrp') select 2) && !alive ((thisTrigger getVariable 'campGrp') select 3)";
//First camp:
sleep 1;
_camp_1 = [_side,format ["%1_camp_1",_task],_camp_1_pos,_faction] call CO_fnc_reconCamp;
_camp_1_zone_pos = [[[_camp_1_pos,400]], nil] call BIS_fnc_randomPos;
_camp_1_zone = [_task,"camp_1_zone",_camp_1_zone_pos,"ELLIPSE","FDiagonal",format ["Color%1",_side],1,[400,400]] call CO_fnc_createMarker;
_isClear_1 = createTrigger ["EmptyDetector", _camp_1_pos];
_task_1 = [true, [_task + "_camp_1",_task], _taskDescription, _camp_1_zone_pos, "CREATED", -1, false, "Kill", true] call BIS_fnc_taskCreate;
_onClear_1 = format ["['%1', 'Succeeded'] call BIS_fnc_taskSetState; '%2' setMarkerAlpha 0.5; '%2' setMarkerColor 'ColorBlack';deleteVehicle thisTrigger; ", _task_1, _camp_1_zone];
_isClear_1 setVariable ["campGrp",(_camp_1 select 0)];
_isClear_1 setTriggerStatements [_taskActivation,_onClear_1,""];

//First camp:
sleep 1;
_camp_2 = [_side,format ["%1_camp_2",_task],_camp_2_pos,_faction] call CO_fnc_reconCamp;
_camp_2_zone_pos = [[[_camp_2_pos,400]], nil] call BIS_fnc_randomPos;
_camp_2_zone = [_task,"camp_2_zone",_camp_2_zone_pos,"ELLIPSE","FDiagonal",format ["Color%1",_side],1,[400,400]] call CO_fnc_createMarker;
_isClear_2 = createTrigger ["EmptyDetector", _camp_2_pos];
_task_2 = [true, [_task + "_camp_2",_task], _taskDescription, _camp_2_zone_pos, "CREATED", -1, false, "Kill", true] call BIS_fnc_taskCreate;
_onClear_2 = format ["['%1', 'Succeeded'] call BIS_fnc_taskSetState; '%2' setMarkerAlpha 0.5; '%2' setMarkerColor 'ColorBlack';deleteVehicle thisTrigger; ", _task_2, _camp_2_zone];
_isClear_2 setVariable ["campGrp",(_camp_2 select 0)];
_isClear_2 setTriggerStatements [_taskActivation,_onClear_2,""];

//First camp:
sleep 1;
_camp_3 = [_side,format ["%1_camp_3",_task],_camp_3_pos,_faction] call CO_fnc_reconCamp;
_camp_3_zone_pos = [[[_camp_3_pos,400]], nil] call BIS_fnc_randomPos;
_camp_3_zone = [_task,"camp_3_zone",_camp_3_zone_pos,"ELLIPSE","FDiagonal",format ["Color%1",_side],1,[400,400]] call CO_fnc_createMarker;
_isClear_3 = createTrigger ["EmptyDetector", _camp_3_pos];
_task_3 = [true, [_task + "_camp_3",_task], _taskDescription, _camp_3_zone_pos, "CREATED", -1, false, "Kill", true] call BIS_fnc_taskCreate;
_onClear_3 = format ["['%1', 'Succeeded'] call BIS_fnc_taskSetState; '%2' setMarkerAlpha 0.5; '%2' setMarkerColor 'ColorBlack';deleteVehicle thisTrigger; ", _task_3, _camp_3_zone];
_isClear_3 setVariable ["campGrp",(_camp_3 select 0)];
_isClear_3 setTriggerStatements [_taskActivation,_onClear_3,""];

{_x addCuratorEditableObjects [(_camp_1 select 0) + (_camp_2 select 0) + (_camp_3 select 0),true]} forEach allCurators;

_ambienceCount = 0;
if (COAllowAmbience) then {_ambienceCount = ("AmbientUnits" call BIS_fnc_getParamValue)};
//_patrols = [["PATROL", 500, "RED", _zonePos, "AWARE", [""], [5, "CIRCLE_L"]], 1, 1400, 12 - _ambienceCount, format ["%1_Patrol",_task], _side, _faction, "MEN", "STANDARD", "AAPLANE", "CAR", [4,5,6], ["STAG COLUMN","COLUMN","FILE"], true] call CO_fnc_enemyAssault;
_patrols = [["PATROL", 500, "RED", _zonePos, "AWARE", [""]], 100, 1400, 10 - _ambienceCount, format ["%1_Patrol",_task], _side, _faction, "STANDARD",[4,8,12], ["STAG COLUMN","COLUMN","FILE"], true] call CO_fnc_spawnMen;

_garbage = _patrols + (_camp_1 select 0) + (_camp_1 select 1) + (_camp_2 select 0) + (_camp_2 select 1) + (_camp_3 select 0) + (_camp_3 select 1);



//Sucess condition:
_onClear = format ["['%1', 'Succeeded'] call BIS_fnc_taskSetState;{_x addScore 20} forEach allPlayers;[%2,2000,(thisTrigger getVariable 'garbage'),(thisTrigger getVariable 'markers')] spawn CO_fnc_cleanup;deleteVehicle (thisTrigger getVariable 'pilot');deleteVehicle (thisTrigger getVariable 'otherTrigger'); deleteVehicle thisTrigger;", _task, _zonePos];
_isClear = createTrigger ["EmptyDetector", _zonePos];
_isClear setVariable ["markers",[_searchZone,_camp_1_zone,_camp_2_zone,_camp_3_zone]];
_isClear setTriggerArea [5, 5, 0, true, 0];
_isClear setTriggerTimeout [5, 5, 5, false];
_isClear setVariable ["garbage",_garbage];
_isClear setTriggerStatements [format ["('%1_camp_1'  call BIS_fnc_taskState) == 'Succeeded' && ('%1_camp_2'  call BIS_fnc_taskState) == 'Succeeded' && ('%1_camp_3'  call BIS_fnc_taskState) == 'Succeeded'",_task] ,_onClear,""];