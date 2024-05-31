player selectDiarySubject "Command Ops: Introduction";
{[_x,[[player],true]] remoteExecCall ["addCuratorEditableObjects",0]} forEach allCurators;
leader player synchronizeObjectsAdd [support_req];

if (COAllowAmbience) then {
	player setVariable ["hasDied",false];
	[player,false] spawn CO_fnc_ambientUnits;
	[player,false] spawn CO_fnc_ambientVehicles;
};
//playMusic selectRandom ["LeadTrack01c_F","LeadTrack01_F_EPA","LeadTrack02a_F_EPA","LeadTrack01a_F_EXP","EventTrack02a_F_EPA","EventTrack01_F_EPA"];