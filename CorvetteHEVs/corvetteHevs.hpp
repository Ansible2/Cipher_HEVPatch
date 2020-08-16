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
				expression = "switch (_value) do { case 1: {[_this,false] call OPTRE_fnc_corvetteHEVInit}; case 2: {[_this,true] call OPTRE_fnc_corvetteHEVInit}; default {}; };";
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
					class on
					{
						name = "Activate HEV System";
						value = 1;
					};
					class on1
					{
						name = "Activate Advanced HEV System";
						value = 2;
					};
				};
			
			};
			
		};
	};
};

class cfgSounds
{
	// corvette HEV Stuff
	class OPTRE_corvetteHEV_engineDropLoop
	{
		dlc = "HEV Patch";
		name = "[OPTRE] Corvette HEV Drop Engine Loop";
		sound[]=
		{
			"Cipher_HEVPatch\Sounds\Corvette HEV\OPTRE_corvetteHEV_engineDropLoop.ogg",
			1,
			1
		};
		author = "Cipher // Ansible2";
		titles[] = {};
	};
	class OPTRE_corvetteHEV_engineEWOStart
	{
		dlc = "HEV Patch";
		name = "[OPTRE] Corvette HEV EWO Start";
		sound[]=
		{
			"Cipher_HEVPatch\Sounds\Corvette HEV\OPTRE_corvetteHEV_engineEWOStart.ogg",
			1,
			1
		};
		author = "Cipher // Ansible2";
		titles[] = {};
	};
	class OPTRE_corvetteHEV_engineIdleLoop
	{
		dlc = "HEV Patch";
		name = "[OPTRE] Corvette HEV EWO Start";
		sound[]=
		{
			"Cipher_HEVPatch\Sounds\Corvette HEV\OPTRE_corvetteHEV_engineIdleLoop.ogg",
			1,
			1
		};
		author = "Cipher // Ansible2";
		titles[] = {};
	};
	class OPTRE_corvetteHEV_engineNormalStart
	{
		dlc = "HEV Patch";
		name = "[OPTRE] Corvette HEV Normal Start";
		sound[]=
		{
			"Cipher_HEVPatch\Sounds\Corvette HEV\OPTRE_corvetteHEV_engineNormalStart.ogg",
			1,
			1
		};
		author = "Cipher // Ansible2";
		titles[] = {};
	};
	class OPTRE_corvetteHEV_engineShutdown
	{
		dlc = "HEV Patch";
		name = "[OPTRE] Corvette HEV Engine Shutdown";
		sound[]=
		{
			"Cipher_HEVPatch\Sounds\Corvette HEV\OPTRE_corvetteHEV_engineShutdown2.ogg",
			1,
			1
		};
		author = "Cipher // Ansible2";
		titles[] = {};
	};
};