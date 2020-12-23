#include "..\string constants.hpp"
/* ----------------------------------------------------------------------------
Function: OPTRE_Fnc_HEV

Description:
	The main HEV drop script. This is what executes the actual drop sequence. You can use it in an action or any other method.

	Modifications: Adapted for use on dedicated servers, patched several bugs, improved performance/readability

	Must be executed on server.

Parameters:

	0: _dropPosition <ARRAY> - The postition to initiate the drop, can be either 3D position [0,0,0] or 2D [0,0]
	
	1: _units <ARRAY> - The units to teleport to drop pods
	
	2: _shipDeployment <STRING> - How to drop the units: Options are "frigate", "corvette", "No Ship", and "No Ship Custom". 
	
	3: _launchDelay <NUMBER> - How long for pods to hang in seconds. >30 is required for engine start sound effects.
	
	4: _randomXYVelocity <NUMBER> - The degree to which pods will randomly spread. At least 2 is forced due to a physics crash being possible if pods hit each other enough on the ground
	
	5: _launchSpeed <NUMBER> - Downward velocity of pods. Should be a negative number. Recommend -1 (the more speed the harder the script will have to work and it will be more likely for issues to appear)
	
	6: _startHeight <NUMBER> - At what altitude should the pods drop from? Will be used in conjunction with _dropPosition or not at all if the 3D height exceeds altitiude
	
	7: _hevDropArmtmosphereStartHeight <NUMBER> - The altitude start of entry effects.
	
	8: _hevDropArmtmosphereEndHeight <NUMBER> - The altitude end of entry effects.
	
	9: _chuteDeployHeight <NUMBER> - The altitude to deploy chutes at.
	
	10: _chuteDetachHeight <NUMBER> - The altitude to detach chutes at.
	
	11: _deleteShip <NUMBER> - Should the ship the units are dropped from be deleted? (not req if used with both "No Ship" deployments)
	
	12: _deleteChutesOnDetach <BOOL> - Should chutes be deleted after detaching from HEV?
	
	13: _deleteHEVsAfter <BOOL> - How long to wait to delete HEVs in seconds
	
	14: _manualDrop <BOOL> - Was the drop initiated manually? This allows certain parameters to be changed. By manual, it means by either script or the Module that allows custom attributes for the drop

Returns:
	BOOL

Examples:
    (begin example)

		[
			[0,0,0],
			[player],
			"corvette",
			30,
			2,
			-1,
			5500,
			3000,
			2000,
			1000,
			500,
			true,
			true,
			600,
			false
		] call OPTRE_fnc_HEV

    (end)

Author:
	Big_Wilk,
	Modified by: Ansible2 // Cipher
---------------------------------------------------------------------------- */
/*
	The biggest issue with this system in terms of optimization atm is the need to remoteExec
	 and pass large arrays over the network. Shouldn't be doing this if at all possible and 
	 on top of that, it is done multiple times for several different functions pushing the same arrays.
	 
	If anything, send the arrays once. Could use the drop string as a reference for a global/string to work from.
	 Have a function that sets these globals and one that deletes them. Both of which would be trigggered by the server.
*/


#define SCRIPT_NAME "OPTRE_fnc_HEV"
#define HEV_LOG(MESSAGE) [SCRIPT_NAME,MESSAGE] call OPTRE_fnc_hevPatchLog;
#define DROP_TIME_BUFFER 0.35

if (!isServer) exitWith {
	HEV_LOG("Did not execute as machine is not server")
	false
};

params	[
	["_dropPosition",[0,0,0],[[]]],												
	["_units",[],[[]]],																
	["_shipDeployment","corvette",[""]],								
	["_launchDelay",30,[123]],														
	["_randomXYVelocity",2,[123]],													 
	["_launchSpeed",-1,[123]],																											
	["_startHeight",5000,[123]],														
	["_hevDropArmtmosphereStartHeight",3000,[123]],									
	["_hevDropArmtmosphereEndHeight",2000,[123]],										
	["_chuteDeployHeight",1000,[123]],												
	["_chuteDetachHeight",500,[123]],																										
	["_deleteShip",true,[true]],													
	["_deleteChutesOnDetach",true,[true]],											
	["_deleteHEVsAfter",600,[1]],													
	["_manualDrop",false,[true]]													
];


