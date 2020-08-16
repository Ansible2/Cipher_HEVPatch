params [
	"_logic",
	["_units",[],[[]]]
];

_shipDeployment  = _logic getVariable ["shipDeployment","Corvette"];
_LaunchDelay  = _logic getVariable ["LaunchDelay",5];
_randomXYVelocity  = _logic getVariable ["randomXYVelocity",1];
_launchSpeed = _logic getVariable ["launchSpeed",-250];
//_manualControl  = _logic getVariable ["manualControl",1]; // old entry

_startHeight  = _logic getVariable ["startHeight",5500];
_hevDropArmtmosphereStartHeight = _logic getVariable ["hevDropArmtmosphereStartHeight",4000];
_hevDropArmtmosphereEndHeight = _logic getVariable ["hevDropArmtmosphereEndHeight",3000];
_chuteDeployHeightHeight = _logic getVariable ["chuteDeployHeightHeight",1000];
_chuteDetachHeight  = _logic getVariable ["chuteDetachHeight",500];
//_boasterHeight = _logic getVariable ["boasterHeight",100]; // old entry

_deleteFrigate = _logic getVariable ["deleteFrigate",1];
_deleteChutes = _logic getVariable ["deleteChutes",0];
_deleteHEVSafter = _logic getVariable ["deleteHEVafter",600];


waitUntil {time > 0};

{
	[
		getPos _logic, 
		_units, 
		_shipDeployment, 
		_LaunchDelay, 
		_randomXYVelocity, 
		_launchSpeed, 
		_startHeight,
		_hevDropArmtmosphereStartHeight,
		_hevDropArmtmosphereEndHeight,
		_chuteDeployHeightHeight,
		_chuteDetachHeight,
		_deleteFrigate,
		_deleteChutes,
		_deleteHEVSafter,
		true // denotes use of custom launch delay
	] call OPTRE_Fnc_HEV;
} call CBA_fnc_directCall;


true