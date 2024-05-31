params ["_type", "_side", "_faction","_groupName","_position"];

if (_type == "random" || _type == "RANDOM") then {
   _type = selectRandom ["Base_01_Wes", "Base_02_Wes"];
};

_enemies = [];

_fobBase = [_type, _position, random 360, true, false] call CO_fnc_spawnComposition;

_enemiesOnArrows = [_position, east, format ["arrowedGroup_%1", _groupName], _faction] call CO_fnc_garrisonArrows;

_groupIterator = 0;
{
  _enemies_garrisoned = [_x, _side, format ["garrisonedGroup_%1_%2", _groupName, _groupIterator], 0 + random 7, _faction, "STANDARD"] call CO_fnc_garrisonBuilding;
  _groupIterator = _groupIterator + 1;
  _enemies append _enemies_garrisoned;
} forEach _fobBase;

_enemies_patrol = [["PATROL", selectRandom [10, 25, 50, 80, 125, 250], "YELLOW", _position, "SAFE", [""], [""]], 50 , 200, 3 + random 3, "patrolGroup_" + _groupName, _side, _faction, "MEN", "STANDARD", "AAPLANE", "CAR", selectRandom [4, 5, 6],"STAG COLUMN",true] call CO_fnc_enemyAssault;
_enemies append _enemies_patrol;
_enemies append _enemiesOnArrows;

[_enemies, _fobBase];
