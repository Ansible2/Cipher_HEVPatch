params ["_unit"];

OPTRE_fnc_addHEVActions = {
	params ["_unit"];

	_unit addAction
	[
		"--Start Engine",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script

			["startUpNormal",(getPosASL (objectParent _caller)) vectorAdd [0,-0.25,0.5],75,3,true] call KISKA_fnc_playSound3D;


		},
		nil,		// arguments
		1.5,		// priority
		true,		// showWindow
		true,		// hideOnUse
		"",			// shortcut
		"true", 	// condition
		1,			// radius
		false,		// unconscious
		"",			// selection
		""			// memoryPoint
	];

	_unit addAction
	[
		"--ShutDown Engine",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script


		},
		nil,		// arguments
		1.5,		// priority
		true,		// showWindow
		true,		// hideOnUse
		"",			// shortcut
		"true", 	// condition
		1,			// radius
		false,		// unconscious
		"",			// selection
		""			// memoryPoint
	];

	_unit addAction
	[
		"--EWO Button",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script

			["startupEWO",(getPosASL (objectParent _caller)) vectorAdd [0,-0.25,0.5],75,3,true] call KISKA_fnc_playSound3D;
		},
		nil,		// arguments
		1.5,		// priority
		true,		// showWindow
		true,		// hideOnUse
		"",			// shortcut
		"true", 	// condition
		1,			// radius
		false,		// unconscious
		"",			// selection
		""			// memoryPoint
	];

	_unit addAction
	[
		"Go For Launch",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script


		},
		nil,		// arguments
		1.5,		// priority
		true,		// showWindow
		true,		// hideOnUse
		"",			// shortcut
		"true", 	// condition
		1,			// radius
		false,		// unconscious
		"",			// selection
		""			// memoryPoint
	];
};

_unit addAction
[
	"Open HEV Console",	// title
	{
		params ["_target", "_caller", "_actionId", "_arguments"]; // script

		hint "opened";

		[_caller] call OPTRE_fnc_addHEVActions;
	},
	nil,		// arguments
	1.5,		// priority
	true,		// showWindow
	true,		// hideOnUse
	"",			// shortcut
	"true", 	// condition
	1,			// radius
	false,		// unconscious
	"",			// selection
	""			// memoryPoint
];