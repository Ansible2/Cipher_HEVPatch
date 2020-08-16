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


_shipTail setvariable ["OPTRE_DrakeAllowLaunch",false,true];

// countdown & sound
private _switchSoundPositon = _shipTail modelToWorldWorld (_shipTail selectionPosition "podswitch");
private _countDownTime = _shipTail getvariable ["OPTRE_Drake_LaunchInTime",20];
for "_i" from 0 to (_countDownTime - 1) do {
	playSound3D ["a3\missions_f_beta\data\sounds\firing_drills\drill_finish.wss",_switchSoundPositon, true,_switchSoundPositon, 2, 1, 50];
	sleep 1;
};
playSound3D ["a3\missions_f_beta\data\sounds\firing_drills\drill_finish.wss",_switchSoundPositon, true,_switchSoundPositon, 2, 2, 50];

// close doors
private _hevArray = _shipTail getvariable ["OPTRE_DrakeCurrentlyAttachedHEVs",[]];
_hevArray apply {
	_x animate ["main_door_rotation",0];  
	_x animate ["left_door_rotation",0];  
	_x animate ["right_door_rotation",0]; 
};

sleep 2; 

// drop
// this array is used to get the indexes of those that launched for respawn 
_launchedArray = [];
{
	private _hev = _x;
	private _hevNumber = _hev getVariable ["OPTRE_HEVLauchOrder",_forEachIndex];
	private _gunner = gunner _hev; 
	
	if !(isNull _gunner) then {
		
		// open ship doors
		_shipTail animate [(format ["drop_door_%1_a_rot",_hevNumber]),1];
		_shipTail animate [(format ["drop_door_%1_b_rot",_hevNumber]),1];
		// clsoe after 5 seconds
		[
			{
				params ["_shipTail","_HEVNumber"];
				_shipTail animate [(format ["drop_door_%1_a_rot",_HEVNumber]),0];
				_shipTail animate [(format ["drop_door_%1_b_rot",_HEVNumber]),0];
			},
			[_shipTail,_HEVNumber],
			5
		] call CBA_fnc_waitAndExecute;
		
		detach _hev;
		[_hev,[0,0,-25]] remoteExecCall ["setVelocityModelSpace",_hev];
		["OPTRE_Sounds_DetachOLD",(getPosASL _hev) vectorAdd [0,-0.25,0.5],50,2] call OPTRE_fnc_playSound3D;
		
		// launch smoke
		private _smoke = "#particlesource" createVehicle [0,0,0]; 
		_smoke setParticleClass "Missile2";
		_smoke attachto [_hev,[0,-0.2,0.6]];
		[
			{
				// delete smoke
				deleteVehicle (_this select 0);
			},
			[_smoke],
			2
		] call CBA_fnc_waitAndExecute;

		// need cam shake for occupants
		// need engine noise for occupants
		[_hev] remoteExec ["OPTRE_fnc_corvetteHEVPlayerEffects",_gunner];

		_hev setvariable ["OPTRE_HEV_ChuteDeployed",false,true]; // why?
		_launchedArray pushBack _hev;
	};
} forEach _hevArray;

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