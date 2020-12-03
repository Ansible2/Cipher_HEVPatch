/* ----------------------------------------------------------------------------
Function: OPTRE_fnc_CountDown

Description:
	Creates a countdown on the players screen.
	
	Executed on client.

	Modifications: Adapted for use on dedicated servers, improved performance/readability, made execute CBA server event for pods to release 

Parameters:

	0: _timeTotal <NUMBER> - The time for the countdown
	1: _text <STRING> - What text should apper in front of the countdown number
	2: _listOfPlayers <ARRAY> - A list of the players participating in the drop
	3: _countDownDoneEventString <STRING> - The event string to execute on the server upon completion of countdown

Returns:
	NOTHING

Examples:
    (begin example)

		[10,"Launch In",[player1,player2],"someString"] call OPTRE_fnc_CountDown;

    (end)

Author:
	Big_Wilk,
	Modified by: Ansible2 // Cipher
---------------------------------------------------------------------------- */
#define HEV_LOG(MESSAGE) ["OPTRE_fnc_countDown",MESSAGE] call OPTRE_fnc_hevPatchLog;

if (!hasInterface) exitWith {};

params [
	["_timeTotal",30,[123]],
	["_text","Launch In",[""]],
	"_firstPlayerUnit",
	["_countDownDoneEventString","",[""]]
];

HEV_LOG("Starting countdown")

for "_i" from 0 to _timeTotal do {
	[
		{
			params [
				["_timeTotal",1,[1]],
				["_text","Launch In",[""]]
			];
				
			if (_timeTotal > 1) then {
				playSound "FD_Finish_F"; 
			};
			 
			[(format ["<t color='#ff0000' size = '.55'>%2: %1</t>",_timeTotal,_text]),0,1.35,4,1,0/*,789*/] spawn BIS_fnc_dynamicText;
				
			if (_timeTotal isEqualTo 0) then {
				playSound "FD_Start_F";
				missionNamespace setVariable ["OPTRE_HEV_DRP_RDY",true];
				HEV_LOG("Countdown is done")
			};
		},
		[_timeTotal,_text],
		_i
	] call CBA_fnc_waitAndExecute;
	_timeTotal = _timeTotal - 1;
}; 

HEV_LOG("Wating for OPTRE_HEV_DRP_RDY")
//Try changing this to be the _hev's namespace again
[
	{missionNamespace getVariable ["OPTRE_HEV_DRP_RDY",false]},
	{
		HEV_LOG("OPTRE_HEV_DRP_RDY is now true")
		[
			{
				params [
					["_text","Launch In",[""]],
					"_firstPlayerUnit",
					["_countDownDoneEventString","",[""]]
				];

			
				missionNamespace setVariable ["OPTRE_HEV_DRP_RDY",false];

				[(format ["<t color='#ff0000' size = '.55'>%2: %1</t>",0,_text]),0,1.35,4,1,0/*,789*/] spawn BIS_fnc_dynamicText;

				if (local _firstPlayerUnit) then {
					HEV_LOG(["Local first player, sending",_countDownDoneEventString,"to server"])
					[_countDownDoneEventString] call CBA_fnc_serverEvent;
				};
			},
			_this,
			0.9
		] call CBA_fnc_waitAndExecute;
	},
	[_text,_firstPlayerUnit,_countDownDoneEventString],
	300
] call CBA_fnc_waitUntilAndExecute;