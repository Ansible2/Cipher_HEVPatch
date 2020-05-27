if !(hasInterface) exitWith {};

params [
	["_launchIndex",0,[1]], // at what place in the launch order
	["_launchDelay",30,[1]],
	["_driver",objNull,[objNull]]
];

if !(alive _driver) exitWith {};

private _launchIndexDelay = (_launchIndex * 0.35) + 1;

[
	{
		params [
			["_driver",objNull,[objNull]]
		];

		if (alive _driver AND {!(isNull objectParent _driver)}) then {
			playsound "OPTRE_Sounds_HEV_Tone";
		};
	},	
	[_driver], 
	(_launchDelay - 3) + _launchIndexDelay
] call CBA_fnc_waitAndExecute;

if (_launchDelay > 20) then {

	[
		{
			params [
				["_driver",objNull,[objNull]]
			];

			if (alive _driver AND {!(isNull objectParent _driver)}) then {
				playsound "OPTRE_Sounds_HEV_EngineStart";
			};
		},	
		[_driver], 
		(_launchDelay - 20) + _launchIndexDelay
	] call CBA_fnc_waitAndExecute;	
};