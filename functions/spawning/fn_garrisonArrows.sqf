params ["_position", "_groupSide", "_nameGroup", "_groupFaction"];
private ["_position", "_groupSide", "_nameGroup", "_groupFaction", "_units"];

_csatGi = [
	"O_Soldier_TL_F",
  "O_engineer_F",
	"O_soldier_exp_F",
	"O_Soldier_A_F",
	"O_Soldier_AR_F",
	"O_medic_F",
	"O_Soldier_GL_F",
	"O_HeavyGunner_F",
	"O_soldier_M_F",
	"O_Soldier_F",
	"O_Soldier_LAT_F",
	"O_Soldier_HAT_F",
	"O_Soldier_lite_F",
	"O_Sharpshooter_F"
];

_syndikatGi = [
	"I_C_Soldier_Bandit_4_F",
	"I_C_Soldier_Bandit_1_F",
	"I_C_Soldier_Bandit_6_F",
	"I_C_Soldier_Bandit_5_F",
	"I_C_Soldier_Bandit_2_F",
	"I_C_Soldier_Bandit_3_F",
	"I_C_Soldier_Bandit_7_F",
	"I_C_Soldier_Para_7_F",
	"I_C_Soldier_Para_2_F",
	"I_C_Soldier_Para_3_F",
	"I_C_Soldier_Para_4_F",
	"I_C_Soldier_Para_6_F",
	"I_C_Soldier_Para_1_F",
	"I_C_Soldier_Para_5_F"
];

_units = switch _groupSide do {
	case east:{
      _csatGi
  };
  case resistance:{
      _syndikatGi
  };
  default{
      _csatGi
  };
};

_arrows = nearestObjects[_position, ["Sign_Arrow_Cyan_F"], 300];


_groupId = [format ["%1", _nameGroup]];
_group = createGroup [east, true];
_group setGroupIdGlobal _groupId;

{
  _unitType = selectRandom _units;
  _man = _group createUnit [_unitType, getPosATL _x, [], 0, "CAN_COLLIDE"];
	_man disableAI "PATH";
  deleteVehicle _x;
} forEach _arrows;

{_x addCuratorEditableObjects [units _group,true];} forEach allCurators;
_group enableDynamicSimulation true;
units _group;
