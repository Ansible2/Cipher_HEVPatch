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
		*/	tooltip = "Options: Activate the traditional HEV scripts, have none activated, master control panel, or individual HEV controlled.";
			expression = "[_this,_value] call OPTRE_fnc_corvetteHEVInit";
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
				class on2
				{
					name = "Activate Advanced HEV System (Pod Control Panel)";
					value = 3;
				};
			};
		
		};
		
	};
};