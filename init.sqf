0 = player createDiarySubject ["Command Ops", "Command Ops"];

0 = player createDiaryRecord ["Command Ops", ["Vehicle customization", "All of your vehicles can be customized at any of the <font color='#FFD700' size='16' face=''>vehicle depots, </font> as well as at the aircraft <marker name='marker_4'>service station.</marker> <br></br><br></br>
There are two ways to customize your vehicles:  The <font color='#4169E1' size='16' face=''>Vehicle Appearance Manager</font> by <font color='#FF0000' size='18' face=''>UNIT_normal</font> as well as  the <font color='#4169E1' size='16' face=''>GOM Aircraft Loadout manager</font> by <font color='#FF0000' size='18' face=''>Grumpy_Old_Man</font>.<br></br><br></br>
The<font color='#4169E1' size='18' face=''>Vehicle Appearance Manager</font> allows you to fully customize to looks of your vehicles, as well as add functional components to them, such as SLAT cages on armored vehicles. The action to use VAM will appear on your vehicle while it's at one of the depots or the service area.<br></br><br></br>
The <font color='#4169E1' size='18' face=''>GOM Aircraft Loadout manager</font> allows you to fully customize the armament of any compatible aircraft. To use the loadout manager, go to one of the specialist at one of the aircraft depots, or the specialist at the aircraft service station."],taskNull, "",true];

0 = player createDiaryRecord ["Command Ops", ["Base of operations", "In this scenario, the <marker name='base_radius'>main base of operations</marker> is your safe haven. This is where you will start and finish your missions as well as acquire any equipment or vehicle that you might need.<br></br><br></br>
<marker name='marker_hq'>Headquarters</marker> is the most important building in the base. This is where the commanders are located and where you will request missions.<br></br><br></br>
<marker name='marker_medical'>The Field hospital</marker> allows you to fully heal while you're at the base. It is also used for certain mussions such as rescue ones, as this is where you need to bring the people you've rescued.<br></br><br></br>
<marker name='marker_armory'>The Armory</marker> has all of the gear that you might need. Just go in there and talk to the workers, they'll get you sorted quickly. <br></br><br></br>
Last but not least, the base has five different vehicle depots: <marker name='vvs_marker_3'>Car depot</marker>, <marker name='vvs_marker_1'>Armor depot</marker>, <marker name='vvs_marker_4'>Helicopter depot</marker>, <marker name='vvs_marker_0'>Airplane depot</marker> and the <marker name='vvs_marker_2'>Autonomous depot</marker>. The specialists in charge of these depots will provide you with the vehicles that you might need, as well as customization for them."],taskNull, "",true];

0 = player createDiaryRecord ["Command Ops", ["Missions", " In Command Ops, missions can be acquired from NATO Commanders at the <marker name='marker_hq'>Headquarters</marker> in the base.<br></br><br></br>
There are multiple commanders, each offering different types of missions. Currently there are  three mission types: Infantry, Recon and Special missions.<br></br><br></br>
<font color='#FFD700' size='18' face=''>Infantry missions</font> are missions designed to be taken head on. These missions are all about large scale urban combat against vast enemy forces.<br></br><br></br>
<font color='#FFD700' size='18' face=''>Recon missions</font>  are for those who like to work behind enemy lines. They are designed for teams to  infiltrate the enemy territory, locate their objective, complete the mission and get out before they're overrun.
<br></br><br></br>
<font color='#FFD700' size='18' face=''>Special missions</font> are high risk missions that require precise execution and the highest level of soldier performance. Whether you face a delicate situation, or highly trained enemy special forces, these missions are sure to provide a challenge."],taskNull, "",true];

0 = player createDiaryRecord ["Command Ops", ["Introduction", "Welcome to Command Ops! <br></br>
This diary record contains all of the information that you need to know about Command Ops.<br></br>
<br></br>
Command Ops is a coop sandbox gamemode, intended for small and medium groups of players. In command ops, missions can be acquired from NATO Commanders in the HQ, or they can be created by a Zeus Game Master.<br></br><br></br>
We recommend that you go through other diary records to learn more about what Command Ops has to offer."],taskNull, "",true];

[player,"Command Ops: Introduction"] remoteExecCall ["selectDiarySubject",0];

[] call CO_fnc_missionGivers;
[] execVM "VAM_GUI\VAM_GUI_init.sqf";
[] execVM "scripts\NRE_earplugs.sqf";

addMissionEventHandler ["draw3D",  
{if (player distance position loadmaster <= 100) then {
 drawIcon3D  
 [ 
  "\a3\ui_f\data\map\markers\nato\b_maint.paa", 
  [[0,0.3,0.6,1],[1,1,1,1]], 
  getPosATL loadmaster vectorAdd [0,0,4], 
  4, 
  4, 
  0, 
  "Aircraft service", 
  1, 
  0.1, 
  "PuristaMedium", 
  "center"
 ]; };
 if (player distance getMarkerPos "marker_hq" <= 100) then {
	drawIcon3D  
	[ 
	"\a3\ui_f\data\map\markers\nato\b_hq.paa", 
	[[0,0.3,0.6,1],[1,1,1,1]], 
	getMarkerPos "marker_hq" vectorAdd [0,0,15], 
	3, 
	3, 
	0, 
	"Headquarters", 
	1, 
	0.1, 
	"PuristaMedium", 
	"center"
 ]; };
}];

{[ 
	_x, 
	"Aircraft Loadout", 
	"\a3\modules_f_curator\data\portraitcasgunmissile_ca.paa", 
	"\a3\modules_f_curator\data\portraitcasgunmissile_ca.paa", 
	"_this distance _target < 5",
	"_caller distance _target < 5",      
	{},              
	{},              
	{[_caller] spawn GOM_fnc_aircraftLoadout},     
	{},              
	[],              
	1,              
	19,            
	false, 
	false
] call BIS_fnc_holdActionAdd;} forEach [vvs_spawner_0, vvs_spawner_3, vvs_spawner_1, loadmaster];


