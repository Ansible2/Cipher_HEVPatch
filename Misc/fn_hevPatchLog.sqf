params [
	"_scriptName",
	["_message",[],[[],""]]
];

diag_log ("Hev Patch Log......: " + _scriptName);
if (_message isEqualType []) then {
	_message = _message joinString " ";
};
diag_log _message;