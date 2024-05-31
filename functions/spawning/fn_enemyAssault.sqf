params ["_wpParams","_minRadius","_maxRadius","_groupCount","_groupName","_groupSideParam","_groupFactionParam","_groupType","_menTypeParam","_airType","_groundType","_unitCountParam","_formationParam","_sim"];
private ["_target","_minRadius","_maxRadius","_groupCount","_groupName","_groupSideParam","_groupFactionParam","_groupType","_menTypeParam","_airType","_groundType","_unitCountParam","_a","_b","_air","_men","_ground","_wpParams"];
/*
Created by Rad on the 18th of March, 2019. Arma 3 version 1.90 
This function is a highly customizable script for creating an enemy force that will move into an area and/or attack a target
Params:
0. Waypoint params:
	Value: Array
		Array:
		0. Waypoint type:
			Value: String // https://community.bistudio.com/wiki/Waypoint_types Supported ones are "DESTROY", "SAD", "MOVE" and "PATROL" (Not a waypoint but activates a script for a patrol).
		1. Waypoint radius:
			Value: Number // Waypoint completion radius or distance between patrol waypoints. Patrol for group type "AIR" will make a Loiter waypoint instead with this set as loiter radius.
		2. Waypoint combat mode:
			Value: String // https://community.bistudio.com/wiki/Combat_Modes#Engagement_rules
		3. Waypoint target
			Value: 	Array // Position coordinates [x,y,z].
					Object // Object to be attacked
		4. Waypoint behaviour:
			Value: String // https://community.bistudio.com/wiki/setWaypointBehaviour
		5. (Optional) Patrol blacklist:
			Value: Array // Array of strings (Marker areas), Objects (Trigger areas), or Arrays (center, radius).
		6. (Optional)Loiter altitude and direction:
			Value: Array // Example: [altitude (number),"CIRCLE_L" or "CIRCLE"].
1. Min. Radius:
	Value: Number // Minimum spawn distance from target in meters
2. Max. Radius:
	Value: Number // Maximum spawn distance from target in meters
3. Group Count:
	Value: Number // Amount of groups spawned
4. Group Name:
	Value: String // Name used for group identification
5. (Optional) Group Side:
	Value: String // Can be WEST,EAST or RESISTANCE, civilians aren't supported
6. (Optional) Group Faction:
	Value: String // Classname of the faction from CfgFactionClasses
7. Group Type:
	Value: String // Can be "MEN", "GROUND" or "AIR". Determines if the group should be infantry, ground vehicle or aircraft.
8. (Optional) Men Type:
	Value: String // Can be "STANDARD", "RECON" or "SPECIAL". Determines if the infantry group should be of certain kind, i.e. (CSAT, CSAT Recon, Viper).
9. (Optional) Air Type:
	Value: String // Can be "AGPLANE", "AAPLANE","HELI" or "CASHELI". Determines if the aircraft should be of certain kind.
10. (Optional) Ground Type:
	Value: String // Can be "CAR", "APC" or "TANK". Determines if the vehicle should be of certain kind.
11. Unit Count:
	Value: Number // Amount of units spawned per group.
12. Formation:
	Value: String // Which formation should the group be put in.
13. Dynamic Simulation:
	Value: Bool // Whether or not to enable dynamic symulation on the units.

Example of calling the function:
    enemies = [["SAD", 10, "YELLOW", TESTCAR, "SAFE", [""], [5, "CIRCLE_L"]], 400, 700, 12, "SPANEER", EAST, "OPF_F", "MEN", "RECON", "AAPLANE", "CAR", 3, "COLUMN", true] call CO_fnc_enemyAssault; 

*/		

