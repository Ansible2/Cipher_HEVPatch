class CfgPatches
{
	class Cipher_HEVPatch
	{
		units[]={};
		weapons[]={};
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"OPTRE_FunctionsLibrary",
			"OPTRE_Corvette",
			"OPTRE_Core",
			"CBA_main"
		};
	};
};
class CfgFunctions
{
	class OPTRE
	{
		class SupportSystem
		{
			class CS_ODSTHEV
			{
				file = "Cipher_HEVPatch\SupportSystem\Fn_CS_ODSTHEV.sqf";
			};
		};
		class CorvetteHEVs
		{
			file = "Cipher_HEVPatch\CorvetteHevs";
			class corvetteHEVInit
			{};
			class addHEVDialogAction
			{};
			class corvetteHEVLaunch
			{};
		};
		class HEV
		{
			class createCorvette
			{
				file = "Cipher_HEVPatch\HEV\Fn_createCorvette.sqf";
			};
			class HEV
			{
				file="Cipher_HEVPatch\HEV\Fn_HEV.sqf";
			};
			class HEVAtmoEffects
			{
				file = "Cipher_HEVPatch\HEV\Fn_HEVAtmoEffects.sqf";
			};
			class HEVBoosterDown
			{
				file = "Cipher_HEVPatch\HEV\Fn_HEVBoosterDown.sqf";
			};
			class HEVChuteDeploy
			{
				file = "Cipher_HEVPatch\HEV\Fn_HEVChuteDeploy.sqf"; 
			};
			class HEVCleanUp
			{
				file="Cipher_HEVPatch\HEV\Fn_HEVCleanUp.sqf";
			};
			/*
			class HEVControls
			{
				file = "Cipher_HEVPatch\HEV\Fn_HEVControls.sqf";
			};
			*/
			class SpawnFakeHEVRoom
			{
				file="Cipher_HEVPatch\HEV\Fn_SpawnFakeHEVRoom.sqf";
			};
			class SpawnHEVsCorvette
			{
				file="Cipher_HEVPatch\HEV\Fn_SpawnHEVsCorvette.sqf";
			};
			class SpawnHEVsFrigate
			{
				file="Cipher_HEVPatch\HEV\Fn_SpawnHEVsFrigate.sqf";
			};
			class SpawnHEVsNoFrigate
			{
				file="Cipher_HEVPatch\HEV\Fn_SpawnHEVsNoFrigate.sqf";
			};
			class PlayerHEVEffectsUpdate_BoasterDown
			{
				file="Cipher_HEVPatch\HEV\Fn_PlayerHEVEffectsUpdate_BoasterDown.sqf";
			};
			class PlayerHEVEffectsUpdate_Chute
			{
				file="Cipher_HEVPatch\HEV\Fn_PlayerHEVEffectsUpdate_Chute.sqf";
			};
			class PlayerHEVEffectsUpdate_GroundAlarm
			{
				file="Cipher_HEVPatch\HEV\Fn_PlayerHEVEffectsUpdate_GroundAlarm.sqf";
			};
			class PlayerHEVEffectsUpdate_Light
			{
				file="Cipher_HEVPatch\HEV\Fn_PlayerHEVEffectsUpdate_Light.sqf";
			};
			class PlayerHEVEffectsUpdate_ReEntrySounds
			{
				file="Cipher_HEVPatch\HEV\Fn_PlayerHEVEffectsUpdate_ReEntrySounds.sqf";
			};
			class PlayerHEVEffectsUpdate_PlayTones
			{
				file="Cipher_HEVPatch\HEV\Fn_PlayerHEVEffectsUpdate_PlayTones.sqf";
			};
			class HEVRoomDynamicSetupGrabUnits
			{
				file = "Cipher_HEVPatch\HEV\Fn_HEVRoomDynamicSetupGrabUnits.sqf"; 
			};
			class HEVHandleLanding
			{
				file = "Cipher_HEVPatch\HEV\Fn_HEVHandleLanding.sqf";
			};
			class HEVDoor
			{
				file = "Cipher_HEVPatch\HEV\Fn_HEVDoor.sqf";
			};
		};
		class MenuFunctions
		{
			class HEVRoom
			{
				file="Cipher_HEVPatch\MenuFunctions\Fn_HEVRoom.sqf";
			};
		};
		class Misc
		{
			class addContainerCargo
			{
				file="Cipher_HEVPatch\Misc\fn_addContainerCargo.sqf";
			};
			class CountDown
			{
				file="Cipher_HEVPatch\Misc\Fn_CountDown.sqf";
			};
			class CleanUp
			{
				file="Cipher_HEVPatch\Misc\Fn_CleanUp.sqf";
			};
			class getContainerCargo
			{
				file="Cipher_HEVPatch\Misc\fn_getContainerCargo.sqf";
			};
		};
		class Modules
		{
			class ModuleHEV
			{
				file = "Cipher_HEVPatch\Modules\Fn_ModuleHEV.sqf";
			};
			class ModuleHEVCleanUp
			{
				file = "Cipher_HEVPatch\Modules\Fn_ModuleHEVCleanUp.sqf"; 
			};
		};
	};
};

