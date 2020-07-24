if !(hasInterface) exitWith {};

params [
	["_launchIndex",0,[1]], // at what place in the launch order
	["_launchDelay",30,[1]],
	["_gunner",objNull,[objNull]]
];

if !(alive _gunner) exitWith {};

private _launchIndexDelay = (_launchIndex * 0.35) + 1;

[
	{
		params [
			["_gunner",objNull,[objNull]]
		];

		if (alive _gunner AND {!(isNull objectParent _gunner)}) then {
			playsound "OPTRE_Sounds_HEV_Tone";
		};
	},	
	[_gunner], 
	(_launchDelay - 3) + _launchIndexDelay
] call CBA_fnc_waitAndExecute;

if (_launchDelay > 20) then {

	[
		{
			params [
				["_gunner",objNull,[objNull]]
			];

			if (alive _gunner AND {!(isNull objectParent _gunner)}) then {
				playsound "OPTRE_Sounds_HEV_EngineStart";
			};
		},	
		[_gunner], 
		(_launchDelay - 20) + _launchIndexDelay
	] call CBA_fnc_waitAndExecute;	
};