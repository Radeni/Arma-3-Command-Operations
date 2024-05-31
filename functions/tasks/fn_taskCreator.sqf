
// [owner, taskID, description, destination, state, priority, showNotification, type, visibleIn3D] call BIS_fnc_taskCreate
/*

Tasks:																Task names:											Dev progress:

-Infantry:
	-Hostile takeover (Clear town) + Command hq?					townClear											100%
	-Sabotage (Supply cache)										sabotageInfantry									90%
	-Defend town (conventional)										townDefend											90%
-Airforce:
	-Troop transport												transportPerson										0%
	-Supply transport (Helicopter)									transportObject										0%
	-Air superiority (Destroy enemy aircraft)						airDestroyAir										0%
	-Ground support (Destroy attacking ground vehicles)				airDestroyGround									0%
-Recon:
	-Sabotage (Enemy LRAA/LRArty)									reconSabotage										0%
	-UAV Data														reconRecovery										0%
	-Patrol															patrol												0%
	-Search and rescue												reconRescue											0%
	-Anti recon														reconClear											0%
	-Enemy jammer???
-Logistics:
	-Missing supply crate											recoveryCache										30%
	-Supply transport (Drive vehicle to random location)			transportVehicle									0%
-Special forces:
	-Hostage rescue													recoveryVIP											0%
	-Assassination													killHVT												0%
	-Snatch and grab												recoveryHVT											0%
	-Intel recovery (From enemy).									recoveryIntel										0%
	-Convoy Interception 											sabotageConvoy										0%
	-Underwater recovery											recoveryUW											0%
	-Underwater EOD													sabotageUW											0%
	-Anti-Piracy.
	-Steal Prototype Technology (Vehicle)
*/
params ["_missionType","_destination"];

_taskID = "task_" + str taskIDGlobal;
_description = [];
_type = "";

switch _missionType do
{
	case "townClear": {_description = ["Clear the town", "Clear the town"]; _type = "attack"};
	case "sabotageInfantry": {_description = ["Destroy the cache", "Destroy the cache"]; _type = "destroy"};
	case "townDefend": {_description = ["Defend the town","Defend the town"]; _type = "defend"};
	case "reconSabotage": {_description = ["We have learned that an enemy SAM site has been set up in the AO. We do not know it's exact location but we know it's general area. Recon the area and sabotage the site.","Sabotage the SAM site"]; _type = "destroy"};
	case "reconSabotageArty": {_description = ["We have learned that the enemy has set up a forward artillery base in the AO. We do not know it's exact location but we know it's general area. Recon the area and sabotage the site by destroying their artillery equipment.","Sabotage the Artilley FOB"]; _type = "destroy"};
	case "reconRescue": {_description = ["A NATO helicopter on patrol has taken fire and reported that they were going down. All communication had ceased after the crash, but we've reason to believe that the crew is still alive. We don't know the exact location of the crash site but we've calculated the approximate area of where it might be. Your job is to find the crash site and bring the crew back to the base.","Find and Rescue the crew"]; _type = "search"};
	case "reconAntirecon": {_description = ["We have received reports about enemy scouts setting up camps in our AO to monitor our troops' movement. They have to be dealt with as soon as possible! Find their camps and neutralize the scouts.", "Find and neutralize the scouts"]; _type = "Search"};
	case "hostageRescue": {_description = ["The enemy has captured a local informant of ours and are holding them hostage. Your job is to them and bring them safely back to our base for questioning. Leave them at the medical station.", "Find and rescue the informant"]; _type = "meet"};
	case "recoverIntelSF": {_description = ["We have recieved intelligence from one of our agents that there is a vulnerable server with a large amount of enemy intel, we would like you to infiltrate the base and steal the intel.", "Find and steal intelligence"]; _type = "search"};
};

_task = [true, _taskID, _description, _destination, "CREATED", -1, true, _type, true] call BIS_fnc_taskCreate;

taskIDGlobal = taskIDGlobal + 1;

_task;
