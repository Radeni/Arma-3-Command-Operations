// SpawnAircraft Function

params ["_wpParams", "_minRadius", "_maxRadius", "_groupCountParam", "_groupName", "_groupSideParam", "_groupFactionParam", "_vehTypeParam","_unitCount", "_formationParam", "_sim"];
private ["_target", "_a", "_b", "_allEnemies"];

_allEnemies = [];

_target = _wpParams select 3;
_blacklist = _wpParams select 5;
_altitude = _wpParams select 6;

_targetPos = switch (typeName _target) do 
{
	case "OBJECT": {getPos _target};  //If the target data type is an object, like a vehicle or person, it's position is used
	case "ARRAY": {_target};  //If the target data type is an array it is assumed that it's an array of coordinates.
};
_groupCount = 1;
if (typeName _groupCountParam == "ARRAY") then {_groupCount = selectRandom _groupCountParam} else {_groupCount = _groupCountParam};

// Loop to spawn groups
for "_a" from 1 to _groupCount do {
	// Spawning group

	//Side selection, allowing for randomization
	_groupSide = east;
	if (typeName _groupSideParam == "ARRAY") then {_groupSide = selectRandom _groupSideParam} else {_groupSide = _groupSideParam};
	_faction = "";
	if (typeName _groupFactionParam == "ARRAY") then {_faction = selectRandom _groupFactionParam} else {_faction = _groupFactionParam};
	_vehType = _vehTypeParam;
	if (typeName _vehTypeParam == "ARRAY") then {_vehType = selectRandom _vehTypeParam};
	
	_hash = switch (_groupSide) do {
		case east: {eastHash};
		case resistance: {indHash};
		case civilian: {civHash};
		default {eastHash};  //If side isn't recognized, default to the CSAT faction from the East hashmap.
	};

	//Array containing nested arrays of unit types belonging to a specific faction within a specific side (east or independent). The hash maps are initialized as public variables on the Server machine
	_factionArray = switch (_faction) do {
		case "RANDOM": {_hash get (selectRandom keys _hash)};
		default {_hash get _faction;};
	};
	

	//Get unit classnames for different types of infantry
    _cas = [];
	_plane = [];
	_transport = [];
    _unitArray = [];

    if (_groupSide == civilian) then {
        _unitArray = _factionArray select 2;
    } else {
        _cas = _factionArray select 6;
        _plane = _factionArray select 7;
        _transport = _factionArray select 8;

        //Pre-select classnames based on menType parameter
        _unitArray = switch (_vehType) do {
            case "CAS": {_cas};
            case "PLANE": {_plane};
            case "TRANSPORT": {_vehHeavy};
            default {selectRandom [_cas, _plane, _transport]}; //Pre-select randomly if unspecified
        };
    };
	

	_spawnPos = [[[_targetPos,_maxRadius]], ["water",[_targetPos, _minRadius]]] call BIS_fnc_randomPos; //Finds random position near the target position for spawning of the units. Max radius determines the farthest distance from target for spawning, while Min. radius determines the closest.
	_spawnPos = [_spawnPos select 0, _spawnPos select 1, 0];  //Ensures that the Z coordinate is 0 in order to spawn the units on the ground.
	if (_spawnPos select 0 == 0 and _spawnPos select 1 == 0) exitWith {_allEnemies};  //If a proper spawn position could not by found by BIS_fnc_randomPos it returns [0,0,0]. In that case, we exit the function without any units spawned.


	_group = createGroup [_groupSide, true];
	_groupId = [format ["%1_%2",_groupName,_a]];
	_group setGroupIdGlobal _groupId;

    _unitsAmount = 1;
	if (typeName _unitCount == "ARRAY") then {_unitsAmount = selectRandom _unitCount};
    
	// Adding units to group
	for "_b" from 1 to _unitsAmount do {
		_airPos = [(_spawnPos select 0),(_spawnPos select 1),_altitude];
        _unit = createVehicle [(selectRandom _unitArray),_airPos,[],100,"FLY"];
        createVehicleCrew _unit;
        _allEnemies pushBack _unit;
        units group driver _unit join _group;
        _allEnemies append units _group;
	};

	// Setting formation
	_formation = "COLUMN";
	if (typeName _formationParam == "ARRAY") then {_formation = selectRandom _formationParam} else {_formation = _formationParam};
	_group setFormation _formation;

	// Adding waypoints
	_type = _wpParams select 0;
	_radius = _wpParams select 1;
	_combatMode = _wpParams select 2;
	_behaviour = _wpParams select 4;

	switch _type do {
		//Move: Group will move to the target position
		case "MOVE": {
			_wp = _group addWaypoint [_target, 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointCombatMode _combatMode;
			_wp setWaypointCompletionRadius 3;
		};
		//Destroy: Group will chase the target in order to kill/destroy it.
		case "DESTROY": { 
			_wp = _group addWaypoint [_target, 0];
			_wp waypointAttachObject _target;
			_wp setWaypointType "DESTROY";
			_wp setWaypointCombatMode _combatMode;
			_wp setWaypointBehaviour _behaviour;
		};
		//Search And Destroy: Group will search the area near the target for any enemies.
		case "SAD": {
			_wp = _group addWaypoint [_target, 0];
			_wp setWaypointType "SAD";
			_wp setWaypointCombatMode _combatMode;
			_wp setWaypointBehaviour _behaviour;
			_wp setWaypointCompletionRadius 1;
		};
		//Patrol: Group will patrol an area in a pattern created by BIS_fnc_taskPatrol. _radius determines the maximum distance between two patrol waypoints in the pattern.
		case "PATROL": {
			[_group, _targetPos, _radius] call BIS_fnc_taskPatrol;
		};
		//Patrol Roads: Creates a patrol pattern for the group based on roads within the radius of it's spawn position. Logic works the same for Men and Vehicles.
		case "LOITERL":
		{
			_wp = _group addWaypoint [_targetPos, 10];
            _wp setWaypointType "LOITER";
            _wp setWaypointCombatMode _combatMode;
            _wp setWaypointBehaviour _behaviour;
            _wp setWaypointLoiterRadius _radius;
            _wp setWaypointLoiterType "CIRCLE_L";
		};
        case "LOITER":
		{
			_wp = _group addWaypoint [_targetPos, 10];
            _wp setWaypointType "LOITER";
            _wp setWaypointCombatMode _combatMode;
            _wp setWaypointBehaviour _behaviour;
            _wp setWaypointLoiterRadius _radius;
            _wp setWaypointLoiterType "CIRCLE";
		};
	};
    {_x flyInHeightASL [_altitude, _altitude, 50];} forEach units _group;
	// Set dynamic simulation
	_group enableDynamicSimulation _sim;
};

// Make all units in spawned groups editable by curators
{[_x, [_allEnemies, true]] remoteExecCall ["addCuratorEditableObjects", 0];} forEach allCurators;

// Returning list of all spawned enemies
_allEnemies;

