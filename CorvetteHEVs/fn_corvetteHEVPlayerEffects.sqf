if (!hasInterface) exitWith {};

params ["_hev"];

if (isNull (objectParent _unit) OR {!alive _unit} OR {!(_unit in allPlayers)}) exitWith {};

resetCamShake;
addCamShake [21, 6, 31];
addCamShake [11, 16, 32];

// this logic is used to play the wind sound using say2D so that the logic can be deleted at anytime, stopping the sound
private _logicCenter = createCenter sideLogic;
private _logicGroup = createGroup _logicCenter;
private _logic = _logicGroup createUnit ["Logic", [0,0,0], [], 0, "NONE"];
_logic attachTo [_hev,[0,0,0]];

// start engine
playSound "OPTRE_corvetteHEV_engineEWOStart";

sleep 17.23;
private ["_alt","_aglPos"]; 
waitUntil {
	_aglPos = ASLToAGL (getPosASLVisual _hev);
	_alt = _aglPos select 2;
	if (_alt < 2) exitWith {
		private _hevVectorDir = vectorDirVisual _hev;
		private _hevVectorUp = vectorUpVisual _hev;
		_hev setPosASL  ASLToAGL ([_pos select 0,_pos select 1,0]);
		_hev setVectorDirAndUp [_hevVectorDir,_hevVectorUp];
		
		playSound3d ["A3\Sounds_F\sfx\missions\vehicle_collision.wss", _hev,false, getPosASL _hev, 0.5, 1, 1000];
		
		true
	};
};

[
	{	((_this getVariable "params") select 2) say2D "OPTRE_Sounds_WindLoopNewLong";	},// func
	
	1,// delay
	
	[_hev,_hevDropArmtmosphereStartHeight,_logic], // args
	
	{	((_this getVariable "params") select 2) say2D "OPTRE_Sounds_WindLoopNewLong";	}, // start code
	
	{	deleteVehicle ((_this getVariable "params") select 2);	},// end code
	
	{
		_hev = (_this getVariable "params") select 0;
		_hevDropArmtmosphereStartHeight = (_this getVariable "params") select 1;

		(	(getPosATLVisual _hev) select 2 < _hevDropArmtmosphereStartHeight	)
	},// condition to start
	
	{
		_hev = (_this getVariable "params") select 0;

		(	!alive (gunner _hev) OR {(getPosATL _hev) select 2 < 20} OR {(velocity _hev) select 2 isEqualTo 0}	)
	},// condition to delete
	{}// local vars
] call CBA_fnc_createPerFrameHandlerObject;