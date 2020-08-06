private ["_hev","_chute"];

_hev = _this select 0;

_chute = "OPTRE_HEV_Chute" createVehicle [0,0,0]; 
_chute attachTo [_hev, [0,-0.2,1.961]];

[_hev, [0,0,-10]] remoteExec ["setVelocity", _hev, false];
_hev setVariable ["OPTRE_HEVChute",_chute, true];

sleep .5;

if (isplayer (gunner _hev)) then {0 = [_chute] execVM "OPTRE_Corvette\HEV_Scripts\Stage_CuteAnimate.sqf";};

_chute disableCollisionWith _hev;
