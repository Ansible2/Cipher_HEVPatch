params [
    ["_hev",objNull,[objNull]],
    ["_hevArrayPlayer",[],[[]]],
    ["_randomXYVelocity",1,[1]],
    ["_launchSpeed",1,[1]],
    ["_manualControl",0,[1]],
    ["_listOfPlayers",[],[[]]],
    ["_hevDropArmtmosphereStartHeight",3000,[1]], // unused as of 20200312
    ["_frigate",objNull,[objNull]],
    ["_deleteFrigate",true,[true]],
    ["_lastPod",objNull,[objNull]],
    ["_HEVLaunchNumber",1,[1]]
];

if (isNull (attachedTo _hev)) then {
    detach _hev;
};

if !(simulationEnabled _hev) then {
    _hev enableSimulationGlobal true;
};

playSound3D ["OPTRE_FunctionsLibrary\sound\PodDetach.ogg",_hev,false,getPosASL _hev,2,1,500];

_light = "#lightpoint" createVehicle [0,0,0];
[0,_hev,_light] remoteExecCall ["OPTRE_fnc_PlayerHEVEffectsUpdate_Light", _listOfPlayers, false];

_fire = "#particlesource" createVehicle [0,0,0]; 
_fire setParticleClass "Missile2";
_fire attachto [_hev,[0,-0.2,0.6]];

private _boosterLights = [_fire,_light];


if ((driver _hev) in (call CBA_fnc_players)) then {
        [(random _randomXYVelocity),(random _randomXYVelocity),_launchSpeed,_manualControl,_hev,_hevDropArmtmosphereStartHeight] call OPTRE_fnc_PlayerHEVEffectsUpdate_BoasterDown;
    } else {
        [_hev,[(random _randomXYVelocity),(random _randomXYVelocity),_launchSpeed]] remoteExecCall ["setVelocity",_hev];
};

if (!isNull _frigate AND {_deleteFrigate} AND {_hev isEqualTo _lastPod}) then {
    [
        {
            params ["_HEVLaunchNumber"];

            private _deleteFrigateString = ["OPTRE_HEV_deleteFrigateEvent",str _HEVLaunchNumber] joinString "_";

            missionNamespace setVariable [_deleteFrigateString,true,[0,2] select isMultiplayer];
        },
        [_HEVLaunchNumber],
        10
    ] call CBA_fnc_waitAndExecute;
};


sleep 2;

_boosterLights apply {deleteVehicle _x};