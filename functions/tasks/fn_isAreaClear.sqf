//Creates a trigger that checks if there are no units present. Executes code passed to it if true.
params ["_onClear", "_center", "_side", "_radius"];



_isClear = createTrigger ["EmptyDetector", _center];
_isClear setTriggerArea [_radius, _radius, 0, false];
_isClear setTriggerTimeout [30, 30, 30, true];
_isClear setTriggerActivation [str _side, "NOT PRESENT", false];
_isClear setTriggerStatements ["this",_onClear,""];
