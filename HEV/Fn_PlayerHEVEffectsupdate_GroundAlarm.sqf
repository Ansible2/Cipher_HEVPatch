if !(hasInterface) exitWith {};

params [
	["_hev",objNull,[objNull]]
];

private _gunner = gunner _hev;

if (isNull _gunner OR {!alive _gunner} OR {!(_gunner in (call CBA_fnc_players))}) exitWith {};

[
	{(getPosATLVisual (_this select 0) select 2) <= 250},
	{
		playsound "OPTRE_Sounds_HEV_GroundAlarm";
	},
	[_hev]
] call CBA_fnc_waitUntilAndExecute; 
