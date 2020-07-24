/* 
	OPTRE_fnc_PlayerHEVEffectsUpdate_ReEntrySounds
	
	Description: Function is designed to be executed only from inside of the HEV scripts, do not execute it directly.
	
	Author: Big_Wilk, modified by Cipher
	
	Modifications: Adapted for use on dedicated servers, patched several bugs, improved performance/readability, moved into unscheduled environment
	
	Return: none
	
	Type: Call
*/
if !(hasInterface) exitWith {};

params [
	["_stopSoundHeight",40,[1]],
	["_hev",objNull,[objNull]]
];

if (typeOf _hev != "OPTRE_HEV" OR {!(alive (gunner _hev))}) exitWith {};

playSound "OPTRE_Sounds_ReEntryBuildUp";

[
	{playSound "OPTRE_Sounds_HEV_Interior_01";},
	0.75,
	[_stopSoundHeight,_hev],
	{},
	{},
	{
		_stopSoundHeight = (_this getVariable "params") select 0;
		_hev = (_this getVariable "params") select 1;

		(alive (gunner _hev)) AND {(getPosATLVisual _hev) select 2 > _stopSoundHeight}
	},
	{
		_stopSoundHeight = (_this getVariable "params") select 0;
		_hev = (_this getVariable "params") select 1;

		((!alive (gunner _hev)) OR ((getPosATLVisual _hev) select 2) < _stopSoundHeight)		
	}
] call CBA_fnc_createPerFrameHandlerObject;
