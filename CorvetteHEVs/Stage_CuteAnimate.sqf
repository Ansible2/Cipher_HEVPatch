private ["_chute"];

_chute = _this select 0; 
 
while {!(isNull attachedTo _chute)} do { 
   
	{ 
		_chute animate [ 
			_x, 
			(random 0.5), 
			(random 0.5) 
		];  
	} forEach ["wing1_rotation","wing2_rotation","wing3_rotation","wing4_rotation"];
	 
	sleep (0.1 + (random 0.5)); 
  
};