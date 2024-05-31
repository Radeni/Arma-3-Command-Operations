params ["_object"];


_particleSource = "#particlesource" createVehicle position _object;
[_particleSource,[1, [0.1, 0.1, 0.5]]] remoteExecCall ["setParticleCircle",0,true];
[_particleSource,[0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 1], 0, 0]] remoteExecCall ["setParticleRandom",0,true];
[_particleSource,[["\A3\data_f\ParticleEffects\Universal\smoke.p3d", 1, 0, 1], "", "Billboard", 1, 70, [0, 0, 0], [0, 0, 1], 0.6, 9.24, 7.5, 0.75, [1.5, 2, 4], [[0, 0, 0, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.1], 10, 0.5, "", "", _object]] remoteExecCall ["setParticleParams",0,true];
[_particleSource,0.01] remoteExecCall ["setDropInterval",0,true];

_object setVariable ["smoke",_particleSource];
_particleSource;

