myTask = ["sabotage",getPos testBox] call CO_fnc_taskCreator;
onActivation = format ["['%1', 'Succeeded'] call BIS_fnc_taskSetState", myTask];
testtrg = createTrigger ["EmptyDetector",getPos testBox];
testtrg setTriggerStatements ["!alive testBox",onActivation,""];