params ["_position"];


_distances = [];

for "_i" from 0 to (count allPlayers) - 1 do
{
	_distance = _position distance2D (allPlayers select _i);
	_distances = _distances + [_distance];
};

_nearestPlayer = allPlayers select (_distances find (selectMin _distances));

_nearestPlayer;