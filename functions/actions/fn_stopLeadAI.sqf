params ["_target","_groupOld"];

[_target,["Stop Leading",{_target = _this select 0;[_target] joinSilent (_this select 3);_target disableAI "PATH";[_target, ""] remoteExec ["switchMove"];[_target,(_this select 2)] remoteExecCall ["removeAction",0] ; [_target] call CO_fnc_leadAI;},_groupOld,0,true,true,"","_this distance _target <= 2 && alive _target"]] remoteExecCall ["addAction",0]; 
