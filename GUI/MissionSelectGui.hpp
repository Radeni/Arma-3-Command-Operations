class MissionSelectGui
{
	idd = 1973;
	
	class ControlsBackground
	{
		class Background
		{
			type = 0;
			idc = 0;
			x = 0.0856061;
			y = 0.20707076;
			w = 0.6825758;
			h = 0.50681822;
			style = 0;
			text = "";
			colorBackground[] = {0.502,0.502,0.502,0.7529};
			colorText[] = {0.3451,0.9255,0.251,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		class Title
		{
			type = 0;
			idc = 1;
			x = 0.10000012;
			y = 0.22500001;
			w = 0.47500005;
			h = 0.07500005;
			style = 0;
			text = "Whatever Mission:";
			colorBackground[] = {0.3373,0.1216,0.1059,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.5);
			
		};
		class HeaderOne
		{
			type = 0;
			idc = 2;
			x = 0.10000002;
			y = 0.32500017;
			w = 0.37500006;
			h = 0.05000005;
			style = 0;
			text = "Mission parameters:";
			colorBackground[] = {1,1,1,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.3);
			
		};
		class MissionType
		{
			type = 0;
			idc = 3;
			x = 0.12500001;
			y = 0.4000002;
			w = 0.35000002;
			h = 0.05000015;
			style = 0;
			text = "Mission type: ";
			colorBackground[] = {1,1,1,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.1);
			
		};
		class EnemySide
		{
			type = 0;
			idc = 4;
			x = 0.12500001;
			y = 0.47500021;
			w = 0.35000002;
			h = 0.05000015;
			style = 0;
			text = "Enemy side:";
			colorBackground[] = {1,1,1,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.1);
			
		};
		class NatoIcon
		{
			type = 0;
			idc = 69;
			x = 0.60000008;
			y = 0.22500005;
			w = 0.12500003;
			h = 0.15000002;
			style = 0+48;
			text = "";
			colorBackground[] = {0.7804,0.8941,0.5882,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		
	};
	class Controls
	{
		class MissionTypeDrop
		{
			type = 4;
			idc = 5;
			x = 0.3000003;
			y = 0.40000018;
			w = 0.37500006;
			h = 0.05000003;
			style = 16+2+0;
			arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\RscCombo\arrow_combo_ca.paa";
			arrowFull = "\A3\ui_f\data\GUI\RscCommon\RscCombo\arrow_combo_active_ca.paa";
			colorBackground[] = {0.2,0.2,0.2,1};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorSelect[] = {1,0,0,1};
			colorSelectBackground[] = {0,0,0,1};
			colorText[] = {1,0.702,0.4,1};
			font = "PuristaMedium";
			maxHistoryDelay = 0;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundCollapse[] = {"\A3\ui_f\data\sound\RscCombo\soundCollapse",0.1,1.0};
			soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",0.1,1.0};
			soundSelect[] = {"\A3\ui_f\data\sound\RscCombo\soundSelect",0.1,1.0};
			wholeHeight = 0.3;
			class ComboScrollBar
			{
				color[] = {1,1,1,1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
				
			};
			
		};
		class EnemySideDrop
		{
			type = 4;
			idc = 6;
			x = 0.30000032;
			y = 0.47500019;
			w = 0.37500006;
			h = 0.05000003;
			style = 16+2+0;
			arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\RscCombo\arrow_combo_ca.paa";
			arrowFull = "\A3\ui_f\data\GUI\RscCommon\RscCombo\arrow_combo_active_ca.paa";
			colorBackground[] = {0.2,0.2,0.2,1};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorSelect[] = {1,0,0,1};
			colorSelectBackground[] = {0,0,0,1};
			colorText[] = {1,0.702,0.4,1};
			font = "PuristaMedium";
			maxHistoryDelay = 0;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundCollapse[] = {"\A3\ui_f\data\sound\RscCombo\soundCollapse",0.1,1.0};
			soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",0.1,1.0};
			soundSelect[] = {"\A3\ui_f\data\sound\RscCombo\soundSelect",0.1,1.0};
			wholeHeight = 0.3;
			class ComboScrollBar
			{
				color[] = {1,1,1,1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
				
			};
			
		};
	class Confirm
		{
			type = 1;
			idc = 7;
			x = 0.57500006;
			y = 0.62500007;
			w = 0.17500001;
			h = 0.07500004;
			style = 0+2;
			text = "Confirm";
			borderSize = 0;
			colorBackground[] = {0.702,0.702,0.702,1};
			colorBackgroundActive[] = {1,0,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
			
		};
		
	};
};