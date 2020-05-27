/* 
	OPTRE_fnc_PlayerHEVEffectsUpdate_Chute
	
	Description: Function is designed to be executed only from inside of the HEV scripts, do not execute it directly.
	
	Author: Big_Wilk, modified by Cipher
	
	Modifications: Adapted for use on dedicated servers, patched several bugs, improved performance/readability
	
	Return: none
	
	Type: call
*/

if (!hasInterface) exitWith {};

params [
	["_chute",objNull,[objNull]],
	["_hev",objNull,[objNull]]
];

if (typeOf _hev != "OPTRE_HEV") exitWith {};

_hev disableCollisionWith _chute;

playSound "OPTRE_Sounds_HEV_Chute";
addCamShake [20, 3, 20];