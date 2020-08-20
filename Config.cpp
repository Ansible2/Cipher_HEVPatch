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
			//"OPTRE_Corvette",
			"OPTRE_modules",
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
	/*
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
	*/
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
			class playSound3D
			{
				file="Cipher_HEVPatch\Misc\fn_playSound3D.sqf";
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
		"OPTRE_sounds_HEV_Tone",
		"OPTRE_sounds_HEV_GroundAlarm",
		"OPTRE_sounds_HEV_EngineStart",
		"OPTRE_sounds_HEV_interiorDropLoop"
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
	class OPTRE_sounds_HEV_interiorDropLoop
	{
		dlc = "HEV Patch";
		name = "[OPTRE] Corvette HEV Drop Engine Loop";
		sound[] =
		{
			"Cipher_HEVPatch\Sounds\OPTRE_HEV_interiorDropLoop.ogg",
			1,
			1
		};
		author = "Cipher // Ansible2";
		titles[] = {};
	};
};

class cfgVehicles 
{
	class Module_F;
	class Module_OPTRE_HEV: Module_F
	{
		scope=2;
		displayName="HEV Module";
		icon="\OPTRE_Modules\data\picture\Icon_OPTRE.paa";
		category="OPTRE_HEV";
		function="OPTRE_fnc_ModuleHEV";
		functionPriority=99;
		isGlobal=0;
		isTriggerActivated=1;
		author="Article 2 Studios";
		is3DEN=0;
		class Arguments
		{
			class shipDeployment
			{
				displayName="Deployment Mode";
				description="This controls the drop scene for the players. The drop will always be directly above the module.";
				defaultValue="Corvette";
				typeName="STRING";
				class values
				{
					class n1
					{
						name="Deploy from Corvette";
						value="Corvette";
						default=1;
					};
					class n2
					{
						name="Deploy without ship";
						value="No Ship";
					};
					class n3
					{
						name="Deploy from Frigate";
						value="Frigate";
					};
				};
			};
			class LaunchDelay
			{
				displayName="Count Down Timer";
				description="This is the time that the HEVs will be hanging waiting until drop.";
				defaultValue="30";
				typeName="NUMBER";
			};
			class randomXYVelocity
			{
				displayName="Randomised X/Y Velocity";
				description="Random drift of pods on the horizontal axis. This must be at least 2 (otherwise the script will set it to 2) to minimize pods hitting each other.";
				defaultValue="2";
				typeName="NUMBER";
			};
			class launchSpeed
			{
				displayName="Down Velocity On Launch";
				description="A negative value of how fast the pods descend. Should keep at -1.";
				defaultValue="-1";
				typeName="NUMBER";
			};
			class manualControl
			{
				displayName="Player Control Of HEV";
				description="Depreciated Entry. No longer in use";
				defaultValue=1;
				typeName="NUMBER";
				class values
				{
					class n1
					{
						name="Empty";
						value=0;
					};
					class n2
					{
						name="Empty";
						value=1;
						default=1;
					};
				};
			};
			class startHeight
			{
				displayName="STAGE1: Start Height";
				description="Height that the pods will drop from. Recommend above 5000m";
				defaultValue="5000";
				typeName="NUMBER";
			};
			class hevDropArmtmosphereStartHeight
			{
				displayName="STAGE2A: Atmospheric Entry Height";
				description="At what height to engage the atmo entry fire effects. The difference between this and the start hieight shouldn't be more then 2000";
				defaultValue="3000";
				typeName="NUMBER";
			};
			class hevDropArmtmosphereEndHeight
			{
				displayName="STAGE2B: End Entry Height";
				description="At what height to end the entry atmo effects.";
				defaultValue="2000";
				typeName="NUMBER";
			};
			class chuteDeployHeightHeight
			{
				displayName="STAGE3A: Chute Deployment Height";
				description="Self explanitory.";
				defaultValue="1000";
				typeName="NUMBER";
			};
			class chuteDetachHeight
			{
				displayName="STAGE3B: Chute Detach Height";
				description="Self explanitory.";
				defaultValue="500";
				typeName="NUMBER";
			};
			class boasterHeight
			{
				displayName="STAGE4: Booster Up Height";
				description="Depreciated entry. No longer in use.";
				defaultValue="0";
				typeName="NUMBER";
			};
			class deleteFrigate
			{
				displayName="Delete Ship";
				description="If spawning with a ship, should it be deleted after drop?";
				defaultValue=1;
				typeName="BOOL";
				class values
				{
					class n1
					{
						name="Delete Ship";
						value=1;
						default=1;
					};
					class n2
					{
						name="Dont Delete Ship";
						value=0;
					};
				};
			};
			class deleteChutes
			{
				displayName="Delete Chutes After Detach";
				description="Should the chutes auto delete upon detach or be added to the cleanup module?";
				defaultValue=1;
				typeName="BOOL";
				class values
				{
					class n1
					{
						name="Add Chutes To HEV CleanUp Module";
						value=0;
						default=1;
					};
					class n2
					{
						name="Delete Chutes On Detach";
						value=1;
					};
				};
			};
			class deleteHEVafter
			{
				displayName="HEVs Can Be Delete After";
				description="If the cleanup module is present, HEVs will be deleted after X amount of seconds.";
				defaultValue="600";
				typeName="NUMBER";
			};
		};
	};
};


class OPTRE_UNSCMENU_RscButton;
class OPTRE_HEVPanel
{
	class controls
	{
		class OPTRE_UNSCMENU_RscButton_1602: OPTRE_UNSCMENU_RscButton
		{
			idc=1602;
			text="Launch Now";
			x="0.711406 * safezoneW + safezoneX";
			y="0.72 * safezoneH + safezoneY";
			w="0.134062 * safezoneW";
			h="0.055 * safezoneH";
			onButtonClick="if (getMarkerColor 'OPTRE_Local_HEVConsolePosMarker' != '') then {disableSerialization; _dialog = findDisplay 5600;_10 = (_dialog displayCtrl 10);_11 = (_dialog displayCtrl 11);_12 = (_dialog displayCtrl 12);_13 = (_dialog displayCtrl 13);_14 = (_dialog displayCtrl 14); _15 = (_dialog displayCtrl 15);_16 = (_dialog displayCtrl 16);0 = [[(getMarkerPos 'OPTRE_Local_HEVConsolePosMarker'),[],(_16 lbValue (lbCurSel _16)),30,2,-1,(_10 lbValue (lbCurSel _10)),(_11 lbValue (lbCurSel _11)),(_12 lbValue (lbCurSel _12)),(_13 lbValue (lbCurSel _13)),(_14 lbValue (lbCurSel _14)),true,(_15 lbValue (lbCurSel _15)),600],OPTRE_CurrentConsole] remoteExec [""OPTRE_Fnc_HEVRoomDynamicSetupGrabUnits"", 2, false];} else {playSound 'FD_CP_Not_Clear_F';};";
		};
	};
};

//#include "corvetteHevs\corvetteHevs.hpp";