/* ----------------------------------------------------------------------------

	Parameters check

---------------------------------------------------------------------------- */
// Ensure atleast someone is alive to drop
private _return = _units findIf {alive _x};
if (_return isEqualTo -1) exitWith {
	HEV_LOG("Found no units alive, exited")
	false
};

// Force HEV dispersion
if (_randomXYVelocity < 2) then {
	HEV_LOG("Found _randomXYVelocity to be less then 2, made it 2")
	_randomXYVelocity = 2
}; 

// check if module or script was used and set proper launch delay if not
if !(_manualDrop) then {
	HEV_LOG("Not designated manual drop, set _launchDelay to 30")
	_launchDelay = 30
};

if (!_manualDrop AND {!_deleteChutesOnDetach}) then {
	HEV_LOG("Not designated manual drop, and _deleteChutesOnDetach was set to false. Set it to true")
	_deleteChutesOnDetach = true;
};

// checking if frigate is actually available as it is only in DEV build at the moment
if (_shipDeployment == "Frigate" AND {!(isClass (configfile >> "CfgVehicles" >> "OPTRE_Frigate_UNSC"))}) then {
	HEV_LOG("Did not find frigate object loaded, defaulting to Corvette")
	_shipDeployment = "Corvette";
};

/* ----------------------------------------------------------------------------

	Spawn HEVs

---------------------------------------------------------------------------- */
private "_ship";

// spawn HEVs and get their info for the drop. Also creates frigate or corvette
private _dropDataArray = call {
	_dropPosition set [2,_startHeight];
	//_dropPosition = [(_dropPosition select 0), (_dropPosition select 1), _startHeight]; 
	if (_shipDeployment == "corvette") exitWith {
		HEV_LOG("Selected Corvette drop")

		private _shipParts = [_dropPosition] call OPTRE_fnc_createCorvette;
		_ship = _shipParts select 0;
		_ship setVariable ["OPTRE_shipParts",_shipParts];
		
		private _return = [_ship,_units] call OPTRE_fnc_spawnHEVsCorvette;

		_return
	};

	if (_shipDeployment == "frigate") exitWith {
		HEV_LOG("Selected Frigate drop")

		_ship = "OPTRE_Frigate_UNSC" createVehicle [0,0,0];	
		_ship setVariable ["OPTRE_shipParts",[_ship]];
		_ship setPosATL _dropPosition;
		_ship setVectorUp [0,0,1];

		private _return = [_ship,_units] call OPTRE_fnc_spawnHEVsFrigate;

		_return
	};

	if (_shipDeployment == "No Ship") exitWith {
		HEV_LOG("Selected No Ship drop")

		// this is a dummy ship used to attach the HEVs to so that they do not fall before launch
		private _logicCenter = createCenter sideLogic;
		private _logicGroup = createGroup _logicCenter;
		_ship = _logicGroup createUnit ["Logic", [0,0,0], [], 0, "NONE"];
		_ship setVariable ["OPTRE_shipParts",[_ship]];
		_ship setPosATL _dropPosition;

		private _return = [_units,_startHeight,_ship] call OPTRE_fnc_spawnHEVsNoFrigate;
		
		_return
	};
	// no ship custom spawns units at requested drop zone instead of directly above their position 
	if (_shipDeployment == "No Ship Custom") exitWith {
		HEV_LOG("Selected No Ship Custom drop")

		// this is a dummy ship used to attach the HEVs to so that they do not fall before launch
		private _logicCenter = createCenter sideLogic;
		private _logicGroup = createGroup _logicCenter;
		_ship = _logicGroup createUnit ["Logic", [0,0,0], [], 0, "NONE"];
		_ship setVariable ["OPTRE_shipParts",[_ship]];
		_ship setPosATL _dropPosition;

		private _return = [_units,_startHeight,_ship,true] call OPTRE_fnc_spawnHEVsNoFrigate;
		
		_return
	};

	if (_shipDeployment != "corvette" AND {_shipDeployment != "No Ship"} AND {_shipDeployment != "Frigate"} AND {_shipDeployment != "No Ship Custom"}) exitWith {
		[SCRIPT_NAME,["Unsuported drop type",_shipdeployment,"used"]] call OPTRE_fnc_hevPatchLog;
		"Unsupported STRING entry for _shipDeployment parameter" call BIS_fnc_error;
		false
	};
};