//List of soldiers, vehicles and aircraft used to determine what to spawn based on function call parameters 
_csatGi = ["O_Soldier_TL_F","O_engineer_F","O_soldier_exp_F","O_Soldier_A_F","O_Soldier_AR_F","O_medic_F","O_Soldier_GL_F","O_HeavyGunner_F","O_soldier_M_F","O_Soldier_F","O_Soldier_LAT_F","O_Soldier_HAT_F","O_Soldier_lite_F","O_Sharpshooter_F"];
_csatRecon = ["O_recon_TL_F","O_recon_F","O_recon_M_F","O_recon_medic_F","O_Pathfinder_F","O_recon_JTAC_F","O_recon_LAT_F"];
_csatSf = ["O_V_Soldier_TL_hex_F","O_V_Soldier_LAT_hex_F","O_V_Soldier_Medic_hex_F","O_V_Soldier_hex_F","O_V_Soldier_M_hex_F","O_V_Soldier_JTAC_hex_F","O_V_Soldier_Exp_hex_F"];
_aafGi = ["I_Soldier_TL_F","I_Soldier_A_F","I_Soldier_AR_F","I_medic_F","I_engineer_F","I_Soldier_exp_F","I_Soldier_GL_F","I_Soldier_M_F","I_Soldier_LAT_F","I_Soldier_LAT2_F","I_soldier_F"];
_syndikatGi = ["I_C_Soldier_Bandit_4_F","I_C_Soldier_Bandit_1_F","I_C_Soldier_Bandit_6_F","I_C_Soldier_Bandit_5_F","I_C_Soldier_Bandit_2_F","I_C_Soldier_Bandit_3_F","I_C_Soldier_Bandit_7_F","I_C_Soldier_Para_7_F","I_C_Soldier_Para_2_F","I_C_Soldier_Para_3_F","I_C_Soldier_Para_4_F","I_C_Soldier_Para_6_F","I_C_Soldier_Para_1_F","I_C_Soldier_Para_5_F"];
_csatCar = ["O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_LSV_02_AT_F","O_LSV_02_armed_F"];
_csatApc = ["O_APC_Tracked_02_cannon_F","O_APC_Wheeled_02_rcws_v2_F"];
_csatTank = ["O_MBT_02_cannon_F","O_MBT_04_cannon_F","O_MBT_04_command_F"];
_aafCar = ["I_MRAP_03_gmg_F","I_MRAP_03_hmg_F"];
_aafApc = ["I_APC_Wheeled_03_cannon_F","I_APC_tracked_03_cannon_F","I_LT_01_AT_F","I_LT_01_cannon_F"];
_aafTank = ["I_MBT_03_cannon_F"];
_syndikatCar = ["I_C_Offroad_02_AT_F","I_C_Offroad_02_LMG_F"];
_civCars = [
    "C_Hatchback_01_F",
    "C_Van_01_fuel_F",
    "C_Offroad_02_unarmed_F",
    "C_SUV_01_F",
    "C_Offroad_01_F",
    "C_Tractor_01_F",
    "C_Van_01_transport_F",
    "C_Van_01_box_F",
    "C_Van_02_medevac_F",
    "C_Van_02_service_F",
    "C_Van_02_transport_F",
    "C_Truck_02_transport_F",
    "C_Truck_02_box_F",
    "C_Offroad_01_comms_F",
    "C_Offroad_01_repair_F",
    "C_IDAP_Truck_02_F",
    "C_Offroad_01_covered_F",
    "C_IDAP_Truck_02_water_F",
    "C_IDAP_Truck_02_transport_F",
    "C_IDAP_Van_02_vehicle_F",
    "C_IDAP_Offroad_01_F",
    "C_IDAP_Offroad_02_unarmed_F"
];

