params ["_side","_groupName","_position","_faction"];


	_hash = switch (_side) do {
		case east: {eastHash};
		case resistance: {indHash};
		default {eastHash};  //If side isn't recognized, default to the CSAT faction from the East hashmap.
	};

	

	//Array containing nested arrays of unit types belonging to a specific faction within a specific side (east or independent). The hash maps are initialized as public variables on the Server machine
	_factionArray = _hash get _faction;
	//Get unit classnames for different types of infantry
  	_menStandard = _factionArray select 0;
	_menRecon = _factionArray select 1;
	if (count _menRecon == 0) then {_menRecon = _menStandard};
	

_leader = _menRecon select 0;
_man1 = selectRandom _menRecon;
_man2 = selectRandom _menRecon;
_manUav = selectRandom _menRecon;
_uavType = "";

switch _side do
{
	case EAST: {_uavType = "O_UAV_01_F";};
	case RESISTANCE: {_uavType = "I_UAV_01_F";};
};

_campSite = ["Camp_01_Rad",_position,random 360,true,false] call CO_fnc_spawnComposition;

_group = createGroup [_side,true];
_group setGroupIdGlobal [_groupName];
_group createUnit [_leader,_position,[],10,"NONE"];
_group createUnit [_man1,_position,[],10,"NONE"];
_group createUnit [_man2,_position,[],10,"NONE"];
_group createUnit [_manUav,_position,[],10,"NONE"];
_uav = createVehicle [_uavType,_position vectorAdd [0,0,100],[],25,"FLY"]; createVehicleCrew _uav; crew _uav join _group;
[_group, _position, 3] call BIS_fnc_taskPatrol;
[(units _group) + [_uav],_campSite];
