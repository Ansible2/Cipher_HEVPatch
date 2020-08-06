hint "reload";

_tail = _this select 0;
_hevArray = _tail getvariable ["OPTRE_DrakeCurrentlyAttachedHEVs",[]];
_newHevArray = [];

for "_i" from 1 to 6 do { 
	_tail animate [(format ["drop_door_%1_a_rot",_i]),0];
	_tail animate [(format ["drop_door_%1_b_rot",_i]),0];
};

{

	_hevInfo = _x;
	_hev = _x select 0;
	_hevNumber = _x select 1;
	
	if (isNull attachedTo _hev) then { // HEV not attached to anything
		
		deleteVehicle _hev; 
		
		_memPointName = format ["pod%1pos",_hevNumber]; 
		
		_hevNew = createVehicle ["OPTRE_HEV", [0,0,0], [], 0, "CAN_COLLIDE"]; 
		_hevNew attachTo [_tail, [0, 0.17, 1.05], _memPointName]; 
		_newHevArray pushBack [_hevNew,_hevNumber]; 
		
		_hevNew animate  ["main_door_rotation",1]; 
		_hevNew animate  ["left_door_rotation",1]; 
		_hevNew animate  ["right_door_rotation",1];
		
		_hevNew setVariable ["OPTRE_PlayerControled",true,true];	
		
	} else { // HEV attached to something
	
		_newHevArray pushBack _hevInfo;
		_hev animate  ["main_door_rotation",1];  
		_hev animate  ["left_door_rotation",1];  
		_hev animate  ["right_door_rotation",1]; 
		
	};
	
} forEach _hevArray; 

_tail setvariable ["OPTRE_DrakeAllowLaunch",true,true];
_tail setvariable ["OPTRE_DrakeCurrentlyAttachedHEVs",_newHevArray,true];