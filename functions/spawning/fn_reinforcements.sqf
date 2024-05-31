params ["_target","_infilPos","_insertionType","_startPos","_vehicle","_units","_task","_side", "_skill", "_cleanup_pos", "_cleanup" ,"_randomUnits", "_randomHelo"];


//_reinforcements = [[14461.5,16253.9,0],[14520.5,16055.8,0],"FLY_IN",[13285.1,14948.2,0],"O_Heli_Transport_04_bench_F",["O_V_Soldier_TL_hex_F","O_V_Soldier_JTAC_hex_F","O_V_Soldier_M_hex_F","O_V_Soldier_Exp_hex_F","O_V_Soldier_LAT_hex_F","O_V_Soldier_Medic_hex_F","O_V_Soldier_hex_F"],"Feggit", EAST] spawn CO_fnc_reinforcements;


_CSATunits = ['O_Soldier_TL_F', 'O_Soldier_SL_F', 'O_Soldier_F', 'O_Soldier_LAT_F', 'O_soldier_M_F', 'O_Soldier_TL_F', 'O_Soldier_AR_F', 'O_Soldier_A_F', 'O_medic_F', 'O_Soldier_F', 'O_Soldier_LAT_F', 'O_soldier_M_F', 'O_Soldier_TL_F', 'O_Soldier_AR_F', 'O_Soldier_A_F', 'O_medic_F'];
_CSAThelos = ["O_Heli_Transport_04_bench_F", "O_Heli_Light_02_dynamicLoadout_F", "O_Heli_Light_02_unarmed_F", "O_Heli_Transport_04_covered_F"];


_AAFUnits = ["I_Soldier_SL_F","I_soldier_F", "I_Soldier_LAT_F" ,"I_Soldier_M_F" ,"I_Soldier_TL_F" ,"I_Soldier_AR_F" , "I_Soldier_A_F", "I_medic_F", "I_Soldier_SL_F", "I_soldier_F", "I_Soldier_LAT_F" ,"I_Soldier_M_F" ,"I_Soldier_TL_F" ,"I_Soldier_AR_F" , "I_Soldier_A_F", "I_medic_F"];
_AAFhelos = ["I_Heli_Transport_02_F", "I_Heli_light_03_unarmed_F"];

systemChat _side;

_group = "";
switch(_side) do {
	case "EAST": {
		_group = createGroup [east,true];
	};
	default {
		_group = createGroup [resistance,true];
	};
};

_group setGroupIdGlobal [_task + "_reinforcements"];

switch _insertionType do
{
	case "RUN_IN":
	{
	   {_unit = _group createUnit [_x,_startPos,[],2,"NONE"];} forEach _units;
		_wp = _group addWaypoint [_target, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointCombatMode "RED";
		_wp setWaypointCompletionRadius 3;
		_wp setWaypointStatements ["true",format ["[group this, %1, 100] call BIS_fnc_taskPatrol;",_target]];
	};
	case "FLY_IN":
	{
		if(_randomHelo) then {
			switch(_side) do {
				case "EAST": {
					_vehicle = selectRandom _CSAThelos;
					_units = _CSATunits;
				};
				default {
					_vehicle = selectRandom _AAFhelos;
					_units = _AAFUnits;
				};
			};
		}; 
		_insertionVehicle = createVehicle [_vehicle,_startPos vectorAdd [0,0,150],[],100,"FLY"];
		
		
		_pilot = "";
		switch(_side) do {
			case "EAST": {
				_pilot = (createGroup [east,true]) createUnit ["O_HeliPilot_F",_startPos,[],2,"NONE"];
				_pilot moveInDriver _insertionVehicle;
			};
		    default {
				_pilot = (createGroup [resistance,true]) createUnit ["I_pilot_F",_startPos,[],2,"NONE"];
				_pilot moveInDriver _insertionVehicle;
			};
		};
		_totalSeats = [_vehicle, true] call BIS_fnc_crewCount;
		_crewSeats = [_vehicle, false] call BIS_fnc_crewCount; 

		_seatCount = _totalSeats - _crewSeats;
		
		for "_x" from 1 to _seatCount do {
			_unit = _group createUnit [selectRandom _units,_startPos,[],2,"NONE"];
      		_unit setSkill _skill;
			_unit moveInCargo _insertionVehicle;
		};
		_wpInserion1 = group _pilot addWaypoint [_infilPos, 0];
		_wpInserion1 setWaypointType "TR UNLOAD";
		_wpInserion2 setWaypointCompletionRadius 1;
		_wpInserion2 = group _insertionVehicle addWaypoint [[5550,5550,0], 0];
		_wpInserion2 setWaypointType "MOVE";
		_wpInserion2 setWaypointCompletionRadius 50;
		_wpInserion2 setWaypointStatements ["true","deleteVehicle (vehicle this); deleteVehicle this"];
		_wp = _group addWaypoint [_target, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointCompletionRadius 10;
		_wp setWaypointStatements ["true",format ["[group this, %1, 150] call BIS_fnc_taskPatrol;",_target]];
		{_x addCuratorEditableObjects [(crew _insertionVehicle) + [_insertionVehicle],true];} forEach allCurators;
	};
};

{_x addCuratorEditableObjects [(units _group),true];} forEach allCurators;

if(_cleanup) then {
    [_cleanup_pos, 1500, units _group, []] spawn CO_fnc_cleanup;
};


units _group;
