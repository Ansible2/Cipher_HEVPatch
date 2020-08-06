if !isServer exitWith {};

_tail = _this select 0;
_hevArray = _tail getvariable ["OPTRE_DrakeCurrentlyAttachedHEVs",[]];
_tail setvariable ["OPTRE_DrakeAllowLaunch",false,true];
_chuteDeployHeight = 200; // 50
_chuteDetachHeight = 50; // 100
//_hevBoastUpHeight = 50;

for "_i" from 1 to (_tail getvariable ["OPTRE_Drake_LaunchInTime", 20]) do {
	//playSound "FD_Finish_F";
	playSound3D ["a3\missions_f_beta\data\sounds\firing_drills\drill_finish.wss", (_tail selectionPosition "podswitch"), true, (_tail selectionPosition "podswitch"), 5, 1, 200];
	sleep 1; 
};

{
	_hev = _x select 0;
	_hev animate  ["main_door_rotation",0];  
	_hev animate  ["left_door_rotation",0];  
	_hev animate  ["right_door_rotation",0]; 
} forEach _hevArray;

sleep 2; 

_launchedArray = [];
{
	private ["_hev","_hevNumber"];
	
	_hev = _x select 0;
	_hevNumber = _x select 1; 
	
	if ( ( str (gunner _hev)) != "<NULL-object>" ) then {
	
		_tail animate [(format ["drop_door_%1_a_rot",_hevNumber]),1];
		_tail animate [(format ["drop_door_%1_b_rot",_hevNumber]),1];
		
		sleep 0.5;
		playSound3D ["OPTRE_FunctionsLibrary\sound\PodsDetaching.ogg", _hev, true, getPosASLW _hev, 5, 1, 200];
		sleep 0.1;
		detach _hev;
		
		_hev setvariable ["OPTRE_HEV_ChuteDeployed",false,true];
		_launchedArray pushBack _x;
		
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

sleep (_tail getvariable ["OPTRE_Drake_ReloadHEVTime",60]); // Time Till Reload of HEVs. 

[_cleanUpObjects,true] remoteExec ["OPTRE_fnc_CleanUp", 2, false];
0 = [_tail] execVM "OPTRE_Corvette\HEV_Scripts\HEV_Reload.sqf";