_allEnemies = [];
for "_a" from 1 to _groupCount do 
{
	_type = _wpParams select 0;
	if (typeName _type == "ARRAY") then {_type = selectRandom _type;};
	_radius = _wpParams select 1;
	_combatMode = _wpParams select 2;
	_behaviour = _wpParams select 4;
	_target = _wpParams select 3;
	_loiteralt = ((_wpParams select 6) select 0);
	_targetPos = switch (typeName _target) do 
	{
		case "OBJECT": {getPos _target};
		case "ARRAY": {_target};
	};
	_spawnPos = [[[_targetPos,_maxRadius]], ["water",[_targetPos, _minRadius]]] call BIS_fnc_randomPos;
	_spawnPos = [_spawnPos select 0, _spawnPos select 1, 0];
	if (_spawnPos select 0 == 0 and _spawnPos select 1 == 0) exitWith {_allEnemies};
	_groupId = [format ["%1_%2",_groupName,_a]];
	_group = grpNull;
	_groupSide = east;
	if (typeName _groupSideParam == "ARRAY") then {_groupSide = selectRandom _groupSideParam} else {_groupSide = _groupSideParam};
	_group = createGroup [_groupSide, true];
	_group setGroupIdGlobal _groupId;
	_unitCount = 1;
	if (typeName _unitCountParam == "ARRAY") then {_unitCount = selectRandom _unitCountParam} else {_unitCount = _unitCountParam};
	_menType = "STANDARD";
	if (typeName _menTypeParam == "ARRAY") then {_menType = selectRandom _menTypeParam} else {_menType = _menTypeParam};
	_groupFaction = "";
	if (_groupFactionParam == "RANDOM") then 
	{
		switch _groupSide do
		{
			case east: {_groupFaction = selectRandom ["OPF_F"];};
			case resistance: {_groupFaction = selectRandom ["IND_F","IND_C_F"];};
		};
	} else {_groupFaction = _groupFactionParam};
	_men = switch _groupSide do 
	{
		case east:
		{
			switch _groupFaction do
			{
				case "OPF_F":
				{
					switch _menType do
					{
						case "STANDARD": {_csatGi};
						case "RECON": {_csatRecon};
						case "SPECIAL": {_csatSf};
						default {_csatGi};
					};
				};
				default {"OPF_F"};
			};
		};
		case resistance:
		{
			switch _groupFaction do
			{
				case "IND_F": {_aafGi};
				case "IND_C_F": {_syndikatGi};
				default {_aafGi};
			};
		};
		default 
		{
			switch _menType do
			{
				case "STANDARD": {_csatGi};
				case "RECON": {_csatRecon};
				case "SPECIAL": {_csatSf};
				default {_csatGi};
			};
		};
	};
	_ground = switch _groupSide do 
	{
		case east:
		{
			switch _groupFaction do
			{
				case "OPF_F":
				{
					switch _groundType do
					{
						case "CAR": {_csatCar};
						case "APC": {_csatApc};
						case "TANK": {_csatTank};
						default {_csatCar};
					};
				};
				default 
				{
					switch _groundType do
					{
						case "CAR": {_csatCar};
						case "APC": {_csatApc};
						case "TANK": {_csatTank};
						default {_csatCar};
					};
				};
			};
		};
		case resistance:
		{
			switch _groupFaction do
			{
				case "IND_F":
				{
					switch _groundType do
					{
						case "CAR": {_aafCar};
						case "APC": {_aafApc};
						case "TANK": {_aafTank};
						default {_aafCar};
					};
				};
				case "IND_C_F": {_syndikatCar};
				default 
				{
					switch _groundType do
					{
						case "CAR": {_aafCar};
						case "APC": {_aafApc};
						case "TANK": {_aafTank};
						default {_aafCar};
					};
				};
			};
		};
		case civilian:
		{
			switch _groundType do
			{
				case "CAR": {_civCars};
				default {_civCars};
			};
		};
		default 
		{
			switch _groundType do
			{
				case "CAR": {_csatCar};
				case "APC": {_csatApc};
				case "TANK": {_csatTank};
				default {_csatCar};
			};
		};
	};
	_air = switch _groupSide do 
	{
		case east:
		{
			switch _groupFaction do
			{
				case "OPF_F":
				{
					switch _airType do
					{
						case "AGPLANE": {["O_Plane_CAS_02_F","O_T_VTOL_02_infantry_hex_F"]};
						case "AAPLANE": {["O_Plane_Fighter_02_F"]};
						case "HELI": {["O_Heli_Transport_04_bench_F","O_Heli_Transport_04_covered_F","O_Heli_Light_02_unarmed_F"]};
						case "CASHELI": {["O_Heli_Attack_02_dynamicLoadout_F","O_Heli_Light_02_dynamicLoadout_F"]};
						default {["O_Heli_Attack_02_dynamicLoadout_F","O_Heli_Light_02_dynamicLoadout_F","O_T_VTOL_02_infantry_hex_F"]};
					};
				};
				default 
				{
					switch _airType do
					{
						case "AGPLANE": {["O_Plane_CAS_02_F","O_T_VTOL_02_infantry_hex_F"]};
						case "AAPLANE": {["O_Plane_Fighter_02_F"]};
						case "HELI": {["O_Heli_Transport_04_bench_F","O_Heli_Transport_04_covered_F","O_Heli_Light_02_unarmed_F"]};
						case "CASHELI": {["O_Heli_Attack_02_dynamicLoadout_F","O_Heli_Light_02_dynamicLoadout_F"]};
						default {["O_Heli_Attack_02_dynamicLoadout_F","O_Heli_Light_02_dynamicLoadout_F"]};
					};
				};
			};
		};
		case resistance:
		{
			switch _groupFaction do
			{
				case "IND_F":
				{
					switch _airType do
					{
						case "AGPLANE": {["I_Plane_Fighter_03_CAS_F"]};
						case "AAPLANE": {["I_Plane_Fighter_03_AA_F","I_Plane_Fighter_04_F"]};
						case "HELI": {["I_Heli_Transport_02_F"]};
						case "CASHELI": {["I_Heli_light_03_F"]};
						default {["I_Heli_light_03_F"]};
					};
				};
				default 
				{
					switch _airType do
					{
						case "AGPLANE": {["I_Plane_Fighter_03_CAS_F"]};
						case "AAPLANE": {["I_Plane_Fighter_03_AA_F","I_Plane_Fighter_04_F"]};
						case "HELI": {["I_Heli_Transport_02_F"]};
						case "CASHELI": {["I_Heli_light_03_F"]};
						default {["I_Heli_light_03_F"]};
					};
				};
			};
		};
		default 
		{
			switch _airType do
			{
				case "AGPLANE": {["O_Plane_CAS_02_F","O_T_VTOL_02_infantry_hex_F"]};
				case "AAPLANE": {["O_Plane_Fighter_02_F"]};
				case "HELI": {["O_Heli_Transport_04_bench_F","O_Heli_Transport_04_covered_F","O_Heli_Light_02_unarmed_F"]};
				case "CASHELI": {["O_Heli_Attack_02_dynamicLoadout_F","O_Heli_Light_02_dynamicLoadout_F"]};
				default {["O_Heli_Attack_02_dynamicLoadout_F","O_Heli_Light_02_dynamicLoadout_F"]};
			};
		};
	};
	for "_b" from 1 to _unitCount do 
	{
		switch _groupType do 
		{
			case "MEN": 
			{
				_unitType = if (_b == 1) then {_men select 0;} else {(selectRandom _men)};
				_unit = _group createUnit [_unitType,_spawnPos,[],2,"NONE"];
			};
			case "GROUND":
			{
				_vehPos = [_spawnPos, 0, 1000, 8, 0, 0, 0,[],[_spawnPos,[]]] call BIS_fnc_findSafePos;
				_unit = createVehicle [(selectRandom _ground),_vehPos,[],25,"NONE"];
				createVehicleCrew _unit;
				_allEnemies append [_unit];
				units group driver _unit join _group;
			};
			case "AIR":
			{	
				_airPos = [(_spawnPos select 0),(_spawnPos select 1),300];
				_unit = createVehicle [(selectRandom _air),_airPos,[],100,"FLY"];
				_allEnemies append [_unit];
				createVehicleCrew _unit;
				units group driver _unit join _group;
			};
			default
			{
				_unitType = if (_b == 1) then {_men select 0;} else {(selectRandom _men)};
				_unit = _group createUnit [_unitType,_spawnPos,[],2,"NONE"];
			};
		};
	};
	switch _type do
	{
		case "MOVE":
		{
			_wp = _group addWaypoint [_targetPos, 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointCombatMode _combatMode;
			_wp setWaypointCompletionRadius 3;
		};
		case "DESTROY":
		{
			_wp = _group addWaypoint [_targetPos, 0];
			_wp waypointAttachObject _target;
			_wp setWaypointType "DESTROY";
			_wp setWaypointCombatMode _combatMode;
			_wp setWaypointBehaviour _behaviour;
		};
		case "SAD":
		{
			_wp = _group addWaypoint [_targetPos, 0];
			_wp setWaypointType "SAD";
			_wp setWaypointCombatMode _combatMode;
			_wp setWaypointBehaviour _behaviour;
			_wp setWaypointCompletionRadius 1;
		};
		case "PATROL":
		{
			switch _groupType do
			{
				case "MEN":
				{
					[_group, _spawnPos, _radius] call BIS_fnc_taskPatrol;
					_group setCombatMode _combatMode;
					_group setBehaviour _behaviour;
				};
				case "GROUND":
				{
					[_group, _targetPos, _radius] call BIS_fnc_taskPatrol;
				};
				case "AIR":
				{
					_wp = _group addWaypoint [_targetPos, 10];
					_wp setWaypointType "LOITER";
					_wp setWaypointCombatMode _combatMode;
					_wp setWaypointBehaviour _behaviour;
					_wp setWaypointLoiterRadius _radius;
					_wp setWaypointLoiterType ((_wpParams select 6) select 1);
					{_x flyInHeightASL [_loiteralt, _loiteralt, 50];} forEach units _group;
				};
			};
		};
		case "PATROL_ROADS":
		{
			_roadsAround = _spawnPos nearRoads _radius;
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
		default {};
	};
	_formation = "COLUMN";
	if (typeName _formationParam == "ARRAY") then {_formation = selectRandom _formationParam} else {_formation = _formationParam};
	_group setFormation _formation;
	_group enableDynamicSimulation _sim;
	_allEnemies = _allEnemies + units _group;
};
{[_x, [_allEnemies,true]] remoteExecCall ["addCuratorEditableObjects",0];} forEach allCurators;
_allEnemies;