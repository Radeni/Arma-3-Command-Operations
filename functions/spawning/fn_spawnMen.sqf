// SpawnMen Function

params ["_wpParams", "_minRadius", "_maxRadius", "_groupCount", "_groupName", "_groupSideParam", "_groupFactionParam", "_menTypeParam","_unitCount", "_formationParam", "_sim"];
private ["_target", "_a", "_b", "_allEnemies"];

_allEnemies = [];

_target = _wpParams select 3;

_targetPos = switch (typeName _target) do 
{
	case "OBJECT": {getPos _target};  //If the target data type is an object, like a vehicle or person, it's position is used
	case "ARRAY": {_target};  //If the target data type is an array it is assumed that it's an array of coordinates.
};


if (typeName _groupCount == "ARRAY") then {_groupCount = selectRandom _groupCount};

// Loop to spawn groups
for "_a" from 1 to _groupCount do {
	// Spawning group

	//Side selection, allowing for randomization
	_groupSide = east;
	if (typeName _groupSideParam == "ARRAY") then {_groupSide = selectRandom _groupSideParam} else {_groupSide = _groupSideParam};
	_faction = "";
	if (typeName _groupFactionParam == "ARRAY") then {_faction = selectRandom _groupFactionParam} else {_faction = _groupFactionParam};
	_menType = "";
	if (typeName _menTypeParam == "ARRAY") then {_menType = selectRandom _menTypeParam} else {_menType = _menTypeParam};
	
	_hash = switch (_groupSide) do {
		case east: {eastHash};
		case resistance: {indHash};
		case civilian: {civHash};
		default {eastHash};  //If side isn't recognized, default to the CSAT faction from the East hashmap.
	};

	

	//Array containing nested arrays of unit types belonging to a specific faction within a specific side (east or independent). The hash maps are initialized as public variables on the Server machine
	_factionArray = switch (_faction) do {
		case "RANDOM": {_key = (selectRandom keys _hash);_hash get _key};
		default {_hash get _faction;};
	};

	//Get unit classnames for different types of infantry
    _menStandard = [];
	_menRecon = [];
	_menSpecial = [];
    _unitArray = [];

    if (_groupSide == civilian) then {
        _unitArray = _factionArray select 0;
    } else {
        _menStandard = _factionArray select 0;
        _menRecon = _factionArray select 1;
		if (count _menRecon == 0) then {_menRecon = _menStandard};
        _menSpecial = _factionArray select 2;
		if (count _menSpecial == 0) then {_menSpecial = _menRecon};

        //Pre-select classnames based on menType parameter
        _unitArray = switch (_menType) do {
            case "STANDARD": {_menStandard};
            case "RECON": {_menRecon};
            case "SPECIAL": {_menSpecial};
            default {selectRandom [_menStandard, _menRecon, _menSpecial];}; //Pre-select randomly if unspecified
        };
    };
	

	_spawnPos = [[[_targetPos,_maxRadius]], ["water",[_targetPos, _minRadius]]] call BIS_fnc_randomPos; //Finds random position near the target position for spawning of the units. Max radius determines the farthest distance from target for spawning, while Min. radius determines the closest.
	_spawnPos = [_spawnPos select 0, _spawnPos select 1, 0];  //Ensures that the Z coordinate is 0 in order to spawn the units on the ground.
	if (_spawnPos select 0 == 0 and _spawnPos select 1 == 0) exitWith {_allEnemies};  //If a proper spawn position could not by found by BIS_fnc_randomPos it returns [0,0,0]. In that case, we exit the function without any units spawned.


	_group = createGroup [_groupSide, true];
	_groupId = [format ["%1_%2",_groupName,_a]];
	_group setGroupIdGlobal _groupId;

	_unitsAmount = _unitCount;
	if (typeName _unitCount == "ARRAY") then {_unitsAmount = selectRandom _unitCount};

	// Adding units to group
	for "_b" from 1 to _unitsAmount do {
		_unitType = if (_b == 1) then {_unitArray select 0;} else {(selectRandom _unitArray)}; // The if statement ensures that the first unit spawned is the first classname in the unit array. The first classname for men is always a Squad Leader type unit.
		_unit = _group createUnit [_unitType,_spawnPos, [], 2, "NONE"]; // Spawn a unit within 2 meters of the spawn position, with no spawn markers and no special states
		_allEnemies pushBack _unit;
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

	_wpType = "MOVE";
	if (typeName _type == "ARRAY") then {_wpType = selectRandom _type} else {_wpType = _type};
	switch _wpType do {
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
			[_group, _spawnPos, _radius] call BIS_fnc_taskPatrol;
			_group setCombatMode _combatMode;
			_group setBehaviour _behaviour;
		};
		//Patrol Roads: Creates a patrol pattern for the group based on roads within the radius of it's spawn position. Logic works the same for Men and Vehicles.
		case "PATROL_ROADS":
		{
			_roadsAround = _spawnPos nearRoads _radius;
			_increase = 100;
			while {count _roadsAround <10} do 
			{
				_roadsAround = _spawnPos nearRoads (_radius + increase);
				_increase = _increase + 100;
			};
			for "_x" from 0 to 6 do {
				_currentWaypoint = _group addWaypoint [getPos selectRandom _roadsAround, 0];
				_currentWaypoint setWaypointCompletionRadius 10;
				if (_x == 6 ) then {
					_wp = _group addWaypoint [(getPos (selectRandom _roadsAround)), 0];
					_wp setWaypointCompletionRadius 10;
					_wp setWaypointType "CYCLE";
				};
				_group setCombatMode _combatMode;
				_group setBehaviour _behaviour;
			};
		};
	};

	// Set dynamic simulation
	_group enableDynamicSimulation _sim;
};

// Make all units in spawned groups editable by curators
{[_x, [_allEnemies, true]] remoteExecCall ["addCuratorEditableObjects", 0];} forEach allCurators;

// Returning list of all spawned enemies
_allEnemies;

