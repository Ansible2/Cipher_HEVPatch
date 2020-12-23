/* ----------------------------------------------------------------------------
Function: OPTRE_fnc_HEVAtmoEffects

Description:
	Creates the burning effect of atmospheric entry on a local machine. 
    Then remoteExec's "OPTRE_fnc_PlayerHEVEffectsUpdate_Light" on other players in drop to sync effect.
    
    This is automatically called in the series of functions from "OPTRE_fnc_HEV".

Parameters:
	0: _hev <OBJECT> - The HEV to play the effect on.
    1: _hevDropArmtmosphereEndHeight <NUMBER> - The height at which effects will end.
    2: _hevDropArmtmosphereStartHeight <NUMBER> - The height at which effects will start.

Returns:
	NOTHING

Examples:
    (begin example)

		[playerHEV_1,2000,3000] call OPTRE_fnc_HEVAtmoEffects;

    (end)

Author:
	Big_Wilk,
	Modified by: Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define SCRIPT_NAME "OPTRE_fnc_HEVAtmoEffects"
scriptName SCRIPT_NAME;

params [
    ["_hev",objNull,[objNull]],
    ["_hevDropArmtmosphereEndHeight",2000,[1]],
    ["_hevDropArmtmosphereStartHeight",3000,[1]]
];

if (!alive _hev) exitWith {};

[	// waitUntil pod is below _hevDropArmtmosphereStartHeight
    {getPosATLVisual (_this select 0) select 2 < (_this select 4)},
    {
        params [
            ["_hev",objNull,[objNull]],
            ["_hevDropArmtmosphereEndHeight",2000,[1]],
            ["_hevDropArmtmosphereStartHeight",3000,[1]]
        ];

        [SCRIPT_NAME,["Pod is below atmo height",_hevDropArmtmosphereStartHeight,"starting effects"]] call OPTRE_fnc_hevPatchLog;

        private _light = "#lightpoint" createVehicle [0,0,0];
        _light attachTo [_hev, [0,1.5,-2]];
        // update effects for all players (local commands used)
        [1,_hev,_light] remoteExecCall ["OPTRE_fnc_PlayerHEVEffectsUpdate_Light",-2];
            
        private _fire = "#particlesource" createVehicle [0,0,0]; 
        _fire attachto [_hev, [0,0,-2]];
        [_fire,"IncinerateFire"] remoteExecCall ["setParticleClass",-2];

        private _hevPilot = gunner _hev;
        if (alive _hevPilot AND {isPlayer _hevPilot}) then { 
            [SCRIPT_NAME,["Found alive player in HEV:",_hev,"playing reEntry effects"]] call OPTRE_fnc_hevPatchLog;
            [40, _hev] call OPTRE_fnc_PlayerHEVEffectsUpdate_ReEntrySounds; 
        };

        
        // waitUntil HEV is at _hevDropArmtmosphereEndHeight to delete
        null = [_hev,_hevDropArmtmosphereEndHeight,[_fire,_light]] spawn {
            params ["_hev","_hevDropArmtmosphereEndHeight","_atmoEffects"];
            
            waitUntil {
                if ((getPosATLVisual _hev) select 2 < _hevDropArmtmosphereEndHeight) exitWith {true};
                sleep 0.1;
                false
            };

            [SCRIPT_NAME,[_hev,"reached end atmo effect height, deleting effects"]] call OPTRE_fnc_hevPatchLog;

            _atmoEffects apply {deleteVehicle _x};
        };

        /*
        // waitUntil HEV is at _hevDropArmtmosphereEndHeight to delete
        private _atmoEffects = [_fire,_light];
        [
            {getPosATLVisual (_this select 0) select 2 < _this select 1},
            {
                (_this select 2) apply {deleteVehicle _x};
            },
            [_hev,_hevDropArmtmosphereEndHeight,_atmoEffects],
            300
        ] call CBA_fnc_waitUntilAndExecute;
        */
    },
    [_hev,_hevDropArmtmosphereEndHeight,_hevDropArmtmosphereStartHeight],
    300
] call CBA_fnc_waitUntilAndExecute;