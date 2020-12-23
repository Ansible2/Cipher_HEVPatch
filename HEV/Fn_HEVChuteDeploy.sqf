#include "..\string constants.hpp"
/* ----------------------------------------------------------------------------
Function: OPTRE_fnc_HEVChuteDeploy

Description:
	Creates the shooting down effect for the HEV when dropping the pod.
    Also accelerates the pod.
    
    This is automatically called in the series of functions from "OPTRE_fnc_HEV".

Parameters:
	0: _hev <OBJECT> - The HEV being dropped.
    1: _chuteDeployHeight <NUMBER> - The height to deploy chute and slow pod.
    2: _chuteDetachHeight <NUMBER> - The height to detach chute.
    3: _deleteChutesOnDetach <BOOL> - Automatically delete chutes after detach?
    4: _isLastPod <BOOL> - Is this the last pod in drop?
    5: _HEVLaunchNumberString <STRING> - The last pod to be dropped from ship.

Returns:
	NOTHING

Examples:
    (begin example)

		[
            playerHEV_1,
            1000,
            500,
            true,
            playerHEV_2,
            "OPTRE_HEV_handleLanding1",
            "OPTRE_HEV_chuteArray1"
        ] call OPTRE_fnc_HEVChuteDeploy;

    (end)

Author:
	Big_Wilk,
	Modified by: Ansible2 // Cipher
---------------------------------------------------------------------------- */
params [
    ["_hev",objNull,[objNull]],
	["_chuteDeployHeight",1000,[1]],
	["_chuteDetachHeight",500,[1]],
	["_deleteChutesOnDetach",false,[true]],
	["_isLastPod",false,[true]],
    ["_HEVLaunchNumberString","",[""]]
];

private _chute = "OPTRE_HEV_Chute" createVehicle [0,0,0];

//chute Deploy
[
    {(getPosATLVisual (_this select 0) select 2) <= (_this select 3)},
    {
        params [
            "_hev",
            "_chute",
            "_chuteDeployHeight",
            "_chuteDetachHeight",
            "_isLastPod",
            "_HEVLaunchNumberString"
        ];

        _chute attachTo [_hev, [0,-0.2,1.961]];;

        if (isPlayer (gunner _hev)) then {
            [_chute,_hev] call OPTRE_fnc_PlayerHEVEffectsUpdate_Chute;

            [_hev] call OPTRE_fnc_PlayerHEVEffectsUpdate_GroundAlarm;
        };

        [_hev,[0,0,45]] remoteExecCall ["setVelocityModelSpace",_hev];

        _chute animateSource ["wing1_rotation",0];
        _chute animateSource ["wing2_rotation",0];
        _chute animateSource ["wing3_rotation",0];
        _chute animateSource ["wing4_rotation",0];

        _chute disableCollisionWith _hev;
        
        if (_hev isEqualTo _isLastPod) then {
            private _handleLandingEventString = [HANDLE_LANDING_STRING,_HEVLaunchNumberString] joinString "_";
            [_handleLandingEventString] call CBA_fnc_serverEvent;
        };    
    
    },
    [_hev,_chute,_chuteDeployHeight,_chuteDetachHeight,_isLastPod,_HEVLaunchNumberString],
    300
] call CBA_fnc_waitUntilAndExecute;

//chute detach
[
    {(getPosATLVisual (_this select 0) select 2) <= (_this select 2)},   
    {
        params [
            "_hev",
            "_chute",
            "_chuteDetachHeight",
            "_deleteChutesOnDetach",
            "_isLastPod",
            "_HEVLaunchNumbertring"
        ];

        detach _chute;

        // setVelocity is a local command, remoteExec ensures jetison
        [_chute,[(random 2.5),(random 2.5),20]] remoteExecCall ["setVelocity",_chute];			

        // either delete on detach or add to server deletion pile
        if (_deleteChutesOnDetach) then {
            [
                {
                    deleteVehicle (_this select 0);
                },
                [_chute],
                1
            ] call CBA_fnc_waitAndExecute;
        } else {
            private _chuteArrayVarString = [CHUTE_ARRAY_VAR_STRING,_HEVLaunchNumberString] joinString "_";
            private _chuteArrayEventString = _chuteArrayVarString + "_addToEvent";
            [_chuteArrayEventString,[_chute]] call CBA_fnc_serverEvent;
        };

        
        if (_hev isEqualTo _isLastPod) then {
            private _deleteReadyString = [DELETE_READY_VAR_STRING,_HEVLaunchNumbertring] joinString "_";
            missionNamespace setVariable [_deleteReadyString,true,[0,2] select isMultiplayer];
        };
    },
    [_hev,_chute,_chuteDetachHeight,_deleteChutesOnDetach,_isLastPod,_HEVLaunchNumbertring],
    300
] call CBA_fnc_waitUntilAndExecute;