class CfgSounds
{
	sounds[] =
	{
		"OPTRE_Sounds_HEV_Tone",
		"OPTRE_HEV_GroundAlarm",
		"OPTRE_Sounds_HEV_EngineStart",
		"OPTRE_Sounds_HEV_Interior_01"
	};
	class OPTRE_Sounds_HEV_Tone
	{
		dlc = "HEV Patch";
		name = "[OPTRE] HEV Tone";
		sound[]=
		{
			"Cipher_HEVPatch\Sounds\OPTRE_HEV_Tone.ogg",
			1.25,
			1
		};
		author = "Cipher // Ansible2";
		titles[] = {};
	};
	class OPTRE_Sounds_HEV_GroundAlarm
	{
		dlc = "HEV Patch";
		name = "[OPTRE] HEV Ground Alarm";
		sound[] =
		{
			"Cipher_HEVPatch\Sounds\OPTRE_HEV_GroundAlarm.ogg",
			0.5,
			1
		};
		author = "Cipher // Ansible2";
		titles[] = {};
	};
	class OPTRE_Sounds_HEV_EngineStart
	{
		dlc = "HEV Patch";
		name = "[OPTRE] HEV Engine Start";
		sound[] =
		{
			"Cipher_HEVPatch\Sounds\OPTRE_HEV_EngineStart.ogg",
			2,
			1
		};
		author = "Cipher // Ansible2";
		titles[] = {};
	};	
	class OPTRE_Sounds_HEV_Interior_01
	{
		dlc = "HEV Patch";
		name = "[OPTRE] HEV Interior 01";
		sound[] =
		{
			"Cipher_HEVPatch\Sounds\OPTRE_HEV_InteriorLoop_01.ogg",
			1,
			1
		};
		author = "Cipher // Ansible2";
		titles[] = {};
	};
};

class CfgVehicles
{
	class House_F;
	/*
	class NonStrategic;
	class ThingX;
	class House_F;
	class Land;
	class LandVehicle : Land
	{
	};
	*/
	class OPTRE_UNSC_Drake : House_F
	{/*
		dlc = "OPTRE";
		scope = 2;
		scopeCurator = 2;
		vehicleClass = "OPTRE_UNSC_corvette_class";
		displayName = "UNSC Drake Class Corvette";
		model = "\OPTRE_Corvette\editorObject.p3d";
		author = "Article 2 Studios";
		editorCategory = "OPTRE_EditorCategory_Corvette";
		editorSubcategory = "OPTRE_EditorSubcategory_Corvette_Pieces";
		class Eventhandlers
		{
			init = "_this call OPTRE_fnc_Drake_Init";
			AttributesChanged3DEN = "_this call OPTRE_fnc_Drake_EdenInit";
			Dragged3DEN = "_this call OPTRE_fnc_Drake_PosUpdate";
			RegisteredToWorld3DEN = "_this call OPTRE_fnc_Drake_EdenInit";
			UnregisteredFromWorld3DEN = "_this call OPTRE_fnc_Drake_EdenDelete";
		};
	*/
		class Attributes
		{
			class OPTRE_Drake_LoadHEVSripts
			{/*
				control = "combo";
				property = "OPTRE_Drake_LoadHEVSripts";
				displayName = "Basic HEV Script";
				description = "This combo has three values.";
			*/	tooltip = "Options: Activate the traditional HEV scripts, have none activated, or have the advanced (player controlled) scripts active.";
				expression = "_this setVariable ['%s', _value, true]; if ((_this getVariable [""OPTRE_Drake_LoadHEVSripts"", 0]) < 1) then {0 = [_this, false] execVM ""Cipher_HEVPatch\HEV_Scripts\HEV.sqf"";};";
				
				defaultValue = 0;
			/*	typeName = "NUMBER";
				condition = "1";
			*/	
				class Values
				{
					class off
					{
						name = "Deactivate HEV System";
						value = 0;
					};
					class on1
					{
						name = "Activate HEV System";
						value = 1;
					};
					class on2
					{
						name = "Activate Advanced HEV System";
						value = 2;
					};
				};
			
			};
			
		};
	};
};
