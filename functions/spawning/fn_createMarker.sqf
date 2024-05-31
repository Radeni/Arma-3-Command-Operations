params ["_name","_suffix","_position","_shape","_brush","_color","_alpha","_size"];


if (_alpha == nil) then {_alpha = 1;};

_markerName = format ["%1%2",_name,_suffix];
_marker = createMarker [_markerName,_position];
_marker setMarkerShape _shape;
_marker setMarkerColor _color;
_marker setMarkerSize _size;
_marker setMarkerBrush _brush;

_marker 