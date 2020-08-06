/* ----------------------------------------------------------------------------
Function: OPTRE_fnc_corvetteHEVLaunch

Description:
	Initializes corvette with pods and actions to launch HEVs from the corresponding ship.

Parameters:
	0: _ship <OBJECT> - The ship to initialize the drop system for. This should be the complete corvette object or the tail piece
	1: _launchTime <NUMBER> - How long you want the pods to wait until launching
	2: _reloadTime <NUMBER> - How long it takes for the pods to respawn in the corvette
	3: _debugMode <BOOL> - Turn on debug mode

Returns:
	BOOL

Examples:
    (begin example)
		
		[myShip,false] spawn OPTRE_fnc_corvetteHEVLaunch;

    (end)

Author:
	TheDog,
	Modified by: Ansible2 // Cipher
---------------------------------------------------------------------------- */
if (!isServer) exitWith {false};

if (!canSuspend) exitWith {
	"Must be run in scheduled envrionment" call BIS_fnc_error;
	false
};

params [
	"_shipTail",
	"_launchTime",
	["_chuteDeployHeight",200,[123]],
	["_chuteDetachHeight",50,[123]]
];

private _hevArray = _shipTail getvariable ["OPTRE_DrakeCurrentlyAttachedHEVs",[]];
_shipTail setvariable ["OPTRE_DrakeAllowLaunch",false,true];

private _switchSoundPositon = _shipTail modelToWorldWorld (_shipTail selectionPosition "podswitch");
private _countDownTime = _shipTail getvariable ["OPTRE_Drake_LaunchInTime",20];
for "_i" from 0 to _countDownTime do {
	// using waitAndExecute to spawn a new thread so the rest of the script here can continue instead of waiting
	if (_i isEqualTo _countDownTime) then {
		[
			{
				params ["_switchSoundPositon"];
				playSound3D ["a3\missions_f_beta\data\sounds\firing_drills\drill_finish.wss",_switchSoundPositon, true,_switchSoundPositon, 5, 1, 200];
			},
			[_switchSoundPositon],
			_i
		] call CBA_fnc_waitAndExecute;
	} else {
		[
			{
				params ["_switchSoundPositon"];
				playSound3D ["a3\missions_f_beta\data\sounds\firing_drills\drill_finish.wss",_switchSoundPositon, true,_switchSoundPositon, 5, 1, 200];
			},
			[_switchSoundPositon],
			_i
		] call CBA_fnc_waitAndExecute;
	};
	//playSound3D ["a3\missions_f_beta\data\sounds\firing_drills\drill_finish.wss",_soundPositon, true,_soundPositon, 5, 1, 200];
	//sleep 1; 
};

_hevArray apply {
	_x animate ["main_door_rotation",0];  
	_x animate ["left_door_rotation",0];  
	_x animate ["right_door_rotation",0]; 
};

sleep 2; 

_launchedArray = [];
_hevArray apply {
	private _hev = _x;
	_hevNumber = _hev setVariable ["OPTRE_HEVLauchOrder",_i]; 
	
	if !(isNull (gunner _hev)) then {
	
		_shipTail animate [(format ["drop_door_%1_a_rot",_hevNumber]),1];
		_shipTail animate [(format ["drop_door_%1_b_rot",_hevNumber]),1];
		
		sleep 0.5;
		playSound3D ["OPTRE_FunctionsLibrary\sound\PodsDetaching.ogg", _hev, true, getPosASLW _hev, 5, 1, 200];
		sleep 0.1;
		detach _hev;
		
		_hev setvariable ["OPTRE_HEV_ChuteDeployed",false,true]; // why?
		_launchedArray pushBack _hev;
		
	};
	
};

_cleanUpObjects = [];
while {count _launchedArray > 0} do {
	
	//sleep 1; 
	
	/*_time = time;  
	while {time < _time + 2} do {
		{
			_hev = _x select 0;
			_hev addForce [[(random 20 + random -20),(random 20 + random -20),0],[0,0,0]];
		} forEach _launchedArray;
	};*/
	
	{
		_hev = _x select 0;
		_heightHEV = (getposatl _hev) select 2; 
		
		if (!(_hev getvariable ["OPTRE_HEV_ChuteDeployed",false]) AND (_heightHEV < _chuteDeployHeight) ) then {
			_hev setvariable ["OPTRE_HEV_ChuteDeployed",true,true];
			0 = [_hev] execVM "OPTRE_Corvette\HEV_Scripts\Stage_OpenChute.sqf";
		};
		
		if ((_hev getvariable ["OPTRE_HEV_ChuteDeployed",false]) AND (_heightHEV < _chuteDetachHeight) ) then {
			_chute = (_hev getVariable ["OPTRE_HEVChute",objNull]); 
			_hev setVariable ["OPTRE_HEV_DoorEjectedWanted",true,true];
			_chute remoteExec ["detach", 0];
			[_chute, _hev] remoteExecCall ["disableCollisionWith", 0, _chute];
			[_hev, _chute] remoteExecCall ["disableCollisionWith", 0, _hev];
			_hev setvelocity [0,0,0];
			_chute setvelocity [(random 30 + random -30),(random 30 + random -30),22];
			{_cleanUpObjects pushBack _x;} forEach [_chute];  
			_launchedArray = _launchedArray - [_x]; // ends the loop when all are removed. 
		};
		
		/*if ((_hev getvariable ["OPTRE_HEV_ChuteDeployed",false]) AND (_heightHEV < _hevBoastUpHeight) ) then {
			0 = [_hev] execVM "OPTRE_Corvette\HEV_Scripts\Stage_RetroThrusters.sqf";
			_launchedArray = _launchedArray - [_x];
		};*/
		
	} forEach _launchedArray;
	
};

sleep (_shipTail getvariable ["OPTRE_Drake_ReloadHEVTime",60]); // Time Till Reload of HEVs. 

//[_cleanUpObjects,true] remoteExec ["OPTRE_fnc_CleanUp", 2, false];
// need a cleanup function
[_shipTail] call OPTRE_fnc_corvetteHEVReload;