/* 
	OPTRE_Fnc_CleanUp
	
	Description: Adds a object or objects to a list of objects to be deleted, if number of objects exceeds max allowed then the first objects added will be deleted.
	
	Author: Big_Wilk
	
	Return: true, when finished. 
	
	Note: If the variable OPTRE_CleanUpMaxRubish is set to -1 then the script will not delete any objects. OPTRE_CleanUpMaxRubish's default is -1. Incorrectly adding will destroy the clean up system.
	
	Prams:
	0: Array: Of objects to be added to list. 
	1: Bool: Should be brought to the front of the que to be deleted. 
	
	MP: Must be run by one machine, usually server. ]
	
	Example 1:
	[[_door,_pod],false] remoteExec ["OPTRE_fnc_CleanUp", 2, false];
	Result: Sends message from client to server, adding the objects _door and _pod to the clean up system.
	
*/

if !(isServer) exitWith {};

params [
	["_objectsToAdd",[],[[]]],
	["_priority",false,[true]]
];

if !(_objectsToAdd findIf {(typeName _x != "OBJECT")} isEqualTo -1) then {
	_objectsToAdd = _objectsToAdd select {typeName _x isEqualTo "OBJECT"};
};

private _cleanUpObjectArray = missionNamespace getVariable ["OPTRE_CleanUpObjectArray",[]];

if (_priority) then {
	_cleanUpObjectArray = _objectsToAdd + _cleanUpObjectArray; 
} else {
	_cleanUpObjectArray = _cleanUpObjectArray + _objectsToAdd; 
};

private _cleanUpMaxRubish = missionNamespace getVariable ["OPTRE_CleanUpMaxRubish",-1];
private _cleanUpObjectArray_size = count _cleanUpObjectArray;
if (_cleanUpMaxRubish < 0 OR {_cleanUpMaxRubish > _cleanUpObjectArray_size}) exitWith {};

if (_cleanUpObjectArray_size > _cleanUpMaxRubish) then {
	for "_i" from 0 to (_cleanUpObjectArray_size - _cleanUpMaxRubish) do {
		deleteVehicle (_cleanUpObjectArray select 0);
		_cleanUpObjectArray deleteAt 0; 
	};

	missionNamespace setVariable ["OPTRE_CleanUpObjectArray",_cleanUpObjectArray];
};


/*
if !isServer exitWith {};

_objectsToAdd = [_this,0,[]] call BIS_fnc_param;	
_priority = [_this,1,false] call BIS_fnc_param;	

if (typeName _objectsToAdd != "ARRAY") exitWith {};
if ({typeName _x != "OBJECT";} count _objectsToAdd > 0) exitWith {};

if (isNil "OPTRE_CleanUpObjectArray") then {OPTRE_CleanUpObjectArray = [];};
if (isNil "OPTRE_CleanUpMaxRubish") then {OPTRE_CleanUpMaxRubish = -1;};

if _priority then {
	OPTRE_CleanUpObjectArray = _objectsToAdd + OPTRE_CleanUpObjectArray; 
} else {
	OPTRE_CleanUpObjectArray = OPTRE_CleanUpObjectArray + _objectsToAdd; 
};

if (OPTRE_CleanUpMaxRubish < 0) exitWith {};

_arraySize = count OPTRE_CleanUpObjectArray; 
if (_arraySize > OPTRE_CleanUpMaxRubish) then {
	for "_i" from 0 to ((_arraySize - 1) - OPTRE_CleanUpMaxRubish) do {
		_object = OPTRE_CleanUpObjectArray select 0;
		OPTRE_CleanUpObjectArray = OPTRE_CleanUpObjectArray - [_object];
		deleteVehicle _object; 
	};
};
*/