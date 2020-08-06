//hint "script v0.5";

hint "mine better";

if !isServer exitWith {};

if (is3DEN) exitWith {};

_ship = _this select 0;
OPTRE_DrakeHEVDebug = _this select 1;

_tail = (_ship getVariable ["OPTRE_DrakeParts",[]]) select 2; 
_hevArray = [];  
_launchTime = (_ship getvariable ["OPTRE_Drake_LaunchInTime",20]); 

[ 
	_tail,  
	[
		(format ["Lauch HEVs In %1 Seconds",_launchTime]),  
		{[_this,"OPTRE_Corvette\HEV_Scripts\HEV_Launch.sqf"] remoteExec ["execVM", 2];}, 
		[], 
		1.5,  
		true,  
		true,  
		"", 
		"_target getvariable [""OPTRE_DrakeAllowLaunch"",false];", // _target, _this, _originalTarget 
		3, 
		false, 
		"", 
		"podswitch"
	] 
] remoteExec ["addAction", 0, "OPTRE_DrakeHEVAction_JIP"];

_tail setvariable ["OPTRE_Drake_LaunchInTime",_launchTime,false];
_tail setvariable ["OPTRE_Drake_ReloadHEVTime",(_ship getvariable ["OPTRE_Drake_ReloadHEVTime",60]),false];

for "_i" from 1 to 6 do { 

	_memPointName = format ["pod%1pos",_i]; 
	
	_hev = createVehicle ["OPTRE_HEV", [0,0,0], [], 0, "CAN_COLLIDE"]; 
	_hev attachTo [_tail, [0, 0.17, 1.05], _memPointName]; 
	_hevArray pushBack [_hev,_i]; 
	
	_hev animate  ["main_door_rotation",1]; 
	_hev animate  ["left_door_rotation",1]; 
	_hev animate  ["right_door_rotation",1];
	
	_hev setVariable ["OPTRE_PlayerControled",true,true];
	
	if (OPTRE_DrakeHEVDebug AND _i < 6) then {[ _hev, createGroup west ] call BIS_fnc_spawnCrew;};
	
};

_tail setvariable ["OPTRE_DrakeAllowLaunch",true,true];
_tail setvariable ["OPTRE_DrakeCurrentlyAttachedHEVs",_hevArray,true];

if (OPTRE_DrakeHEVDebug) then {player moveInGunner ((_hevArray select 5) select 0); 0 = [_tail] execVM "OPTRE_Corvette\HEV_Scripts\HEV_Launch.sqf";};