[officerInf,
 "Request Mission",
 "\a3\ui_f_orange\data\displays\rscdisplayorangechoice\faction_nato_ca.paa",
 "\a3\ui_f_orange\data\displays\rscdisplayorangechoice\faction_nato_ca.paa",
 "_this distance _target < 2",
 "_caller distance _target < 2",
 {}, //Action started
 {},
 {//Action completed
   ["infantry"] spawn CO_fnc_missionGiversGui;
   _target sideChat selectRandom ["Here's a mission for you.","I've got one for you.","You're needed for this task!"];
 },
 {},//Action cancelled
 [],
 1,
 10,
 false,
 false
] call BIS_fnc_holdActionAdd;
[officerSf,
 "Request Mission",
 "\a3\ui_f_orange\data\displays\rscdisplayorangechoice\faction_nato_ca.paa",
 "\a3\ui_f_orange\data\displays\rscdisplayorangechoice\faction_nato_ca.paa",
 "_this distance _target < 2",
 "_caller distance _target < 2",
 {}, //Action started
 {},
 {//Action completed
   ["special"] spawn CO_fnc_missionGiversGui;
   _target sideChat selectRandom ["Here's a mission for you.","I've got one for you.","You're needed for this task!"];
 },
 {},//Action cancelled
 [],
 1,
 10,
 false,
 false
] call BIS_fnc_holdActionAdd;
[officerRecon,
 "Request Mission",
 "\a3\ui_f_orange\data\displays\rscdisplayorangechoice\faction_nato_ca.paa",
 "\a3\ui_f_orange\data\displays\rscdisplayorangechoice\faction_nato_ca.paa",
 "_this distance _target < 2",
 "_caller distance _target < 2",
 {}, //Action started
 {},
 {//Action completed
   ["recon"] spawn CO_fnc_missionGiversGui;
   _target sideChat selectRandom ["Here's a mission for you.","I've got one for you.","You're needed for this task!"];
 },
 {},//Action cancelled
 [],
 1,
 10,
 false,
 false
] call BIS_fnc_holdActionAdd;

addMissionEventHandler ["draw3D",  
{if (player distance position officerInf <= 30) then {
_k = 10 / (player distance position officerInf);
 drawIcon3D  
 [ 
  "\a3\modules_f\data\portraitstrategicmaporbat_ca.paa", 
  [[0,0.3,0.6,1],[1,1,1,1]], 
  getPosATL officerInf vectorAdd [0,0,2], 
  1 * _k, 
  1 * _k, 
  0, 
  "General missions", 
  1, 
  0.025 * _k, 
  "PuristaMedium", 
  "center"
 ];};
 if (player distance position officerRecon <= 30) then {
_k = 10 / (player distance position officerInf);
 drawIcon3D  
 [ 
  "\a3\modules_f\data\portraitstrategicmaporbat_ca.paa", 
  [[0,0.3,0.6,1],[1,1,1,1]], 
  getPosATL officerRecon vectorAdd [0,0,2], 
  1 * _k, 
  1 * _k, 
  0, 
  "Recon missions", 
  1, 
  0.025 * _k, 
  "PuristaMedium", 
  "center"
 ];};
 if (player distance position officerSf <= 30) then {
_k = 10 / (player distance position officerInf);
 drawIcon3D  
 [ 
  "\a3\modules_f\data\portraitstrategicmaporbat_ca.paa", 
  [[0,0.3,0.6,1],[1,1,1,1]], 
  getPosATL officerSf vectorAdd [0,0,2], 
  1 * _k, 
  1 * _k, 
  0, 
  "Special missions", 
  1, 
  0.025 * _k, 
  "PuristaMedium", 
  "center"
 ];};
 
}];
