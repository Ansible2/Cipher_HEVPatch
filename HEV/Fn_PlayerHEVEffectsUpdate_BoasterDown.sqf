/* 
	OPTRE_fnc_PlayerHEVEffectsUpdate_BoasterDown
	
	Description: Function is designed to be executed only from inside of the HEV scripts, do not execute it directly.
	
	Author: Big_Wilk, modified by Cipher

	Modifications: Adapted for use on dedicated servers, patched several bugs, improved performance/readability, moved into unscheduled environment
	
	Return: none
	
	Type: call
*/
if !(hasInterface) exitWith {};

params [
	["_randomXYVelocity",1,[1]],
	["_randomXYVelocity2",1,[1]],
	["_launchSpeed",1,[1]],
	["_manualControlState",0,[1]],
	["_hev",objNull,[objNull]],
	["_hevDropArmtmosphereStartHeight",3000,[1]]
];

if (typeOf _hev != "OPTRE_HEV") exitWith {};


_arm = attachedTo _hev;
_arm enableSimulation false;
_arm disableCollisionWith _hev;
deleteVehicle _arm;
detach _hev;


//_hev setVelocity [_randomXYVelocity,_randomXYVelocity2,_launchSpeed]; 
[_hev,[_randomXYVelocity,_randomXYVelocity2,_launchSpeed]] remoteExecCall ["setVelocity",_hev];

//playSound "OPTRE_Sounds_Detach";
playSound "OPTRE_Sounds_DetachOLD";

resetCamShake;
addCamShake [21, 6, 31];
addCamShake [11, 16, 32];

playSound ["OPTRE_Sounds_Engine",true];																									

// atmo entry camera shake (needs to be migrated to a better spot in main script)
[
	{(getPosATLVisual (_this select 0)) select 2 < (_this select 1)},
	{
		addCamShake [1, 999, 11];
	},
	[_hev,_hevDropArmtmosphereStartHeight]
] call CBA_fnc_waitUntilAndExecute;

if (_manualControlState > 0) then {
	[_manualControlState] call OPTRE_fnc_HEVControls;
};

// this logic is used to play the wind sound using say2D so that the logic can be deleted at anytime, stopping the sound
private _logicCenter = createCenter sideLogic;
private _logicGroup = createGroup _logicCenter;
private _logic = _logicGroup createUnit ["Logic", [0,0,0], [], 0, "NONE"];
_logic attachTo [_hev,[0,0,0]];

[
	{	((_this getVariable "params") select 2) say2D "OPTRE_Sounds_WindLoopNewLong";	},
	
	1,
	
	[_hev,_hevDropArmtmosphereStartHeight,_logic],
	
	{	((_this getVariable "params") select 2) say2D "OPTRE_Sounds_WindLoopNewLong";	},
	
	{	deleteVehicle ((_this getVariable "params") select 2);	},
	
	{
		_hev = (_this getVariable "params") select 0;
		_hevDropArmtmosphereStartHeight = (_this getVariable "params") select 1;

		(	(getPosATLVisual _hev) select 2 < _hevDropArmtmosphereStartHeight	)
	},
	
	{
		_hev = (_this getVariable "params") select 0;

		(	!alive (gunner _hev) OR {(getPosATL _hev) select 2 < 20} OR {(velocity _hev) select 2 isEqualTo 0}	)
	}

] call CBA_fnc_createPerFrameHandlerObject;