params ["_position","_garbage"];

_collector = createTrigger ["EmptyDetector", _position];
_collector setVariable ["garbage",_garbage];
_isClear setTriggerArea [500, 500, 0, false];
_isClear setTriggerTimeout [0, 0, 0, true];
_isClear setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_isClear setTriggerStatements ["!this","{deleteVehicle _x} forEach (thisTrigger getVariable 'garbage');",""];