// sort _dropDataArray data from spawn script
private _allHEVsInDrop = _dropDataArray select 0;
private _playerHEVs = _dropDataArray select 1;	
private _aiHEVs = _dropDataArray select 2;// not used ???		
private _playersInDrop = _dropDataArray select 3;		
private _aiInDrop = _dropDataArray select 4; // not used ???

[SCRIPT_NAME,["Found players in drop:",_playerHEVs]] call OPTRE_fnc_hevPatchLog;

/* ----------------------------------------------------------------------------

	Start Drop Count Down
	
---------------------------------------------------------------------------- */
// Prepare unique strings for events, this is so multiple drops can happen at once
private _HEVLaunchNumber = missionNamespace getVariable ["OPTRE_HEVLaunchNumber",1];
missionNamespace setVariable ["OPTRE_HEVLaunchNumber",_HEVLaunchNumber + 1];
private _HEVLaunchNumberString = str _HEVLaunchNumber;
private _countDownDoneEventString = ["OPTRE_HEV_countDownDoneEvent",_HEVLaunchNumberString] joinString "_";

[SCRIPT_NAME,["HEV launch number is:",_HEVLaunchNumberString,"Count down done event string is:",_countDownDoneEventString]] call OPTRE_fnc_hevPatchLog;


//// Determine need for player scripts or just AI

// if there are no players, just launch pods after delay
if !(_playersInDrop isEqualTo []) then {
	HEV_LOG("No Players found in drop, going to server event")

	[
		{
			[SCRIPT_NAME,["Server event",_countDownDoneEventString,"sent. Countdown done"]] call OPTRE_fnc_hevPatchLog;

			[_this select 0] call CBA_fnc_serverEvent;
		},
		[_countDownDoneEventString],
		_launchDelay
	] call CBA_fnc_waitAndExecute;

// if there are players:
} else {
	HEV_LOG("Players found in drop")
	// call countdown function on all players who will drop
	private _firstPlayerInDrop = _playersInDrop select 0;
	[_launchDelay,"Launch In",_firstPlayerInDrop,_countDownDoneEventString] remoteExecCall ["OPTRE_fnc_countDown",_playersInDrop];
	
	{
		null = [_x,_forEachIndex,_launchDelay] spawn {
			params ["_hev","_launchIndex","_launchDelay"];

			waitUntil {
				sleep 0.1;
				if !(isNull (gunner _hev)) exitWith {true};
				false
			};

			private _hevPilot = gunner _hev;
			if (_hevPilot in allPlayers) then {
				[_launchIndex,_launchDelay,_hevPilot] remoteExecCall ["OPTRE_fnc_PlayerHEVEffectsUpdate_PlayTones",_hevPilot];
			};
		};
	/*	
		[
			{!isNull (gunner (_this select 0))},
			{
				params [
					["_hev",objNull,[objNull]],
					["_launchIndex",0,[1]],
					["_launchDelay",30,[1]]
				];
				private _gunner = gunner _hev;

				if (_gunner in allPlayers) then {
					[_launchIndex,_launchDelay,_gunner] remoteExecCall ["OPTRE_fnc_PlayerHEVEffectsUpdate_PlayTones",_gunner];
				};
			},
			[_x,_forEachIndex,_launchDelay],
			300
		] call CBA_fnc_waitUntilAndExecute;
	*/

	} forEach _allHEVsInDrop;
	
};


