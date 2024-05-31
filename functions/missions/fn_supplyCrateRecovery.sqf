params ["_taskID"];

_areaPos = [nil, ["water",[getMarkerPos "base_radius",3000]] call BIS_fnc_randomPos;
_area = ["crateArea",_taskID,_areaPos,"ELLIPSE","FDiagonal","ColorUNKNOWN",1,[100,100]] call CO_fnc_createMarker;
missionNamespace setVariable [format ["createArea_%1"_taskID], _aoRadius, true];
_cratePos = [_areaPos, 5, 100, 10, 0, 0.7, 0, [], [_areaPos, _areaPos]] call BIS_fnc_findSafePos;
_crate = "B_CargoNet_01_ammo_F" createVehicle _cratePos;
clearItemCargoGlobal _crate;


_texts = [format ["A supply crate headed for one of our bases has been dropped in an enemy-controlled territory by mistake. Our intel suggests that the crate is somewhere within a <marker name='%1'>100m radius</marker> from where it was dropped.<br/>Your task is to find the crate and mark it for our recovery team. The problem is that any nearby enemy units will know the crate's location until the tracker's GPS data is uploaded to our network so you will have stay and neutralize any search parties that might come your way.",_area],"Find the missing supplies", nil];
_state = "CREATED";
_priority = 10;
_showNotification = true;
_taskType = "search";
_alwaysVisible = true;
[west,_taskid,_texts,_taskPos,_state,_priority,_showNotification,_taskType,_alwaysVisible] call BIS_fnc_taskCreate;

_isClear = createTrigger ["EmptyDetector", _cratePos];
_isClear setVariable ["marker",_area];

_triggerActivation = format ["_complete = ['%1','%2', %3] execVM 'missions\completeao.sqf';deleteVehicle thisTrigger;",_randomTown,_taskid,_taskIdNum];

_isClear setTriggerArea [200, 200, 0, false];
_isClear setTriggerStatements ["count thisList < 10",_triggerActivation,""];