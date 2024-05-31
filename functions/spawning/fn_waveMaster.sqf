params ["_target","_task","_side","_faction", "_waveCount", "_waveSize", "_waveDistance", "_waveGroupSize", "_waveType","_waveDuration"];

_wpType = switch typeName _target do 
{
	case "ARRAY": {"SAD"};
	case "OBJECT": {"DESTROY"};
};


_i = 0;

while {_i < _waveCount} do
{
	_groupName = format ["%1_%2_ATTACKER", _task, _i];
	_onActivation = format ["[['%1', %2, '%3', %4, '%5',[''],['']], %6, %7, %8, '%9', %10, '%11', '%12', '%13','','', %14, %15] call CO_fnc_enemyAssault; deleteVehicle thisTrigger", _wpType, 50, "YELLOW", _target, "AWARE", _waveDistance - 50, _waveDistance + 50, _waveSize, _groupName, _side, _faction, _waveType, 'STANDARD', _waveGroupSize, false];
	_wave = createTrigger ["EmptyDetector", _target];
	_wave setTriggerArea [0, 0, 0, false];
	_wave setTriggerTimeout [_waveDuration * _i, _waveDuration * _i, _waveDuration * _i, false];
	_wave setTriggerStatements ["true",_onActivation,""];
	_i = _i + 1;
};
