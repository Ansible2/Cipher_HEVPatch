/*
	OPTRE_fnc_HandleHEVLanding

	Description: Handles landing of HEVs, make sets drive vunrable to damaged after exit creates effects on landing. 

	Modifications: Optimized function, moved into unscheduled environment, reworked eventHandlers, fixed bugs

	Author: Big_Wilk; Modifiied by Cipher
	
	Return: BOOL
	
	Params: 
	0: HEv <Object>
	1: Chute deployment height (ATL) <Number>

*/

params [
	["_hev",objNull,[objNull]],
	["_chuteDeployHeight",1000,[123]]
];

[
	// waitUntil pod on ground OR below chute deploy height and Z velocity is zero OR hev height is less then or equal to 3 meters above sea level with waves
	{((getPosATL (_this select 0)) select 2 < 1) OR {((getPosATL (_this select 0)) select 2 < (_this select 1)) AND ((velocity (_this select 0)) select 2 isEqualTo 0)} OR {(getPosASLW (_this select 0) select 2) <= 3}},
	{
		private _hev = param [0,objNull,[objNull]];
		private _gunner = gunner _hev;

		private _hevPosition = getPosATLVisual _hev;
		private _hevVectorDir = vectorDirVisual _hev;
		private _hevVectorUp = vectorUpVisual _hev;
		_hev setPosATL [_hevPosition select 0,_hevPosition select 1,0];
		_hev setVectorDirAndUp [_hevVectorDir,_hevVectorUp];

		_hev setVariable ["OPTRE_HEV_Landed",true];
		
		playSound3d ["A3\Sounds_F\sfx\missions\vehicle_collision.wss", _hev,false, getPosASL _hev, 0.5, 1, 1000];
		
		if !(_gunner in (call CBA_fnc_players)) then {
			_hev lock false; 
			[_hev, round (random 1), true] call OPTRE_fnc_HEVDoor;
		} else {

			private _ejectActionID = _hev addAction ["--Eject HEV Door",{
				[(_this select 0), 0, true] call OPTRE_fnc_HEVDoor;
			}];

			_hev setVariable ["OPTRE_HEV_EjectActionID",_ejectActionID]; 

			private _openActionID = _hev addAction ["--Open HEV Doors And Get Out",{
				[(_this select 0), 1, true] call OPTRE_fnc_HEVDoor;
			}];

			_hev setVariable ["OPTRE_HEV_OpenActionID",_openActionID];
			
			addCamShake [40, 1.2, 50];
			resetCamShake;

			// should not be a global Variable, change when pods are added to local nameSpace Variable
			if (!isNil "OPTRE_HEV_CONTROL_KDEH") then {
				(findDisplay 46) displayRemoveEventHandler ["KeyDown", OPTRE_HEV_CONTROL_KDEH]; 
				_gunner removeEventHandler ["killed", OPTRE_HEV_CONTROL_KEH];
			};
		};
	},
	[_hev,_chuteDeployHeight]
] call CBA_fnc_waitUntilAndExecute;


_hev addEventHandler ["GetOut",{

	private _hev = param [0,objNull,[objNull]];
	private _gunner = param [2,objNull,[objNull]];
	
	// ai hev pilots (hopefully) wont hurt themselves if the pod jumps and they eject while it is rebounding in air
	if !(_gunner in (call CBA_fnc_players)) then {
		[
			{
				params [
					["_gunner",objNull,[objNull]]
				];
				
				[_gunner,true] remoteExecCall ["allowDamage",_gunner];
				[_gunner] remoteExec ["unassignVehicle",_gunner];
			},
			[_gunner],
			3
		] call CBA_fnc_waitAndExecute; 
	} else {
		[_gunner,true] remoteExecCall ["allowDamage",_gunner];
		resetCamShake;
	};

	if !(_hev getVariable ["OPTRE_HEV_Landed",true]) then {
		_hev setVariable ["OPTRE_HEV_Landed",true];
	};

	_hev removeAction ((_this select 0) getVariable ["OPTRE_HEV_EjectActionID",0]);
	_hev removeAction ((_this select 0) getVariable ["OPTRE_HEV_OpenActionID",1]);

	_hev removeEventHandler ["GetOut",_thisEventHandler];
}];

true