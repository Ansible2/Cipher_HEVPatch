if !(hasInterface) exitWith {};

params [
	["_hev",objNull,[objNull]]
];

private _driver = driver _hev;

if (isNull _driver OR {!alive _driver} OR {!(_driver in (call CBA_fnc_players))}) exitWith {};

[
	{(getPosATLVisual (_this select 0) select 2) <= 250},
	{
		playsound "OPTRE_Sounds_HEV_GroundAlarm";
	},
	[_hev]
] call CBA_fnc_waitUntilAndExecute; 
