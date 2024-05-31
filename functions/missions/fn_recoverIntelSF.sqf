params ["_enemySide", "_faction"];

_garbage = [];

_BasePosArea = [0,0,0];
_BasePos  = [0,0,0];

while {_BasePos select 0 == 0 && _BasePos select 1 == 0} do
{
	_BasePosArea = [nil, ["water","base_radius",[getMarkerPos "base_radius", 1500]]] call BIS_fnc_randomPos;
	sleep 1;
	_BasePos = [_BasePosArea, 0, 1000, 55, 0, 0.18, 0,[],[[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
};

_intelTask = ["recoverIntelSF", _BasePos] call CO_fnc_taskCreator;

_fobBase = ["random", _enemySide, _faction, format["%1_stealIntel", _intelTask], _BasePos] call CO_fnc_fobBase;

_enemies_patrol = [["PATROL", 300, "RED", _BasePos, "SAFE", [""], [""]], 20, 400, 4 + round random 4, "patrolGroup_" + _intelTask, _enemySide, _faction, "MEN", ["STANDARD","RECON","SPECIAL"], "AAPLANE", "CAR", [4,5,6,7,8],["STAG COLUMN","COLUMN"],true] call CO_fnc_enemyAssault;
_garbage append _enemies_patrol;

_baseAreaZone = [_intelTask,"zone",_BasePos,"ELLIPSE","Border",format ["Color%1",_enemySide],1,[400,400]] call CO_fnc_createMarker;

_allArrows = [];
_baseArrows = [];
{

  if(typeOf _x == "Sign_Arrow_Yellow_F"||typeOf _x == "Sign_Arrow_Blue_F"||typeOf _x == "Sign_Arrow_Cyan_F"||typeOf _x == "Sign_Arrow_Large_Blue_F") then {
		 _allArrows append [_x];
	};

	if(typeOf _x == "Sign_Arrow_Yellow_F") then {
			_baseArrows append [_x];
	};
} forEach (_fobBase select 1);

_intelPos = getPosATL selectRandom _baseArrows;

_table = createVehicle ["Land_CampingTable_F", _intelPos, [], 0, "CAN_COLLIDE"];
[_table] remoteExecCall ["disableCollisionWith", 0, "Building"];
[_table] remoteExecCall ["disableCollisionWith", 0, "Land_MultiScreenComputer_01_olive_F"];
[_table] remoteExecCall ["disableCollisionWith", 0, "Land_Computer_01_olive_F"];
sleep 1;
_table enableSimulation false;
_tablePos = getPosATL _table;
_computer = createVehicle ["Land_MultiScreenComputer_01_olive_F", [(_tablePos select 0) + 0.0263672 , (_tablePos select 1) + -0.0078125, (_tablePos select 2) + 0.915598], [], 0, "CAN_COLLIDE"];
[_computer] remoteExecCall ["disableCollisionWith", 0, "Land_Computer_01_olive_F"];
[_computer] remoteExecCall ["disableCollisionWith", 0, "Land_CampingTable_F"];
sleep 1;
_computer enableSimulation false;
_computerBox = createVehicle ["Land_Computer_01_olive_F", [(_tablePos select 0) - 0.616797 , (_tablePos select 1) - 0.075, (_tablePos select 2) + 0.915598], [], 0, "CAN_COLLIDE"];
[_computerBox] remoteExecCall ["disableCollisionWith", 0, "Land_CampingTable_F"];
[_computerBox] remoteExecCall ["disableCollisionWith", 0, "Land_MultiScreenComputer_01_olive_F"];
sleep 1;
_computerBox enableSimulation false;
{_x addCuratorEditableObjects [[_table],true];} forEach allCurators;

{
	deleteVehicle _x;
} forEach _allArrows;

_garbage append (_fobBase select 0);
_garbage append (_fobBase select 1);
_garbage append [_computer, _table, _computerBox];

_reinforcementsInfil = [[[_intelPos, 600]],[]] call BIS_fnc_randomPos;
_reinforcementsSpawnPos =  [[[_intelPos, 3000]],[]] call BIS_fnc_randomPos;

_computer setVariable ["positionReinforcements", _intelPos,true];
_computer setVariable ["positionReinforcementsInfil", _reinforcementsInfil,true];
_computer setVariable ["positionReinforcementsSpawn", _reinforcementsSpawnPos,true];
_computer setVariable ["taskID", _intelTask,true];
_computer setVariable ["garbage", _garbage,true];
_computer setVariable ["reinforcementsCalled", false,true];
_computer setVariable ["areaMark", _baseAreaZone,true];

[_computer,
 "Hack computer",
 "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa",
 "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa",
 "_this distance _target < 2",
 "_caller distance _target < 2",
 {
	_caller switchMove "Acts_Accessing_Computer_Loop";
	_target setObjectTextureGlobal [1,"a3\structures_f_epc\items\electronics\data\electronics_screens_laptop_device_co.paa"];
	_target setObjectTextureGlobal [2,"a3\missions_f_oldman\data\img\screens\csatntb_co.paa"];
	_target setObjectTextureGlobal [3,"a3\structures_f\items\electronics\data\electronics_screens_laptop_co.paa"];
	if(_target getVariable "reinforcementsCalled" == false) then {
		_enemies_reinforce = [_target getVariable "positionReinforcements",_target getVariable "positionReinforcementsInfil","FLY_IN",_target getVariable "positionReinforcementsSpawn","O_Heli_Transport_04_bench_F",["O_V_Soldier_TL_hex_F","O_V_Soldier_JTAC_hex_F", "O_V_Soldier_M_hex_F", "O_V_Soldier_Exp_hex_F", "O_V_Soldier_Exp_hex_F", "O_V_Soldier_LAT_hex_F", "O_V_Soldier_Medic_hex_F", "O_V_Soldier_JTAC_hex_F"],_target getVariable "taskID",str east, 1, _target getVariable "positionReinforcements",true,false,false] remoteExec ["CO_fnc_reinforcements",2];
		_target setVariable ["reinforcementsCalled", true,true];
	 };
 },
 {},
 {
   [_target getVariable "taskID", 'Succeeded'] remoteExec ["BIS_fnc_taskSetState",0,true];
   {_x addScore 30} forEach allPlayers;
	 _garbage = _target getVariable "garbage";
	 _garbage append (_target getVariable "additionalEnemies");
	 [(_target getVariable "positionReinforcements"),1500,_garbage,[(_target getVariable "areaMark")]] spawn CO_fnc_cleanup;
	_caller switchMove "";
	_target setObjectTextureGlobal [1,"#(argb,8,8,3)color(0,0,0,0.0,co)"];
	_target setObjectTextureGlobal [2,"#(argb,8,8,3)color(0,0,0,0.0,co)"];
	_target setObjectTextureGlobal [3,"#(argb,8,8,3)color(0,0,0,0.0,co)"];
	[_target,1 ] remoteExecCall ["BIS_fnc_holdActionRemove",0];
 },
 {
	_caller switchMove "";
	_target setObjectTextureGlobal [1,"#(argb,8,8,3)color(0,0,0,0.0,co)"];
	_target setObjectTextureGlobal [2,"#(argb,8,8,3)color(0,0,0,0.0,co)"];
	_target setObjectTextureGlobal [3,"#(argb,8,8,3)color(0,0,0,0.0,co)"];
},
 [],
 150,
 1,
 true,
 false
] remoteExec ["BIS_fnc_holdActionAdd", 0, _computer];


_intelTask;