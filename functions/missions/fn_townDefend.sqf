params ["_side","_faction"];

_town = call CO_fnc_selectTown;
_townPos = locationPosition _town;
_center = [_townPos select 0, _townPos select 1, 0];

_task = ["townDefend",_center] call CO_fnc_taskCreator;
_title = format ["Go to %1", text _town];
_description = format ["We have received intel that hostile forces are preparing to attack <marker name='%2'>%1</marker>. Go to the <marker name='%2'>%1</marker> and prepare to defend it!", text _town, _town];
[_task, [_description, _title,""]] call BIS_fnc_taskSetDescription;
[_task, 'Created',true] call BIS_fnc_taskSetState;


_waveCount = 0;
_waveDistance = 0;
_waveSize = 0;
_radius  = 0;

switch type _town do
{
	case "NameVillage": {_waveCount = 3; _waveDistance = 500; _waveSize = 5;_radius = 150;};
	case "NameCity": {_waveCount = 4 + random 1; _waveDistance = 700; _waveSize = 6;_radius = 250;};
	case "NameCityCapital": {_waveCount = 5 + random 2; _waveDistance = 850; _waveSize = 7;_radius = 450;};
};

_townZone = [_task,"zone",_center,"ELLIPSE","FDiagonal","ColorWEST",1,[_radius,_radius]] call CO_fnc_createMarker;

waitUntil{_center distance2D ([_center] call CO_fnc_nearestPlayer) <= _radius};
sleep 150;

_title = format ["Defend %1", text _town];
_description = format ["The enemy attack on %1 has begun. Stay in %1 and defend it!", text _town];
[_task, [_description, _title,""]] call BIS_fnc_taskSetDescription;
[_task, 'Created'] call BIS_fnc_taskSetState;
_task call BIS_fnc_taskSetCurrent;

_onFail = format ["[%1,%2,(thisTrigger getVariable 'garbage'),(thisTrigger getVariable 'markers')] spawn CO_fnc_cleanup;['%3', 'Failed'] call BIS_fnc_taskSetState;{_x addScore -20} forEach allPlayers; deleteVehicle (thisTrigger getVariable 'other'); deleteVehicle thisTrigger", _center, _waveDistance + 100, _task];
_isFailed = createTrigger ["EmptyDetector", _center];
_isFailed setTriggerArea [_radius, _radius, 0, false];
_isFailed setTriggerTimeout [15, 15, 15, true];
_isFailed setTriggerActivation ["WEST", "NOT PRESENT", false];
_isFailed setTriggerStatements ["this",_onFail,""];
_isFailed setVariable ["markers",[_townZone]];


private _enemies = [];
private _wave = [];
_i = 0;
while {_i < _waveCount} do
{
	if ((_task call BIS_fnc_taskState) == "FAILED") exitWith {};
	_groupName = format ["%1_%2_ATTACKER", _task, _i];
	_minDistance = _waveDistance - 50;
	_maxDistance = _waveDistance + 50;
	if (random 100 <= 35) then 
	{
		_wave = [["SAD",10, "RED", _center, "AWARE", [""]], _minDistance, _maxDistance, [2,3], _groupName, _side, _faction, ["LIGHT","MEDIUM","HEAVY"], [1,2], ["COLUMN","LINE"], false] call CO_fnc_spawnVehicles;
	} else 
	{
	_wave = [["SAD",10, "RED", _center, "AWARE", [""]], _minDistance, _maxDistance, _waveSize, _groupName, _side, _faction, ["STANDARD","RECON"], [4,5,6],["STAG COLUMN","WEDGE","LINE","VEE"], false] call CO_fnc_spawnMen;
	};
	if (random 100 <= 15) then 
	{
		_wave append ([["SAD",10, "RED", _center, "AWARE", [""],200], _waveDistance * 3, _waveDistance * 4, 1, _groupName + "_CAS", _side, _faction, ["CAS","CAS","PLANE"], [1,1,1,1,1,2,2], ["COLUMN","LINE"], false] call CO_fnc_spawnAircraft);
	};
	_i = _i + 1;
	_enemies = _enemies + _wave;
	_isFailed setVariable ["garbage",_enemies];
	sleep 180;
};
if ((_task call BIS_fnc_taskState) != "FAILED") then {
	_title = format ["Clear %1", text _town];
	_description = format ["The enemy attack on %1 is almost over. Clear %1 of the remaining attackers!", text _town];
	[_task, [_description, _title,""]] call BIS_fnc_taskSetDescription;
	[_task, 'Created', true] call BIS_fnc_taskSetState;
	_task call BIS_fnc_taskSetCurrent;
	
	_onClear = format ["['%1', 'Succeeded'] call BIS_fnc_taskSetState;{_x addScore 50} forEach allPlayers;[%2,%3,(thisTrigger getVariable 'garbage'), (thisTrigger getVariable 'markers')] spawn CO_fnc_cleanup; deleteVehicle (thisTrigger getVariable 'other'); deleteVehicle thisTrigger", _task, _center, _waveDistance + 100];

	_isFailed setTriggerStatements ["this",_onFail,""];
	_condition = format ["count thisList < 10 && ('%1' call BIS_fnc_taskState) != 'FAILED'",_task];
	_isClear = createTrigger ["EmptyDetector", _center];
	_isClear setTriggerArea [250, 250, 0, false];
	_isFailed setVariable ["other",_isClear];
	_isClear setVariable ["markers",[_townZone]];
	_isClear setVariable ["garbage",_enemies];
	_isClear setVariable ["other",_isFailed];
	_isClear setTriggerTimeout [10, 10, 10, true];
	_isClear setTriggerActivation [str _side, "PRESENT", false];
	_isClear setTriggerStatements [_condition,_onClear,""];

};

