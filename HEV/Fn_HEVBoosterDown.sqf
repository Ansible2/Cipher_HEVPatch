/* ----------------------------------------------------------------------------
Function: OPTRE_fnc_HEVBoosterDown

Description:
	Creates the shooting down effect for the HEV when dropping the pod.
    Also accelerates the pod.
    
    This is automatically called in the series of functions from "OPTRE_fnc_HEV".

Parameters:
	0: _hev <OBJECT> - The HEV being dropped.
    1: _randomXYVelocity <NUMBER> - The deviation by which the pod should randomly drift on the horixontal axis
    2: _launchSpeed <NUMBER> - Downward velocity to start at. (negative numbers only)
    3: _hevDropAtmosphereStartHeight <NUMBER> - The height at which re-entry effects will start.
    4: _ship <OBJECT> - The ship from which the pod dropped.
    5: _deleteShip <BOOL> - Should the ship be deleted after drop.
    6: _lastPod <OBJECT> - The last pod to be dropped from ship.
    7: _HEVLaunchNumber <NUMBER> - The unique drop number. (crucial to certain events to fire properly)

Returns:
	NOTHING

Examples:
    (begin example)

		[
            playerHEV_1,
            [playerHEV_1,playerHEV_2],
            2,
            -1,
            [player_1,player_2],
            3000,
            myShip,
            true,
            playerHEV_2,
            1
        ] call OPTRE_fnc_HEVBoosterDown;

    (end)

Author:
	Big_Wilk,
	Modified by: Ansible2 // Cipher
---------------------------------------------------------------------------- */
scriptName "OPTRE_fnc_HEVBoosterDown"

params [
    ["_hev",objNull,[objNull]],
    ["_randomXYVelocity",1,[1]],
    ["_launchSpeed",-1,[1]],
    ["_hevDropAtmosphereStartHeight",3000,[1]],
    ["_ship",objNull,[objNull]],
    ["_deleteShip",true,[true]],
    ["_lastPod",objNull,[objNull]],
    ["_HEVLaunchNumber",1,[1]]
];

[["Executing for HEV: ",_hev],false] call KISKA_fnc_log;

detach _hev;
playSound3D ["OPTRE_FunctionsLibrary\sound\PodDetach.ogg",_hev,false,getPosASL _hev,2,1,500];

private _light = "#lightpoint" createVehicle [0,0,0];
_light attachTo [_hev, [0,1.5,2.5]];

private _players = call CBA_fnc_players;
[0,_hev,_light] remoteExecCall ["OPTRE_fnc_PlayerHEVEffectsUpdate_Light",_players];
[["Sent light updates to all players for: ",_hev],false] call KISKA_fnc_log;

private _smoke = "#particlesource" createVehicle [0,0,0]; 
_smoke attachto [_hev,[0,-0.2,0.6]];
[_smoke,"Missile2"] remoteExecCall ["setParticleClass",_players];
[["Sent smoke particle update to all players for: ",_hev],false] call KISKA_fnc_log;


if (isPlayer (gunner _hev)) then {
    [["HEV: ",_hev," has player in it... Execing OPTRE_fnc_PlayerHEVEffectsUpdate_BoasterDown"],false] call KISKA_fnc_log;
    [(random _randomXYVelocity),(random _randomXYVelocity),_launchSpeed,_hev,_hevDropAtmosphereStartHeight] call OPTRE_fnc_PlayerHEVEffectsUpdate_BoasterDown;
} else {
    [["HEV: ",_hev," does not have a player in it, setting velocity directly."],false] call KISKA_fnc_log;
    [_hev,[(random _randomXYVelocity),(random _randomXYVelocity),_launchSpeed]] remoteExecCall ["setVelocity",_hev];
};


if ((_hev isEqualTo _lastPod) AND {_deleteShip} AND {!isNull _ship}) then {
    [["HEV: ",_hev," is the last pod in line up, wating to delete ship..."],false] call KISKA_fnc_log;

    [
        {
            params ["_HEVLaunchNumber"];
            private _deleteShipString = ["OPTRE_HEV_deleteShipEvent",_HEVLaunchNumber] joinString "_";
            missionNamespace setVariable [_deleteShipString,true,[0,2] select isMultiplayer];

            [["Sent delete ship string: ",_deleteShipString," to server"],false] call KISKA_fnc_log;
        },
        [_HEVLaunchNumber],
        10
    ] call CBA_fnc_waitAndExecute;
};


sleep 2;

[_smoke,_light] apply {deleteVehicle _x};

[["Deleted booster effects for HEV: ",_hev],false] call KISKA_fnc_log;