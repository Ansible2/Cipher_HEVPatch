/* 
	OPTRE_fnc_PlayerHEVEffectsUpdate_Light
	
	Description: Function is designed to be executed only from inside of the HEV scripts, do not execute it directly.
	
	Author: Big_Wilk, modified by Cipher
	
	Modifications: Adapted for use on dedicated servers, patched several bugs, improved performance/readability
	
	Return: none
	
	Type: call
*/

params[
	["_lightEffect",1,[1]],
	["_hev",objNull,[objNull]],
	["_light",objNull,[objNull]]
];

switch _lightEffect do {
	case 0: {											// initial thruster effect
		_light setLightBrightness 0.3;
		_light setLightAmbient[1, 1, 0.5];
		_light setLightColor[0, 0, 1];
		_light attachTo [_hev, [0,1.5,2.5]];	
		_light setLightFlareSize 1;
		_light setLightDayLight true;
	};
	case 1: {										 	// REentry fire effect
		_light setLightBrightness 1;
		_light setLightAmbient[.9, .9, 0.3];
		_light setLightColor[.9, .9, 0.3];
		_light attachTo [_hev, [0,1.5,-2]];
		_light setLightDayLight true;		
	};
};