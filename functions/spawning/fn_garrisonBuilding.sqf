params ["_building", "_groupSideParam", "_nameGroup", "_unitCount", "_groupFactionParam", "_menTypeParam"];
private["_building", "_groupSide", "_groupFaction", "_menType", "_units", "_group", "_nameGroup", "_unitType", "_unitCount", "_positionCount"];
/* Created by Broken_Algorithm on the 13/11/2019. Arma 3 version 1.96
This function spawns an enemy group of a chosen side, group, groupsize and faction in a building.
Params:
0. Building:
    Value: Building position array or Building Object
1. Group side
    Value: String // Can be WEST,EAST or RESISTANCE, civilians aren't supported
2. Group Name:
    Value: String // Name used for group identification MUST BE UNIQUE!!!
3. Unit Count:
    Value: Integer // Amount of units to be spawned in building
4. Group Faction:
	Value: String // Classname of the faction from CfgFactionClasses
5. Men Type:
	Value: String // Can be "STANDARD", "RECON" or "SPECIAL". Determines if the infantry group should be of certain kind, i.e. (CSAT, CSAT Recon, Viper).

Example of calling the function:
    enemies = [buildingObject/[buildingLocation], EAST, "WIDOW_1", 5, "OPF_F", "RECON"] call CO_fnc_garrisonBuilding.sqf;
*/


_targetBuilding = switch (typeName _building) do {
    case "ARRAY":{
		nearestBuilding _building
	};
	default{
		_building
	};
};

//Side selection, allowing for randomization
	_groupSide = east;
	if (typeName _groupSideParam == "ARRAY") then {_groupSide = selectRandom _groupSideParam} else {_groupSide = _groupSideParam};
	_faction = "";
	if (typeName _groupFactionParam == "ARRAY") then {_faction = selectRandom _groupFactionParam} else {_faction = _groupFactionParam};
	_menType = _menTypeParam;
	if (typeName _menTypeParam == "ARRAY") then {_menType = selectRandom _menTypeParam};
	
	_hash = switch (_groupSide) do {
		case east: {eastHash};
		case resistance: {indHash};
		case civilian: {civHash};
		default {eastHash};  //If side isn't recognized, default to the CSAT faction from the East hashmap.
	};

	

	//Array containing nested arrays of unit types belonging to a specific faction within a specific side (east or independent). The hash maps are initialized as public variables on the Server machine
	_factionArray = switch (_faction) do {
		case "RANDOM": {_key = (selectRandom keys _hash); _hash get _key};
		default {_hash get _faction;};
	};

	//Get unit classnames for different types of infantry
    _menStandard = [];
	_menRecon = [];
	_menSpecial = [];
    _units = [];

    if (_groupSide == civilian) then {
        _units = _factionArray select 0;
    } else {
        _menStandard = _factionArray select 0;
        _menRecon = _factionArray select 1;
		if (count _menRecon == 0) then {_menRecon = _menStandard};
        _menSpecial = _factionArray select 2;
		if (count _menSpecial == 0) then {_menSpecial = _menRecon};

        //Pre-select classnames based on menType parameter
        _units = switch (_menType) do {
            case "STANDARD": {_menStandard};
            case "RECON": {_menRecon};
            case "SPECIAL": {_menSpecial};
            default {selectRandom [_menStandard, _menRecon, _menSpecial];}; //Pre-select randomly if unspecified
        };
    };

_groupId = [format ["%1", _nameGroup]];
_group = createGroup [_groupSide, true];
_group setGroupIdGlobal _groupId;

_positionsInBuilding = _targetBuilding buildingPos -1;
_positionCount = count _positionsInBuilding;

if (_unitCount > _positionCount || _unitCount <= 0) then {
    _unitCount = _positionCount;
};

for "_positionIndex" from 1 to _unitCount do{
    _unitType = selectRandom _units;
	_posInHouse = selectRandom _positionsInBuilding;
	_positionsInBuilding deleteAt (_positionsInBuilding find _posInHouse);
	_man = _group createUnit [_unitType, _posInHouse, [], 0, "CAN_COLLIDE"];
	_man disableAI "PATH";
};
{_x addCuratorEditableObjects [units _group,true];} forEach allCurators;
_group enableDynamicSimulation true;
units _group;