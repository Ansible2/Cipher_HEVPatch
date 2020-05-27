/* 
	OPTRE_Fnc_HEVDoor
	
	Description: Can be used to open the HEVs door, or eject it, can also be to make ai or players eject from vehicle afterwards. 
	
	Author: Big_Wilk
	
	Type: Spawn
	
	Return: None
	
	Prams:
	0: Object: HEV
	1: Number: 0 = emergency eject door, 1 = open door
	2: Bool: true forces the HEV driver to leave the vehicle, false does nothing
	
	Example 1:
	0 = [vehicle player, 0, true] spawn OPTRE_Fnc_HEVDoor;
	Result: Door ejects, Player exits hev.
	
	Example 1:
	0 = [vehicle player, 1, false] spawn OPTRE_Fnc_HEVDoor;
	Result: Door opens, Player does not exits hev.
	
*/

/*
private ["_hev","_mode","_eject"];

_hev = vehicle ([_this,0,objNull] call BIS_fnc_param);
_mode = [_this,1,0] call BIS_fnc_param;
_eject = [_this,2,false] call BIS_fnc_param;
*/

params [
	["_hev",objNull,[objNull]],
	["_mode",0,[1]],
	["_eject",true,[true]]
];

null = switch _mode do {

	case 0: {
	
		private _dir = getDir _hev; 
		
		private _door = "OPTRE_HEV_Door" createVehicle [0,0,0];
		_door setDir (_dir - 180);
		_door attachTo [_hev,[0,1,0.5]];

		_hev setobjecttextureglobal [0,""];
		_hev setobjecttextureglobal [1,""];
		_hev setobjecttextureglobal [2,""];
		_hev setobjecttextureglobal [3,""];

		detach _door;
		_door setDir (_dir - 180);
		_door setVelocity ([velocity _hev, direction _hev, 20, 2] call OPTRE_fnc_GetVelocityWithAddedSpeedDirAndDown);
		
		playSound3d ["OPTRE_core\data\sounds\OPTRE_Sounds_HEV_Pop.ogg", _door, false, getPosASL _door, 5, 1, 250];

		[
			{
				[[_this select 0],false] remoteExecCall ["OPTRE_fnc_CleanUp", 2, false];
			},
			[_door],
			1.5
		] call CBA_fnc_WaitAndExecute;

	};
	
	case 1: {
		
		_hev animate ["main_door_rotation", 1]; 
		_hev animate ["left_door_rotation", 1]; 
		_hev animate ["right_door_rotation", 1];
		
	};
	
};


if (_eject) then {
	
	_hev setVelocity [0,0,0];

	[
		{
			params [
				["_hev",objNull,[objNull]]
			];
			private _driver = driver _hev; 

			_driver action ["getOut", _hev];
			_driver leaveVehicle _hev;
		},
		[_hev],
		1
	] call CBA_fnc_waitAndExecute;
};

