/* ----------------------------------------------------------------------------
Function: OPTRE_Fnc_SpawnHEVsNoFrigate

Description:
	Creates pods and moves the units into the pods above their position.
	
	Modifications: Adapted for use on dedicated servers, improved performance/readability

Parameters:

	0: _units <ARRAY> - The units to teleport into the pods
	1: _startHeight <OBJECT> - The ship to attach the pods to

Returns:
	_allHEVs <ARRAY> - contains information pertinent to OPTRE_Fnc_HEV
		- _hevArray <ARRAY> - All created HEVs (both AI & players)
		- _hevArrayPlayer <ARRAY> - All HEVs created for players
		- _hevArrayAi <ARRAY> - All HEVs created for AI
		- _listOfPlayers <ARRAY> - All players in the drop sequence
		- _listOfAI <ARRAY> - All AI in the drop sequence

Examples:
    (begin example)

		[[player1,player2],5500] call OPTRE_Fnc_SpawnHEVsNoFrigate;

    (end)

Author:
	Big_Wilk,
	Modified by: Ansible2 // Cipher
---------------------------------------------------------------------------- */

params [
	["_units",[],[[]]],
	["_startHeight",5500,[1]]
];

// prepare return information
private _hevArray = [];			
private _hevArrayPlayer = [];	
private _hevArrayAi = [];		
private _listOfPlayers = [];	 
private _listOfAI = [];

// for comparison to copy cargo
private _standardPodCargo = [[["OPTRE_Biofoam"],[2]],[["OPTRE_ELB47_Strobe",1],["OPTRE_M8_Flare",1],["OPTRE_M8_Flare",1],["OPTRE_M8_Flare",1],["OPTRE_M8_Flare",1],["OPTRE_M2_Smoke_Purple",1],["OPTRE_M2_Smoke_Purple",1]],[],[]];

private _fn_OPTRESpawnHEVs = {
	params [
		["_unit",objNull,[objNull]],
		["_hevArray",[],[[]]],
		["_hevArrayPlayer",[],[[]]],
		["_hevArrayAi",[],[[]]],
		["_listOfPlayers",[],[[]]],
		["_listOfAi",[],[[]]]
	];

	if (alive _unit) then {
		
		private _unitPos = getPosATL _unit;
		private _spawnPos = [(_unitPos select 0),(_unitPos select 1),_startHeight];
		
		// create HEV
		private _hev = createVehicle ["OPTRE_HEV", [0,0,0], [], 0, "NONE"];
		_hev setPosATL _spawnPos;
		
		// copy cargo over
		private _copyCargo = _unit getVariable ["OPTRE_podCargo",[]];
		
		if (!(_copyCargo isEqualTo []) AND {!(_copyCargo isEqualTo _standardPodCargo)}) then {
			clearWeaponCargoGlobal _hev;
			clearMagazineCargoGlobal _hev;
			clearItemCargoGlobal _hev;
			clearBackpackCargoGlobal _hev;

			[_hev,_copyCargo] call OPTRE_fnc_addContainerCargo;
		};
		
		private _unitDir = getDir _unit;
		_hev setDir _unitDir;
		
		_hev lock true; 
		_hevArray pushBack _hev;
		
		// move the unit into their pod and make them invincible
		[_unit,_hev] remoteExecCall ["moveIngunner", _unit, false];
		[_unit,false] remoteExecCall ["allowDamage", _unit, false];
		
		// sort players and AI 
		if (_unit in (call CBA_fnc_players)) then {
			[_unit,"INTERNAL"] remoteExecCall ["switchCamera", _unit, false];
			_listOfPlayers pushBack _unit; 
			_hevArrayPlayer pushBack _hev;
			_hev setVariable ["OPTRE_PlayerControled",true];
		} else {
			_listOfAI pushBack _unit; 
			_hevArrayAi pushBack _hev;
		};
	};
};

_units apply {
	[_x,_hevArray,_hevArrayPlayer,_hevArrayAi,_listOfPlayers,_listOfAI] call _fn_OPTRESpawnHEVs;
};

[_hevArray,_hevArrayPlayer,_hevArrayAi,_listOfPlayers,_listOfAI]