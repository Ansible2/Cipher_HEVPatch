//hint "boast up start";

_vehicle = _this select 0; 
_vehicle setCenterOfMass [0,0,-1];
//hint "boast up start";

while {(getposatl _vehicle select 2) > 10} do { 
   
  _vel = velocity _vehicle; 
  _height = (getposatl _vehicle select 2); 
  hintsilent format ["%1ms",(_vel select 2)]; 
  
 /* _vehicle addForce [
	[
		(random 2 + random -2),
		(random 2 + random -2),
		(40/_height)
	],[0,0,0]];
  */
  
  _vehicle setVelocity [ 
   (_vel select 0),  
   (_vel select 1),  
	-((getposatl _vehicle select 2) / (2 + (_height * 0.005)))
  ];

 
};

_vehicle setvelocity [0,0,0];
_vehicle setVariable ["OPTRE_HEV_DoorEjectedWanted",true,true];
//hint "boast up end";