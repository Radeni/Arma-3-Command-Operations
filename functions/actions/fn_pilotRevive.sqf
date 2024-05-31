params ["_target","_caller"];
_caller playAction "medicStop";_target playAction "agonyStop"; _target setCaptive false; _target enableAI "MOVE"; _target disableAI "PATH"; _target call CO_fnc_leadAI;