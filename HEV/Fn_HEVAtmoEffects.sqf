params [
    ["_hev",objNull,[objNull]],
    ["_hevArrayPlayer",[],[[]]],
    ["_listOfPlayers",[],[[]]],
    ["_hevDropArmtmosphereEndHeight",2000,[1]],
    ["_hevDropArmtmosphereStartHeight",3000,[1]]
];

if (!alive _hev) exitWith {};

[	// waitUntil pod is below _hevDropArmtmosphereStartHeight
    {getPosATLVisual (_this select 0) select 2 < _this select 4},
    {
        params [
            ["_hev",objNull,[objNull]],
            ["_hevArrayPlayer",[],[[]]],
            ["_listOfPlayers",[],[[]]],
            ["_hevDropArmtmosphereEndHeight",2000,[1]],
            ["_hevDropArmtmosphereStartHeight",3000,[1]]
        ]; 

        private _light = "#lightpoint" createVehicle [0,0,0];
        // update effects for all players (local commands used)
        [1,_hev,_light] remoteExecCall ["OPTRE_fnc_PlayerHEVEffectsUpdate_Light",_listOfPlayers];
            
        private _fire = "#particlesource" createVehicle [0,0,0]; 
        _fire setParticleClass "IncinerateFire";
        _fire attachto [ _hev, [0,0,-2]];

        private _atmoEffects = [_fire,_light];

        if (_hev in _hevArrayPlayer AND {alive (driver _hev)}) then { 
            [40, _hev] call OPTRE_fnc_PlayerHEVEffectsUpdate_ReEntrySounds; 
        };

        // waitUntil HEV is at _hevDropArmtmosphereEndHeight to delete
        [
            {getPosATLVisual (_this select 0) select 2 < _this select 1},
            {
                (_this select 2) apply {deleteVehicle _x};
            },
            [_hev,_hevDropArmtmosphereEndHeight,_atmoEffects]
        ] call CBA_fnc_waitUntilAndExecute;
    },
    [_hev,_hevArrayPlayer,_listOfPlayers,_hevDropArmtmosphereEndHeight,_hevDropArmtmosphereStartHeight]
] call CBA_fnc_waitUntilAndExecute;