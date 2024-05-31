params ["_side","_faction"];

_town = call CO_fnc_selectTown;
_townPos = locationPosition _town;
_center = [_townPos select 0, _townPos select 1, 0];

_task = ["townClear",_center] call CO_fnc_taskCreator;
_title = format ["Clear %1", text _town];
_description = format ["<marker name='%2'>%1</marker> has been occupied by enemy forces. The local population has requested our help. Clear <marker name='%2'>%1</marker> of hostile forces!", text _town, _town];
[_task, [_description, _title,""]] call BIS_fnc_taskSetDescription;

_enemies = [];

_patrolCount = 5;
_patrolDistance = 80;
_vehCount = selectRandom [4,5,6];
_buildingCount = selectRandom [5,6,7];

switch type _town do
{
	case "NameVillage": {_patrolCount = 4; _patrolDistance = 50; _vehCount = 1 + round random 2;  _buildingCount = 5 + round random 2};
	case "NameCity": {_patrolCount = 4 + round random 3; _patrolDistance = 75; _vehCount = 2 + round random 2;  _buildingCount = 6 + round random 2};
	case "NameCityCapital": {_patrolCount = 5 + round random 3; _patrolDistance = 100; _vehCount = 2 + round random 3;  _buildingCount = 7+ round random 3};
};

//_patrols = [["PATROL_ROADS", _patrolDistance * 3, "RED", _center, "SAFE", [""], [5, "CIRCLE_L"]], 1, 250, _patrolCount, format ["%1_Patrol",_task], _side, _faction, "MEN", "STANDARD", "AAPLANE", "CAR", [4,5,6,7,8],["STAG COLUMN","COLUMN","FILE"], true] call CO_fnc_enemyAssault;
_patrols = [["PATROL_ROADS", 160, "RED", _center, "SAFE", [""]], 10, 250, _patrolCount, format ["%1_Patrol",_task], _side, _faction, "STANDARD",[4,6,8], ["STAG COLUMN","COLUMN","FILE"], true] call CO_fnc_spawnMen;

//_vehPatrols = [["PATROL_ROADS", _patrolDistance * 10, "RED", _center, "SAFE", [""], [5, "CIRCLE_L"]], 5, 500, _vehCount, format ["%1_Car",_task], _side, _faction, "GROUND", "STANDARD", "AAPLANE", "CAR", selectRandom [1,2], "COLUMN", false] call CO_fnc_enemyAssault;
_vehPatrols = [["PATROL_ROADS", 400, "RED", _center, "SAFE", [""]], 1, 500, _vehCount, format ["%1_Vehicle",_task], _side, _faction, "RANDOM",[1,2], "COLUMN", true] call CO_fnc_spawnVehicles;

_enemies = _patrols + _vehPatrols;

_townZone = [_task,"zone",_center,"ELLIPSE","FDiagonal",format ["Color%1",_side],1,[150,150]] call CO_fnc_createMarker;
_allBuildings = nearestObjects [_center, ["House","Building"],200];
_possibleBuildings = [];
{
	_positions = _x buildingPos -1;
	_posCount = count _positions;
	if (_posCount >=4 && _posCount <= 50) then {_possibleBuildings append [_x]};
} forEach _allBuildings;

if (count _possibleBuildings < _buildingCount) then {_buildingCount = count _possibleBuildings};

for "_i" from 1 to _buildingCount do
{
	_building =  _possibleBuildings select (_i - 1);
	_possibleBuildings = _possibleBuildings - [_building];
	_furniture = [_building] call CO_fnc_makeBuildingAttachments;
	_garrison = [_building,_side, format ["%1_Garrison_%2",_task,_i], selectRandom [4,5,6,7,8,9,10,12,14,15,20,25,30,40], _faction, "STANDARD"] call CO_fnc_garrisonBuilding;
	_enemies = _enemies + _garrison + _furniture;
};

_airChance = [1,100] call BIS_fnc_randomInt;
if (_airChance >= 44) then 
{
	//_airPatrols = [["PATROL", 400, "RED", _center, "SAFE", [""], 150], 5, 200, 1, format ["%1_CAS",_task], _side, _faction, ["CAS","PLANE"],  [1,2], "COLUMN", true] call CO_fnc_spawnAircraft;
	_airPatrols = [["PATROL", 800, "RED", _center, "SAFE", [""], 200], 1, 1500, 1, format ["%1_CAS",_task], _side, _faction, ["CAS","PLANE","CAS"], [1,2],"COLUMN", false] call CO_fnc_spawnAircraft;  
	_enemies append _airPatrols;
};


{_x addCuratorEditableObjects [_enemies,true];} forEach allCurators;

_completionTreshold = round (count _enemies * 0.05);

_onClear = format ["['%1', 'Succeeded'] call BIS_fnc_taskSetState;{_x addScore 30} forEach allPlayers;[%2,1500,(thisTrigger getVariable 'garbage'),(thisTrigger getVariable 'markers')] spawn CO_fnc_cleanup; deleteVehicle thisTrigger", _task, _center];
_isClear = createTrigger ["EmptyDetector", _center];
_isClear setTriggerArea [250, 250, 0, false];
_isClear setVariable ["markers",[_townZone]];
_isClear setVariable ["garbage",_enemies];
_isClear setTriggerTimeout [10, 10, 10, true];
_isClear setTriggerActivation [str _side, "PRESENT", false];
_isClear setVariable ["trash", _enemies, false];
_isClear setTriggerStatements [format ["count thisList < %1",_completionTreshold],_onClear,""];
