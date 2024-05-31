params ["_missionGroup"];


	
_title = switch _missionGroup do
{
	case "infantry": {"Infantry mission:"};
	case "recon": {"Recon mission:"};
	case "special": {"Special mission:"};
	case "air": {"Air support mission:"};
	case "logistics": {"Logistics mission:"};
};
createDialog "MissionSelectGui";
_gui = findDisplay 1973;
sleep 0.1;
_icon = _gui displayCtrl 69;
_icon ctrlSetText "\a3\ui_f_orange\data\displays\rscdisplayorangechoice\faction_nato_ca.paa";
_titleBox = _gui displayCtrl 1;
_titlebox ctrlSetText _title;

_menuType =_gui displayCtrl 5;
switch _missionGroup do
{
	case "infantry": 
	{
		_menuType lbAdd "Random Infantry misson";
		_menuType lbAdd "Clear Town";
		_menuType lbAdd "Defend Town";
		_menuType lbAdd "Sabotage";
		
	};
	case "recon": 
	{
		_menuType lbAdd "Random Recon misson";
		_menuType lbAdd "Search and Rescue";
		_menuType lbAdd "Counter-Recon";
		_menuType lbAdd "SAM Sabotage";
		_menuType lbAdd "Artillery FOB Sabotage";
		
	};
	case "special": 
	{
		_menuType lbAdd "Random Special misson";
		_menuType lbAdd "Acquire intel";
		_menuType lbAdd "Hostage Rescue";
		
	};
	case "air": {};
	case "logistics": {};
};

_menuSide =_gui displayCtrl 6;
_menuSide lbAdd "OPFOR";
_menuSide lbAdd "INDEPENDENT";

_menuType lbSetCurSel 0;
_menuSide lbSetCurSel 0;

_confirm = _gui displayCtrl 7;
_confirm ctrlAddEventHandler ["MouseButtonClick",
{
	createDialog "ChooseFaction";
	_factionGui = findDisplay 1974;
	_menuFaction = _factionGui displayCtrl 3;
	factionList = [];
	switch (lbCurSel ((findDisplay 1973) displayCtrl 6)) do 
	{
		case 0: 
		{
		_menuFaction lbAdd "RANDOM";
		{_menuFaction lbAdd _x} forEach eastFactions;
		factionList = eastFactions;
		};
		case 1: 
		{
		_menuFaction lbAdd "RANDOM";
		{_menuFaction lbAdd _x} forEach indFactions;
		factionList = indFactions;
		};
	};
	_menuFaction lbSetCurSel 0;
	(_factionGui displayCtrl 4) ctrlAddEventHandler ["MouseButtonClick",
	{
		_mainGui = findDisplay 1973;
		_factionGui = findDisplay 1974;
		_side = switch (lbCurSel (_mainGui displayCtrl 6)) do {case 0:{EAST};case 1:{resistance};};
		_factionName = ((_factionGui displayCtrl 3) lbText (lbCurSel(_factionGui displayCtrl 3)));
		_faction = _factionName;
		switch _factionName do
		{
			case "RANDOM": {_faction = selectRandom factionList};
			default {_faction = _factionName};
		};
		_missions = ["CO_fnc_townClear","CO_fnc_townDefend","CO_fnc_sabotageCache","CO_fnc_reconRescue","CO_fnc_reconAntirecon","CO_fnc_reconSabotage","CO_fnc_reconSabotageArty","CO_fnc_recoverIntelSF","CO_fnc_sfHostageRescue"];
		_mission = switch ((_mainGui displayCtrl 5) lbText lbCurSel(_mainGui displayCtrl 5)) do
		{
			case "Clear Town":{_missions select 0};
			case "Defend Town":{_missions select 1};
			case "Sabotage":{_missions select 2};
			case "Search and Rescue":{_missions select 3};
			case "Counter-Recon": {_missions select 4};
			case "SAM Sabotage":{_missions select 5};
			case "Artillery FOB Sabotage":{_missions select 6};
			case "Acquire Intel": {_missions select 7};
			case "Hostage Rescue": {_missions select 8};
			case "Random Infantry misson":{_missions select (selectRandom [0,1,2])};
			case "Random Recon misson":{_missions select (selectRandom [3,4,5,6])};
			case "Random Special misson":{_missions select (selectRandom [7,8])};
		};
		[_side,_faction] remoteExec [_mission,2];
		[] spawn {while{dialog} do {closeDialog 0; sleep 0.02}};
	}];
}];


