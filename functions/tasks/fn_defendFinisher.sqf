params ["_duration","_target","_radius","_task","_side"];


_title = "Clear the remaining attackers";
_description = "The enemy attack is almost over. Clear out the remaining enemies!";

hint typeName _task;

_onActivation = format ["['%1', ['%2', '%3','']] call BIS_fnc_taskSetDescription; ['%1', %4, %5, %6] call CO_fnc_isAreaClear; deleteVehicle thisTrigger;", _task, _description, _title, _target, _side, _radius];

_wavesDone = createTrigger ["EmptyDetector", _target];
_wavesDone setTriggerTimeout [_duration * 60, _duration * 60, _duration * 60, false];
_wavesDone setTriggerStatements ["true",_onActivation,""];

