params ["_missionGroup","_type","_side","_faction"];

if (_side == "random") then 
{
	_side = selectRandom [east,resistance];
	if (_side == east && _faction == "random") then {_faction = "OPF_F"} else {_faction = selectRandom ["IND_F","IND_C_F"]};
};
switch _missionGroup do 
	{
		case "infantry":
		{
			if (_type == "random") then {_type = selectRandom [1,2,3];};
			switch _type do
			{
				case 1:
				{
					[_side,_faction] spawn CO_fnc_townClear;
				};
				case 2:
				{
					[_side,_faction] spawn CO_fnc_townDefend;
				};
				case 3:
				{
					[_side,_faction] spawn CO_fnc_sabotageCache;
				};
				default {systemChat "Unknown mission type."};
			};
		};
		case "recon":
		{
			if (_type == "random") then {_type = selectRandom [1,2,3,4];};
			switch _type do
			{
				case 1:
				{
					[_side,_faction] spawn CO_fnc_reconRescue;
				};
				case 2:
				{
					[_side,_faction] spawn CO_fnc_reconSabotage;
				};
				case 3:
				{
					[_side,_faction] spawn CO_fnc_reconSabotageArty;
				};
				case 4:
				{
					[_side,_faction] spawn CO_fnc_reconAntirecon;
				};
				default {systemChat "Unknown mission type."};
			};
		};
		case "SF":
		{
			if (_type == "random") then {_type = selectRandom [1]};
			switch _type do
			{
				case 1:
				{
					[_side,_faction] spawn CO_fnc_recoverIntelSF;
				};
				default {systemChat "Unknown mission type."};
			};
		};
		default {systemChat "Unknown mission group."};
	};