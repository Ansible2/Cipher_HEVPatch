params [
	["_dropPosition",[0,0,0],[[]]]
];

private _namespace = call CBA_fnc_createNamespace;

private _corvetteInfo = [
	["OPTRE_tail",[0,0,-9.60278],[[0,1,0],[0,0,1]]],
	["OPTRE_engine_left",[-30.4727,3.19775,-9.59546],[[0,1,0],[0,0,1]]],
	["OPTRE_center",[0,47.0559,-9.60315],[[0,1,0],[0,0,1]]],
	["OPTRE_bridge",[-0.0151367,41.7659,-9.60638],[[0,1,0],[0,0,1]]],
	["OPTRE_center_nose",[0,86.6682,-9.60181],[[0,1,0],[0,0,1]]],
	["OPTRE_nose",[-0.0200195,125.304,-9.59991],[[0,1,0],[0,0,1]]],
	["OPTRE_engine_right",[30.4927,3.19775,-9.59546],[[0,1,0],[0,0,1]]]
];

private _corvetteObjects = [];

{
	_x params [
		["_type","",[""]],
		["_posRelative",[],[[]]],
		["_vectorsRelative",[],[[]]]
	];

	private _piece = createVehicle [_type, [0,0,0], [], 0, "CAN_COLLIDE"];
	_corvetteObjects pushBack _piece;
	
	if (_forEachIndex isEqualTo 0) then {
		_namespace setVariable ["corvetterCenter",_piece];
		_piece setPosATL _dropPosition;
		_piece setVectorDirAndUp _vectorsRelative;
	} else {
		private _center = _namespace getVariable "corvetterCenter";
		_piece setPosATL (_center modelToWorldVisual _posRelative);

		_piece setVectorDirAndUp [(_center vectorModelToWorldVisual (_vectorsRelative select 0)),(_center vectorModelToWorldVisual (_vectorsRelative select 1))];
	};

} forEach _corvetteInfo;

_namespace call CBA_fnc_deleteNamespace;

_corvetteObjects