/* ----------------------------------------------------------------------------
Function: OPTRE_fnc_corvetteHEVInit

Description:
	Initializes corvette with pods and actions to launch HEVs from the corresponding ship.

Parameters:
	0: _ship <OBJECT> - The ship to initialize the drop system for. This should be the complete corvette object or the tail piece
	1: _advancedMode <BOOL> - Decide between advanced and basic drop control
	2: _debugMode <BOOL> - Turn on debug mode
	3: _launchTime <NUMBER> - How long you want the pods to wait until launching
	4: _reloadTime <NUMBER> - How long it takes for the pods to respawn in the corvette
	

Returns:
	BOOL

Examples:
    (begin example)
		
		[myShip,false] call OPTRE_fnc_corvetteHEVInit;

    (end)

Author:
	TheDog,
	Modified by: Ansible2 // Cipher	OPTRE_DRAKE_dropControl
---------------------------------------------------------------------------- */
if (is3DEN) exitWith {false};

if (!isServer) exitWith {false};

params [
	["_ship",objNull,[objNull]],
	["_mode",0,[123]],
	["_debugMode",false,[true]],
	["_launchTime",-1,[123]],
	["_reloadTime",-1,[123]]
];

private _shipType = typeOf _ship;
if ((_shipType != "OPTRE_UNSC_Drake") AND {_shipType != "OPTRE_tail"}) exitWith {
	"_ship is not correct types ('OPTRE_UNSC_Drake' OR 'OPTRE_tail')" call BIS_fnc_error;
	false
};


private "_shipTail";
if (_shipType isEqualTo "OPTRE_UNSC_Drake") then {
	_shipTail = (_ship getVariable ["OPTRE_DrakeParts",[]]) select 2; 
} else {
	_shipTail = _ship;
};

if (_launchTime isEqualTo -1) then {
	_launchTime = _ship getvariable ["OPTRE_Drake_LaunchInTime",20];
};
 
// add drop control to ship panel
if !(_advancedMode) then {
	[ 
		_shipTail,  
		[
			(format ["Lauch HEVs In %1 Seconds",_launchTime]),  
			{
				params ["_target", "_caller", "_actionId", "_arguments"];
				[_target,_arguments select 0] remoteExec ["OPTRE_fnc_corvetteHEVLaunch",2];
			}, 
			[_launchTime], 
			1.5,  
			true,  
			true,  
			"", 
			"_target getvariable [""OPTRE_DrakeAllowLaunch"",false];",
			3, 
			false, 
			"", 
			"podswitch"
		] 
	] remoteExec ["addAction",[0,-2] select isDedicated,true];
};

_shipTail setvariable ["OPTRE_Drake_LaunchInTime",_launchTime]; // why?

if (_reloadTime isEqualTo -1) then {
	_reloadTime = _ship getvariable ["OPTRE_Drake_ReloadHEVTime",60];
};
_shipTail setvariable ["OPTRE_Drake_ReloadHEVTime",_reloadTime]; // why?

private _hevArray = []; 
for "_i" from 1 to 6 do { 

	private _memoryPointName = format ["pod%1pos",_i]; 
	
	private _hev = createVehicle ["OPTRE_HEV", [0,0,0], [], 0, "NONE"]; 
	_hev attachTo [_shipTail, [0, 0.17, 1.05], _memoryPointName]; 
	_hevArray pushBack _hev;
	_hev setVariable ["OPTRE_HEVLauchOrder",_i];
	//_hev setVariable ["OPTRE_HEVParentCorvette",_shipTail];

	//_hevArray pushBack [_hev,_i]; 
	
	// open up HEV doors
	_hev animate  ["main_door_rotation",1]; 
	_hev animate  ["left_door_rotation",1]; 
	_hev animate  ["right_door_rotation",1];
	
	//_hev setVariable ["OPTRE_PlayerControled",true,true]; // why?
	
	// spawn crew for debug, but leave last pod for player
	if (_debugMode AND _i < 6) then {[ _hev, createGroup west ] call BIS_fnc_spawnCrew;};
	
	if (_advancedMode) then {
		_hev addEventHandler ["GetIn", {
			params ["_vehicle", "_role", "_unit", "_turret"];

			hint "added dialog";
			[_unit] remoteExec ["OPTRE_fnc_addHEVDialogAction",_unit];
		}];
		_hev addEventHandler ["GetOut", {
			params ["_vehicle", "_role", "_unit", "_turret"];

			hint "removed dialog";
			//[_unit] remoteExec ["OPTRE_fnc_addHEVDialogAction",_unit];
		}];
	};
};

_shipTail setvariable ["OPTRE_DrakeAllowLaunch",true]; // why? // this can just be on the server, just need to query it
//_shipTail setvariable ["OPTRE_DrakeCurrentlyAttachedHEVs",_hevArray,true]; // why?
_shipTail setvariable ["OPTRE_DrakeCurrentlyAttachedHEVs",_hevArray]; 

if (_debugMode) then {
	player moveInGunner _hevArray select 5; 
	//0 = [_shipTail] execVM "OPTRE_Corvette\HEV_Scripts\HEV_Launch.sqf";
	[_shipTail,_launchTime] call OPTRE_fnc_corvetteHEVLaunch;
};

true