/* ----------------------------------------------------------------------------

	Down Booster Effects Event
	
---------------------------------------------------------------------------- */
// Server event fires when count down is complete
private _lastPod = _allHEVsInDrop select ((count _allHEVsInDrop) - 1);
[
	_countDownDoneEventString, 
	{
		HEV_LOG("Executing the countdown done server event")

		_thisArgs params [
			"_allHEVsInDrop",
			"_randomXYVelocity",
			"_launchSpeed",
			"_hevDropArmtmosphereStartHeight",
			"_ship",
			"_deleteShip",
			"_lastPod",
			"_HEVLaunchNumber"
		];

		{
			[
				{
					private _hev = _this select 0;

					_this remoteExec ["OPTRE_fnc_HEVBoosterDown",gunner _hev];
					
					[SCRIPT_NAME,["Sent booster down to HEV",_hev]] call OPTRE_fnc_hevPatchLog;
				},
				[_x,_randomXYVelocity,_launchSpeed,_hevDropArmtmosphereStartHeight,_ship,_deleteShip,_lastPod,_HEVLaunchNumber],
				_forEachIndex * DROP_TIME_BUFFER // provide a buffer between each pods drop
			] call CBA_fnc_waitAndExecute;
		} forEach _allHEVsInDrop;

		[_thisType, _thisId] call CBA_fnc_removeEventHandler;
	}, 
	[_allHEVsInDrop,_randomXYVelocity,_launchSpeed,_hevDropArmtmosphereStartHeight,_ship,_deleteShip,_lastPod,_HEVLaunchNumber]
] call CBA_fnc_addEventHandlerArgs;


/* ----------------------------------------------------------------------------

	Atmosphere Entry Effects
	
---------------------------------------------------------------------------- */
null = [_allHEVsInDrop,_hevDropArmtmosphereEndHeight,_hevDropArmtmosphereStartHeight] spawn {
	params [
		"_allHEVsInDrop",
		"_hevDropArmtmosphereEndHeight",
		"_hevDropArmtmosphereStartHeight"
	];
	
	private _firstPod = _allHEVsInDrop select 0;
	waitUntil {getPosATLVisual (_firstPod select 2) < _hevDropArmtmosphereStartHeight};

	_allHEVsInDrop apply {
		[_x,_hevDropArmtmosphereEndHeight,_hevDropArmtmosphereStartHeight] remoteExecCall ["OPTRE_fnc_HEVAtmoEffects",gunner _x];
		sleep 0.1;
	};
};
/*
	[	// waitUntil first pod is at the _hevDropArmtmosphereStartHeight
		{getPosATLVisual (_this select 5) select 2 < (_this select 4)},
		{	
			params [
				["_allHEVsInDrop",[],[[]]],
				["_playerHEVs",[],[[]]],
				["_playersInDrop",[],[[]]],
				["_hevDropArmtmosphereEndHeight",2000,[1]],
				["_hevDropArmtmosphereStartHeight",3000,[1]]
			];

			_allHEVsInDrop apply {
				private _hev = _x;
				[_hev,_playerHEVs,_playersInDrop,_hevDropArmtmosphereEndHeight,_hevDropArmtmosphereStartHeight] remoteExec ["OPTRE_fnc_HEVAtmoEffects",gunner _hev];
			};
		},
		[_allHEVsInDrop,_playerHEVs,_playersInDrop,_hevDropArmtmosphereEndHeight,_hevDropArmtmosphereStartHeight,_allHEVsInDrop select 0],
		300
	] call CBA_fnc_waitUntilAndExecute;
*/

/* ----------------------------------------------------------------------------

	Chute Open
	
---------------------------------------------------------------------------- */
private _handleLandingEventString = [HANDLE_LANDING_STRING,_HEVLaunchNumberString] joinString "_";
private _chuteArrayVarString = [CHUTE_ARRAY_STRING,_HEVLaunchNumberString] joinString "_";
private _chuteArrayEventString = _chuteArrayVarString + "_addToEvent";

[
	{
		private _allHEVsInDrop = _this deleteAt 0;
		// replace _lastPod with bool
		private _lastPod = _this select 3;
		_this set [4,false];

		_allHEVsInDrop apply {
			private _hev = _x;
			if (_hev isEqualTo _lastPod) then {
				_this set [3,true]; 
			};

			([_hev] + _this) remoteExecCall ["OPTRE_fnc_HEVChuteDeploy",gunner _hev];
		};
	},
	[_allHEVsInDrop,_chuteDeployHeight,_chuteDetachHeight,_deleteChutesOnDetach,_lastPod,_HEVLaunchNumberString],
	5
] call CBA_fnc_waitAndExecute;


