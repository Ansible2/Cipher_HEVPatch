params [
	["_array",[],[[]]],
	["_console",objNull,[objNull]]
];

// if cooldown in progress	
if ((_console getVariable ["OPTRE_PodsLaunchIn",-1]) isEqualTo -2) exitWith {
	playSound3d ["a3\missions_f_beta\data\sounds\firing_drills\checkpoint_not_clear.wss", _console,false, getPosATL _console, 0.5, 1, 300];
};  

// if count down in progress
if ((_console getVariable ["OPTRE_PodsLaunchIn",-1]) >  -1) exitWith {
	playSound3d ["a3\missions_f_beta\data\sounds\firing_drills\checkpoint_not_clear.wss", _console,false, getPosATL _console, 0.5, 1, 300];
}; 


_console setVariable ["OPTRE_PodsLaunchIn",30,true];

// play 3d countdown sound from control panel when launch initiated	
While {(_console getVariable ["OPTRE_PodsLaunchIn",-1]) > 0} do {
	private _number = _console getVariable ["OPTRE_PodsLaunchIn",-1];
	_console setVariable ["OPTRE_PodsLaunchIn",(_number-1),true];
	playSound3d ["a3\missions_f_beta\data\sounds\firing_drills\timer.wss", _console,false, getPosATL _console, 0.5, 1, 300];
	sleep 1; 
};

if ((_console getVariable ["OPTRE_PodsLaunchIn",-1]) isEqualTo -1) exitWith {
	playSound3d ["a3\missions_f_beta\data\sounds\firing_drills\drill_finish.wss", _console, false, getPosATL _console, 0.5, 1, 300];
};


if ((_console getVariable ["OPTRE_PodsLaunchIn",-1]) isEqualTo 0) then {
	
	private _linkedPods = _console getVariable ["OPTRE_PodsLinkedToConsole",[]];


	// animate doors close
	_linkedPods apply {
		private _HEV = _x;

		[_HEV,true] remoteExec ["lock", _HEV, false];

		if (_HEV animationPhase "main_door_rotation" != 0) then {
			_HEV animate ["main_door_rotation",0]; 
		};

		if (_HEV animationPhase "left_door_rotation" != 0) then {
			_HEV animate ["left_door_rotation",0]; 
		};

		if (_HEV animationPhase "right_door_rotation" != 0) then {
			_HEV animate ["right_door_rotation",0];
		};
	};

		
	sleep 2;


	private _units = [];

	// start loading screen effect and push all units in the pods into _units array
	_linkedPods apply {
		private _driver = driver _x;
		if (alive _driver) then {
			_units pushBack _driver; 
			if (_driver in allPlayers) then {
				[999,["OPTRE_LoadScreen", "PLAIN"]] remoteExec ["cutRsc", _driver];
			};
		};
	};


	sleep 3;


	// save pod cargo, move units out of pods to be teleported to new ones in the sky
	_units apply {
		private _unit = _x;
		private _podCargo = [objectParent _unit] call OPTRE_fnc_getContainerCargo;

		if !(_podCargo isEqualTo []) then {
			_unit setVariable ["OPTRE_podCargo",_podCargo];
		};

		moveOut _unit;
	};


	// if there are units that dropped then cooldown, else don't
	if (count _units > 0) then {
		_array set [1, _units];
		// call the main function
		{_array call OPTRE_Fnc_HEV;} call CBA_fnc_directCall;
		_console setVariable ["OPTRE_PodsLaunchIn",-2,true];


		// launch cooldown
		[	
			{
				params [
					["_linkedPods",[],[[]]],
					["_console",objNull,[objNull]]
				];

				// animate doors open
				_linkedPods apply {
					private _HEV = _x;

					[_HEV,false] remoteExec ["lock", _HEV, false];

					if (_HEV animationPhase "main_door_rotation" != 1) then {
						_HEV animate ["main_door_rotation",1]; 
					};

					if (_HEV animationPhase "left_door_rotation" != 1) then {
						_HEV animate ["left_door_rotation",1]; 
					};

					if (_HEV animationPhase "right_door_rotation" != 1) then {
						_HEV animate ["right_door_rotation",1];
					};
				};

				playSound3d ["a3\missions_f_beta\data\sounds\firing_drills\drill_finish.wss", _console,false, getPosATL _console, 0.5, 1, 300];

				_console setVariable ["OPTRE_PodsLaunchIn",-1,true];
			},
			[_linkedPods,_console],
			60
		] call CBA_fnc_waitAndExecute;
	} else {
		playSound3d ["a3\missions_f_beta\data\sounds\firing_drills\drill_finish.wss", _console,false, getPosATL _console, 0.5, 1, 300];

		// animate doors open
		_linkedPods apply {
			private _HEV = _x;

			[_HEV,false] remoteExec ["lock", _HEV, false];

			if (_HEV animationPhase "main_door_rotation" != 1) then {
				_HEV animate ["main_door_rotation",1]; 
			};

			if (_HEV animationPhase "left_door_rotation" != 1) then {
				_HEV animate ["left_door_rotation",1]; 
			};

			if (_HEV animationPhase "right_door_rotation" != 1) then {
				_HEV animate ["right_door_rotation",1];
			};
		};

		_console setVariable ["OPTRE_PodsLaunchIn",-1,true];
	};		
};
