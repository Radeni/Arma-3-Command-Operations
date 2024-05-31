params ["_position","_range"];


_nearPlayers = [];

for "_i" from 0 to (count allPlayers) - 1 do
{
	_player = (allPlayers select _i);
	_distance = _position distance2D _player;
	if (_distance <= _range) then {_nearPlayers append [_player]};
};



_nearPlayers;