// create event to add chutes from clients to server deletion pile. This is to make it easier to pass the chute without a function
private _chuteArrayEventID = [
	_chuteArrayEventString, 
	{
		_this params [
			["_chute",objNull,[objNull]]
		];

		_thisArgs params [
			["_chuteArrayVarString","",[""]]
		];

		if (isNull _chute) exitWith {
			"null _chute passed to OPTRE_addChuteToDeletion" call BIS_fnc_error;
		};

		private _chuteArray = missionNamespace getVariable [_chuteArrayVarString,[]];
		_chuteArray pushBack _chute;
		missionNamespace setVariable [_chuteArrayVarString,_chuteArray];
	}, 
	[_chuteArrayVarString]
] call CBA_fnc_addEventHandlerArgs;


// remove unique eventHandler when the _chuteArrayEventString global variable isNil
[
	{isNil (_this select 0)},
	{
		params [
			["_chuteArrayEventString","",[""]],
			["_chuteArrayEventID",0,[123]]
		];

		[_chuteArrayEventString,_chuteArrayEventID] call CBA_fnc_removeEventHandler;
	},
	[_chuteArrayEventString,_chuteArrayEventID],
	300
] call CBA_fnc_waitUntilAndExecute;




/* ----------------------------------------------------------------------------

	Handle Landing
	
---------------------------------------------------------------------------- */
// Server event
[
	_handleLandingEventString, 
	{
		_thisArgs params [
			["_allHEVsInDrop",[],[[]]],
			["_chuteDeployHeight",1000,[123]]
		];

		
		_allHEVsInDrop apply {
			private _hev = _x;
			[_hev,_chuteDeployHeight] remoteExecCall ["OPTRE_fnc_HEVHandleLanding",gunner _hev];
		};
		

		[_thisType, _thisId] call CBA_fnc_removeEventHandler;
	}, 
	[_allHEVsInDrop,_chuteDeployHeight]
] call CBA_fnc_addEventHandlerArgs;

/* ----------------------------------------------------------------------------

	Clean Up
	
---------------------------------------------------------------------------- */
// delete corvette
if (!isNull _ship AND {_deleteShip}) then {
	
	private _deleteShipString = ["OPTRE_HEV_deleteShipEvent",_HEVLaunchNumber] joinString "_";
	[
		{missionNamespace getVariable [_this select 0,false]},
		{
			private _ship = _this select 1;

			if (isNil {_ship getVariable "OPTRE_shipParts"}) then {
				deleteVehicle _ship;
			} else {
				(_ship getVariable "OPTRE_shipParts") apply {
					deleteVehicle _x;
				};
			};
		},
		[_deleteShipString,_ship],
		300
	] call CBA_fnc_waitUntilAndExecute;
};


// delete clutter
private _deleteReadyString = [DELETE_READY_VAR_STRING,_HEVLaunchNumber] joinString "_";
[	
	// first condition: if any in _allHEVsInDrop have Z velocity wait, the secondary condition variable is so that it is not deleted when pods are hanging waiting for the drop
	{(((_this select 0) findIf {((velocity _x) select 2) != 0}) isEqualTo -1) AND {missionNamespace getVariable [_this select 4,false]}},
	{
		params [
			["_allHEVsInDrop",[],[[]]],
			["_chuteArrayVarString","",[""]],
			["_deleteChutesOnDetach",false,[true]],
			["_deleteHEVsAfter",600,[123]]
		];

		if !(_deleteChutesOnDetach) then {
			[missionNamespace getVariable [_chuteArrayVarString,[]],false] spawn OPTRE_fnc_CleanUp;
			missionNamespace setVariable [_chuteArrayVarString,nil];
		};

		[_allHEVsInDrop,_deleteHEVsAfter] spawn OPTRE_fnc_HEVCleanUp;
	},
	[_allHEVsInDrop,_chuteArrayVarString,_deleteChutesOnDetach,_deleteHEVsAfter,_deleteReadyString],
	300
] call CBA_fnc_waitUntilAndExecute;


true