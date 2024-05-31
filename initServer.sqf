taskIDGlobal = 0;
publicVariable "taskIDGlobal";
ambienceCount = 0;
publicVariable "ambienceCount";
doReset = true;
publicVariable "doReset";


COAllowAmbience = false;
if ("Ambience" call BIS_fnc_getParamValue == 1) then {COAllowAmbience = true};

publicVariable "COAllowAmbience";

eastHash = createHashMapFromArray [
	["CSAT",
		[   //Infantry (General infantry, Recon, Special Forces)
			[
				"O_Soldier_TL_F",
				"O_engineer_F",
				"O_soldier_exp_F",
				"O_Soldier_A_F",
				"O_Soldier_AR_F",
				"O_medic_F",
				"O_Soldier_GL_F",
				"O_HeavyGunner_F",
				"O_soldier_M_F",
				"O_Soldier_F",
				"O_Soldier_LAT_F",
				"O_Soldier_HAT_F",
				"O_Soldier_lite_F",
				"O_Sharpshooter_F"
			],
			[
				"O_recon_TL_F",
				"O_recon_F",
				"O_recon_M_F",
				"O_recon_medic_F",
				"O_Pathfinder_F",
				"O_recon_JTAC_F",
				"O_recon_LAT_F"
			],
			[
				"O_V_Soldier_TL_hex_F",
				"O_V_Soldier_LAT_hex_F",
				"O_V_Soldier_Medic_hex_F",
				"O_V_Soldier_hex_F",
				"O_V_Soldier_M_hex_F",
				"O_V_Soldier_JTAC_hex_F",
				"O_V_Soldier_Exp_hex_F"
			],
			//Ground vehicles (Cars, Medium armor, Heavy armor)
			[
				"O_MRAP_02_gmg_F",
				"O_MRAP_02_hmg_F",
				"O_LSV_02_AT_F",
				"O_LSV_02_armed_F"
			],
			[
				"O_APC_Tracked_02_cannon_F",
				"O_APC_Wheeled_02_rcws_v2_F"
			],
			[
				"O_MBT_02_cannon_F",
				"O_MBT_02_railgun_F",
				"O_MBT_04_cannon_F",
				"O_MBT_04_command_F"
			],
			//Air Vehicles (Gunships/Attack helicopters, Attack planes, Transport aircraft)
			[
				"O_Heli_Attack_02_dynamicLoadout_F",
				"O_Heli_Light_02_dynamicLoadout_F",
				"O_T_VTOL_02_infantry_hex_F"
			],
			[
				"O_Plane_CAS_02_dynamicLoadout_F",
				"O_Plane_Fighter_02_F",
				"O_Plane_Fighter_02_Stealth_F"
			],
			[
				"O_Heli_Light_02_unarmed_F", 
				"O_Heli_Transport_04_covered_F", 
				"O_Heli_Transport_04_bench_F"
			]
		]
	],
	["Russian Federation (Summer)",
		[   //Infantry (General infantry, Recon, Special Forces)
			[
				"CUP_O_RUS_M_Soldier_TL_Ratnik_Summer", 
				"CUP_O_RUS_M_Soldier_GL_Ratnik_Summer", 
				"CUP_O_RUS_M_Soldier_MG_Ratnik_Summer", 
				"CUP_O_RUS_M_Soldier_Marksman_Ratnik_Summer", 
				"CUP_O_RUS_M_Soldier_Engineer_Ratnik_Summer", 
				"CUP_O_RUS_M_Soldier_Medic_Ratnik_Summer", 
				"CUP_O_RUS_M_Soldier_Mine_Ratnik_Summer", 
				"CUP_O_RUS_M_Soldier_LAT_Ratnik_Summer", 
				"CUP_O_RUS_M_Soldier_HAT_Ratnik_Summer", 
				"CUP_O_RUS_M_Soldier_Ratnik_Summer", 
				"CUP_O_RUS_M_Soldier_Repair_Ratnik_Summer", 
				"CUP_O_RUS_M_Soldier_Exp_Ratnik_Summer", 
				"CUP_O_RUS_M_Soldier_A_Ratnik_Summer", 
				"CUP_O_RUS_M_Soldier_AR_Ratnik_Summer", 
				"CUP_O_RUS_M_Soldier_Lite_Ratnik_Summer"
			],
			[
				"CUP_O_RUS_M_Recon_TL_Gorka_EMR", 
				"CUP_O_RUS_M_Recon_Sharpshooter_Gorka_EMR", 
				"CUP_O_RUS_M_Recon_LAT_Gorka_EMR", 
				"CUP_O_RUS_M_Recon_Rifleman_Gorka_EMR", 
				"CUP_O_RUS_M_Recon_Medic_Gorka_EMR", 
				"CUP_O_RUS_M_Recon_Marksman_Gorka_EMR", 
				"CUP_O_RUS_M_Recon_GL_Gorka_EMR", 
				"CUP_O_RUS_M_Recon_Exp_Gorka_EMR", 
				"CUP_O_RUS_M_Recon_MG_Gorka_EMR"
			],
			[
				//empty
			],
			//Ground vehicles (Cars, Medium armor, Heavy armor)
			[
				"CUP_O_Tigr_M_233114_GREEN_PK_RU", 
				"CUP_O_Tigr_M_233114_PK_RU", 
				"CUP_O_Tigr_M_233114_KORD_RU", 
				"CUP_O_Tigr_M_233114_GREEN_KORD_RU", 
				"CUP_O_Tigr_233014_GREEN_PK_RU", 
				"CUP_O_Tigr_233014_RU", 
				"CUP_O_BRDM2_RUS", 
				"CUP_O_BRDM2_ATGM_RUS", 
				"CUP_O_GAZ_Vodnik_AGS_RU", 
				"CUP_O_GAZ_Vodnik_PK_RU", 
				"CUP_O_GAZ_Vodnik_BPPU_RU", 
				"CUP_O_GAZ_Vodnik_KPVT_RU", 
				"CUP_O_GAZ_Vodnik_MedEvac_RU"
			],
			[
				"CUP_O_BMP2_RU", 
				"CUP_O_BMP_HQ_RU", 
				"CUP_O_BMP3_RU", 
				"CUP_O_BTR80A_CAMO_RU", 
				"CUP_O_BTR90_RU", 
				"CUP_O_BTR80_CAMO_RU"
			],
			[
				"CUP_O_T90M_RU",
				"CUP_O_2S6M_RU"
			],
			//Air Vehicles (Gunships/Attack helicopters, Attack planes, Transport aircraft)
			[
				"CUP_O_Ka50_DL_RU", 
				"CUP_O_Ka52_RU", 
				"CUP_O_Ka60_Grey_RU", 
				"CUP_O_Mi24_V_Dynamic_RU", 
				"CUP_O_Mi8_RU"
			],
			[
				"CUP_O_Su25_Dyn_RU", 
				"CUP_O_SU34_RU"
			],
			[
				"CUP_O_Mi8AMT_RU", 
				"CUP_O_MI6T_RU"
			]
		]
	],
	["Takistani Army",
		[   //Infantry (General infantry, Recon, Special Forces)
			[
				"CUP_O_TK_Soldier_SL", 
				"CUP_O_TK_Soldier", 
				"CUP_O_TK_Soldier_AT", 
				"CUP_O_TK_Soldier_LAT", 
				"CUP_O_TK_Soldier_Backpack", 
				"CUP_O_TK_Medic",
				"CUP_O_TK_Soldier_M", 
				"CUP_O_TK_Soldier_MG", 
				"CUP_O_TK_Soldier_GL", 
				"CUP_O_TK_Engineer", 
				"CUP_O_TK_Soldier_AR"
			],
			[
				"CUP_O_TK_SpecOps_TL", 
				"CUP_O_TK_SpecOps", 
				"CUP_O_TK_SpecOps_MG"
			],
			[
				"CUP_O_TK_Soldier_AKS_74_GOSHAWK", 
				"CUP_O_TK_Soldier_FNFAL_Night", 
				"CUP_O_TK_Soldier_AKS_Night"
			],
			//Ground vehicles (Cars, Medium armor, Heavy armor)
			[
				"CUP_O_Tigr_M_233114_TKA", 
				"CUP_O_Tigr_M_233114_KORD_TKA", 
				"CUP_O_Tigr_M_233114_PK_TKA", 
				"CUP_O_Tigr_233014_TKA", 
				"CUP_O_LR_MG_TKA", 
				"CUP_O_LR_SPG9_TKA", 
				"CUP_O_UAZ_AGS30_TKA", 
				"CUP_O_UAZ_MG_TKA", 
				"CUP_O_UAZ_METIS_TKA", 
				"CUP_O_UAZ_SPG9_TKA"
			],
			[
				"CUP_O_BMP1_TKA", 
				"CUP_O_BMP1P_TKA", 
				"CUP_O_BMP2_TKA", 
				"CUP_O_BMP2_ZU_TKA", 
				"CUP_O_BMP_HQ_TKA", 
				"CUP_O_BRDM2_TKA", 
				"CUP_O_BRDM2_ATGM_TKA", 
				"CUP_O_BTR40_MG_TKA", 
				"CUP_O_BTR60_TK", 
				"CUP_O_BTR80_TK", 
				"CUP_O_BTR80A_TK", 
				"CUP_O_M113A3_TKA"
			],
			[
				"CUP_O_T72_TKA", 
				"CUP_O_T55_TK", 
				"CUP_O_T34_TKA"
			],
			//Air Vehicles (Gunships/Attack helicopters, Attack planes, Transport aircraft)
			[
				"CUP_O_Mi24_D_Dynamic_TK", 
				"CUP_O_UH1H_armed_TKA", 
				"CUP_O_UH1H_gunship_TKA"
			],
			[
				"CUP_O_Su25_Dyn_TKA", 
				"CUP_O_L39_TK"	
			],
			[
				"CUP_O_MI6T_TKA", 
				"CUP_O_Mi17_TK", 
				"CUP_O_UH1H_TKA", 
				"CUP_O_UH1H_slick_TKA"
			]
		]
	],
	["Chernarus Red Star",
		[   //Infantry (General infantry, Recon, Special Forces)
			[
				"CUP_O_INS_Commander", 
				"CUP_O_INS_Soldier_Ammo", 
				"CUP_O_INS_Soldier_AR", 
				"CUP_O_INS_Soldier_Engineer", 
				"CUP_O_INS_Soldier_GL", 
				"CUP_O_INS_Story_Bardak", 
				"CUP_O_INS_Soldier_MG", 
				"CUP_O_INS_Medic", 
				"CUP_O_INS_Soldier", 
				"CUP_O_INS_Soldier_AK74", 
				"CUP_O_INS_Soldier_LAT", 
				"CUP_O_INS_Saboteur", 
				"CUP_O_INS_Soldier_Exp"
			],
			[

			],
			[

			],
			//Ground vehicles (Cars, Medium armor, Heavy armor)
			[
				"CUP_O_Datsun_PK", 
				"CUP_O_Datsun_PK_Random", 
				"CUP_O_Tigr_233014_PK_CHDKZ", 
				"CUP_O_Hilux_AGS30_CHDKZ", 
				"CUP_O_Hilux_DSHKM_CHDKZ", 
				"CUP_O_Hilux_igla_CHDKZ", 
				"CUP_O_Hilux_metis_CHDKZ", 
				"CUP_O_Hilux_MLRS_CHDKZ", 
				"CUP_O_Hilux_podnos_CHDKZ", 
				"CUP_O_Hilux_SPG9_CHDKZ", 
				"CUP_O_Hilux_UB32_CHDKZ", 
				"CUP_O_Hilux_zu23_CHDKZ", 
				"CUP_O_UAZ_AGS30_CHDKZ", 
				"CUP_O_UAZ_MG_CHDKZ", 
				"CUP_O_UAZ_METIS_CHDKZ", 
				"CUP_O_UAZ_SPG9_CHDKZ"
			],
			[
				"CUP_O_BMP2_CHDKZ", 
				"CUP_O_BMP_HQ_CHDKZ", 
				"CUP_O_BRDM2_CHDKZ", 
				"CUP_O_BRDM2_ATGM_CHDKZ", 
				"CUP_O_BRDM2_HQ_CHDKZ", 
				"CUP_O_BTR60_CHDKZ", 
				"CUP_O_BTR80_CHDKZ", 
				"CUP_O_BTR80A_CHDKZ", 
				"CUP_O_MTLB_pk_ChDKZ"
			],
			[
				"CUP_O_T55_CHDKZ", 
				"CUP_O_T72_CHDKZ"	
			],
			//Air Vehicles (Gunships/Attack helicopters, Attack planes, Transport aircraft)
			[
				"CUP_O_Mi8_CHDKZ"
			],
			[
				"CUP_O_Su25_Dyn_RU"
			],
			[
				"CUP_O_Mi8_CHDKZ"
			]
		]
	]
];

indHash = createHashMapFromArray [
	["AAF",
		[   //Infantry (General infantry, Recon, Special Forces)
			[
				"I_Soldier_SL_F", 
				"I_Soldier_lite_F", 
				"I_Soldier_LAT2_F", 
				"I_Soldier_LAT_F", 
				"I_soldier_mine_F", 
				"I_Soldier_M_F", 
				"I_Soldier_GL_F", 
				"I_Soldier_exp_F", 
				"I_engineer_F", 
				"I_medic_F", 
				"I_Soldier_AR_F", 
				"I_Soldier_A_F"
			],
			[

			],
			[

			],
			//Ground vehicles (Cars, Medium armor, Heavy armor)
			[
				"I_MRAP_03_hmg_F", 
				"I_MRAP_03_gmg_F",
				"I_LT_01_AT_F", 
				"I_LT_01_cannon_F"
			],
			[
				"I_APC_Wheeled_03_cannon_F", 
				"I_APC_tracked_03_cannon_F"
			],
			[
				"I_MBT_03_cannon_F"
			],
			//Air Vehicles (Gunships/Attack helicopters, Attack planes, Transport aircraft)
			[
				"I_Heli_light_03_dynamicLoadout_F"
			],
			[
				"I_Plane_Fighter_03_dynamicLoadout_F", 
				"I_Plane_Fighter_04_F"
			],
			[
				"I_Heli_Transport_02_F"
			]
		]
	],
	["ION PMC",
		[   //Infantry (General infantry, Recon, Special Forces)
			[
				"CUP_I_PMC_Soldier_TL", 
				"CUP_I_PMC_Contractor1", 
				"CUP_I_PMC_Contractor2", 
				"CUP_I_PMC_Sniper", 
				"CUP_I_PMC_Medic", 
				"CUP_I_PMC_Soldier_AT", 
				"CUP_I_PMC_Soldier_MG_PKM", 
				"CUP_I_PMC_Soldier_MG", 
				"CUP_I_PMC_Soldier_M4A3", 
				"CUP_I_PMC_Soldier_GL_M16A2", 
				"CUP_I_PMC_Soldier_GL", 
				"CUP_I_PMC_Soldier", 
				"CUP_I_PMC_Engineer"
			],
			[

			],
			[

			],
			//Ground vehicles (Cars, Medium armor, Heavy armor)
			[
				"CUP_I_SUV_Armored_ION", 
				"CUP_I_nM1025_M2_ION", 
				"CUP_I_nM1025_M2_DF_ION", 
				"CUP_I_nM1025_M240_ION", 
				"CUP_I_nM1025_M240_DF_ION", 
				"CUP_I_nM1025_Mk19_ION", 
				"CUP_I_nM1025_Mk19_DF_ION", 
				"CUP_B_nM1025_SOV_M2_ION", 
				"CUP_B_nM1025_SOV_Mk19_ION", 
				"CUP_I_nM1036_TOW_ION", 
				"CUP_I_nM1036_TOW_DF_ION", 
				"CUP_I_nM1151_crowslp_m2_ION", 
				"CUP_I_nM1151_crowslp_m2_DF_ION", 
				"CUP_I_nM1151_ogpk_m2_ION", 
				"CUP_I_nM1151_ogpk_m2_DF_ION", 
				"CUP_I_nM1151_ogpk_m240_ION", 
				"CUP_I_nM1151_ogpk_m240_DF_ION", 
				"CUP_I_nM1151_ogpk_mk19_ION", 
				"CUP_I_nM1151_ogpk_mk19_DF_ION"
			],
			[
				"CUP_I_RG31_Mk19_ION", 
				"CUP_I_RG31E_M2_ION", 
				"CUP_I_RG31_M2_ION", 
				"CUP_I_RG31_M2_GC_ION"
			],
			[
				"CUP_I_BTR80_ION", 
				"CUP_I_BTR80A_ION"
			],
			//Air Vehicles (Gunships/Attack helicopters, Attack planes, Transport aircraft)
			[
				"CUP_I_412_Military_Armed_PMC", 
				"CUP_I_412_Military_Armed_AT_PMC", 
				"CUP_I_Mi24_Mk3_ION", 
				"CUP_I_Mi24_Mk4_ION"
			],
			[
				"CUP_I_CESSNA_T41_ARMED_ION"
			],
			[
				"CUP_I_Merlin_HC3_PMC_Transport_black", 
				"CUP_I_Merlin_HC3_PMC_Lux_black", 
				"CUP_I_412_Mil_Utility_PMC", 
				"CUP_I_412_Mil_Transport_PMC"
			]
		]
	],
	["Takistani Locals",
		[   //Infantry (General infantry, Recon, Special Forces)
			[
				"CUP_I_TK_GUE_Soldier_TL", 
				"CUP_I_TK_GUE_Soldier_MG", 
				"CUP_I_TK_GUE_Mechanic", 
				"CUP_I_TK_GUE_Sniper", 
				"CUP_I_TK_GUE_Soldier_AR", 
				"CUP_I_TK_GUE_Demo", 
				"CUP_I_TK_GUE_Guerilla_Medic", 
				"CUP_I_TK_GUE_Soldier", 
				"CUP_I_TK_GUE_Soldier_AK_47S", 
				"CUP_I_TK_GUE_Soldier_HAT", 
				"CUP_I_TK_GUE_Guerilla_Enfield", 
				"CUP_I_TK_GUE_Soldier_GL", 
				"CUP_I_TK_GUE_Soldier_M16A2", 
				"CUP_I_TK_GUE_Soldier_LAT", 
				"CUP_I_TK_GUE_Soldier_AT"
			],
			[
			],
			[
			],
			//Ground vehicles (Cars, Medium armor, Heavy armor)
			[
				"CUP_I_Datsun_PK_TK", 
				"CUP_I_Datsun_PK_TK_Random", 
				"CUP_I_Hilux_AGS30_TK",
				"CUP_I_Hilux_DSHKM_TK", 
				"CUP_I_Hilux_M2_TK", 
				"CUP_I_Hilux_metis_TK", 
				"CUP_I_Hilux_MLRS_TK", 
				"CUP_I_Hilux_SPG9_TK", 
				"CUP_I_Hilux_zu23_TK", 
				"CUP_I_Hilux_UB32_TK", 
				"CUP_I_Hilux_podnos_TK"
			],
			[
				"CUP_I_Hilux_armored_BMP1_TK", 
				"CUP_I_Hilux_armored_BTR60_TK", 
				"CUP_I_Hilux_armored_igla_TK"
			],
			[
				"CUP_I_T34_TK_GUE", 
				"CUP_I_T55_TK_GUE"
			],
			//Air Vehicles (Gunships/Attack helicopters, Attack planes, Transport aircraft)
			[
				"CUP_I_UH1H_armed_TK_GUE", 
				"CUP_I_UH1H_gunship_TK_GUE"
			],
			[
				"CUP_I_CESSNA_T41_ARMED_ION"
			],
			[
				"CUP_I_UH1H_slick_TK_GUE", 
				"CUP_I_UH1H_TK_GUE"
			]
		]
	],
	["Chernarus Nationalists",
		[   //Infantry (General infantry, Recon, Special Forces)
			[
				"CUP_I_GUE_Officer", 
				"CUP_I_GUE_Soldier_AR", 
				"CUP_I_GUE_Ammobearer", 
				"CUP_I_GUE_Soldier_GL", 
				"CUP_I_GUE_Sniper", 
				"CUP_I_GUE_Soldier_MG", 
				"CUP_I_GUE_Engineer", 
				"CUP_I_GUE_Medic", 
				"CUP_I_GUE_Soldier_AKS74", 
				"CUP_I_GUE_Soldier_AKM", 
				"CUP_I_GUE_Soldier_AKSU", 
				"CUP_I_GUE_Soldier_LAT", 
				"CUP_I_GUE_Soldier_AT", 
				"CUP_I_GUE_Saboteur"
			],
			[
				"CUP_I_GUE_Soldier_Scout"
			],
			[

			],
			//Ground vehicles (Cars, Medium armor, Heavy armor)
			[
				"CUP_I_Datsun_PK", 
				"CUP_I_Datsun_PK_Random", 
				"CUP_I_Hilux_AGS30_NAPA", 
				"CUP_I_Hilux_BMP1_NAPA", 
				"CUP_I_Hilux_btr60_NAPA", 
				"CUP_I_Hilux_DSHKM_NAPA", 
				"CUP_I_Hilux_metis_NAPA", 
				"CUP_I_Hilux_MLRS_NAPA", 
				"CUP_I_Hilux_podnos_NAPA", 
				"CUP_I_Hilux_SPG9_NAPA", 
				"CUP_I_Hilux_UB32_NAPA", 
				"CUP_I_Hilux_zu23_NAPA", 
				"CUP_I_Hilux_armored_AGS30_NAPA", 
				"CUP_I_Hilux_armored_BMP1_NAPA", 
				"CUP_I_Hilux_armored_BTR60_NAPA", 
				"CUP_I_Hilux_armored_DSHKM_NAPA", 
				"CUP_I_Hilux_armored_metis_NAPA", 
				"CUP_I_Hilux_armored_MLRS_NAPA", 
				"CUP_I_Hilux_armored_podnos_NAPA", 
				"CUP_I_Hilux_armored_SPG9_NAPA", 
				"CUP_I_Hilux_armored_UB32_NAPA", 
				"CUP_I_Hilux_armored_zu23_NAPA"
			],
			[
				"CUP_I_BMP2_NAPA", 
				"CUP_I_BMP_HQ_NAPA", 
				"CUP_I_BRDM2_NAPA", 
				"CUP_I_BRDM2_ATGM_NAPA", 
				"CUP_I_BRDM2_HQ_NAPA", 
				"CUP_I_MTLB_pk_NAPA"
			],
			[
				"CUP_I_T72_NAPA", 
				"CUP_I_T55_NAPA", 
				"CUP_I_T34_NAPA"
			],
			//Air Vehicles (Gunships/Attack helicopters, Attack planes, Transport aircraft)
			[
				"CUP_O_Mi8_CHDKZ"
			],
			[
				"CUP_O_Su25_Dyn_RU"
			],
			[
				"CUP_O_Mi8_CHDKZ"
			]
		]
	],
	["R.A.C.S.",
		[   //Infantry (General infantry, Recon, Special Forces)
			[
				"CUP_I_RACS_SL_Mech", 
				"CUP_I_RACS_Sniper_Mech", 
				"CUP_I_RACS_AR_Mech", 
				"CUP_I_RACS_MMG_Mech", 
				"CUP_I_RACS_Soldier_LAT_Mech", 
				"CUP_I_RACS_Soldier_Mech", 
				"CUP_I_RACS_Medic_Mech", 
				"CUP_I_RACS_M_Mech", 
				"CUP_I_RACS_GL_Mech", 
				"CUP_I_RACS_Engineer_Mech", 
				"CUP_I_RACS_Soldier_AMG_Mech"
			],
			[
				"CUP_I_RACS_RoyalGuard", 
				"CUP_I_RACS_RoyalCommando", 
				"CUP_I_RACS_RoyalMarksman"
			],
			[

			],
			//Ground vehicles (Cars, Medium armor, Heavy armor)
			[
				"CUP_I_LR_MG_RACS", 
				"CUP_I_LAV25_HQ_RACS"
			],
			[
				"CUP_I_LAV25_RACS", 
				"CUP_I_LAV25M240_RACS", 
				"CUP_I_AAV_RACS", 
				"CUP_I_M113A1_RACS", 
				"CUP_I_M270_HE_RACS"
			],
			[
				"CUP_B_M1A2SEP_RACS", 
				"CUP_B_M1A2SEP_TUSK_RACS"
			],
			//Air Vehicles (Gunships/Attack helicopters, Attack planes, Transport aircraft)
			[
				"CUP_I_AH6J_RACS", 
				"CUP_I_UH1H_gunship_RACS", 
				"CUP_I_UH1H_Armed_RACS"
			],
			[
				"CUP_I_JAS39_RACS"
			],
			[
				"CUP_I_UH60L_FFV_RACS", 
				"CUP_I_UH60L_RACS", 
				"CUP_I_SA330_Puma_HC2_RACS", 
				"CUP_I_SA330_Puma_HC1_RACS", 
				"CUP_I_CH47F_RACS"
			]
		]
	]
];

civHash = createHashMapFromArray 
[
	["Vanilla",
		[
			[
				"C_man_p_beggar_F", 
				"C_man_1", 
				"C_Man_casual_1_F", 
				"C_Man_casual_2_F", 
				"C_Man_casual_3_F", 
				"C_Man_casual_4_v2_F", 
				"C_Man_casual_5_v2_F", 
				"C_Man_casual_6_v2_F", 
				"C_Man_casual_7_F", 
				"C_Man_casual_8_F", 
				"C_Man_casual_9_F", 
				"C_Man_formal_1_F", 
				"C_Man_formal_2_F", 
				"C_Man_formal_3_F", 
				"C_Man_formal_4_F", 
				"C_Man_smart_casual_1_F", 
				"C_Man_smart_casual_2_F", 
				"C_man_sport_1_F", 
				"C_man_sport_2_F", 
				"C_man_sport_3_F", 
				"C_Man_casual_4_F", 
				"C_Man_casual_5_F", 
				"C_Man_casual_6_F", 
				"C_man_polo_1_F", 
				"C_man_polo_2_F", 
				"C_man_polo_3_F", 
				"C_man_polo_4_F", 
				"C_man_polo_5_F", 
				"C_man_polo_6_F", 
				"C_Man_ConstructionWorker_01_Black_F", 
				"C_Man_ConstructionWorker_01_Blue_F", 
				"C_Man_ConstructionWorker_01_Red_F", 
				"C_Man_ConstructionWorker_01_Vrana_F", 
				"C_Driver_1_F", 
				"C_Driver_3_F", 
				"C_Driver_4_F", 
				"C_Driver_2_F", 
				"C_man_p_fugitive_F", 
				"C_Man_Fisherman_01_F", 
				"C_journalist_F", 
				"C_Journalist_01_War_F", 
				"C_Man_Paramedic_01_F", 
				"C_man_pilot_F", 
				"C_scientist_F", 
				"C_man_shorts_2_F", 
				"C_man_shorts_3_F", 
				"C_man_shorts_4_F", 
				"C_Man_UAV_06_F", 
				"C_Man_UAV_06_medical_F", 
				"C_Man_UtilityWorker_01_F", 
				"C_man_w_worker_F"
			],
			[
				"C_Truck_02_covered_F", 
				"C_Truck_02_transport_F", 
				"C_Truck_02_box_F", 
				"C_Truck_02_fuel_F", 
				"C_Van_02_service_F", 
				"C_Van_02_transport_F", 
				"C_Van_01_fuel_F", 
				"C_Hatchback_01_F", 
				"C_Hatchback_01_sport_F", 
				"C_Offroad_02_unarmed_F", 
				"C_Offroad_01_F", 
				"C_Offroad_01_comms_F", 
				"C_Offroad_01_covered_F", 
				"C_Offroad_01_repair_F", 
				"C_SUV_01_F", 
				"C_Van_01_box_F", 
				"C_Van_01_transport_F"
			],
			[
				"C_Heli_Light_01_civil_F", 
				"C_Plane_Civil_01_racing_F", 
				"C_Plane_Civil_01_F", 
				"C_IDAP_Heli_Transport_02_F"
			]
		]
	],
	["CUP EU",
		[
			[
				"CUP_C_C_AirMedic_orange_01", 
				"CUP_C_C_AirMedic_red_01", 
				"CUP_C_C_AirMedic_yellow_01", 
				"CUP_C_C_Assistant_01", 
				"CUP_C_C_Bully_02", 
				"CUP_C_C_Bully_04", 
				"CUP_C_C_Bully_01", 
				"CUP_C_C_Bully_03", 
				"CUP_C_C_Citizen_02", 
				"CUP_C_C_Citizen_01", 
				"CUP_C_C_Citizen_04", 
				"CUP_C_C_Citizen_03", 
				"CUP_C_C_Doctor_01", 
				"CUP_C_C_Fireman_01", 
				"CUP_C_C_Functionary_01", 
				"CUP_C_C_Functionary_02", 
				"CUP_C_C_Functionary_03", 
				"CUP_C_C_Functionary_jacket_01", 
				"CUP_C_C_Functionary_jacket_02", 
				"CUP_C_C_Functionary_jacket_03", 
				"CUP_C_C_Worker_05", 
				"CUP_C_C_Mechanic_02", 
				"CUP_C_C_Mechanic_03", 
				"CUP_C_C_Mechanic_01", 
				"CUP_C_C_Rescuer_01", 
				"CUP_C_C_Pilot_01", 
				"CUP_C_C_Policeman_02", 
				"CUP_C_C_Policeman_01", 
				"CUP_C_C_Priest_01", 
				"CUP_C_C_Profiteer_02", 
				"CUP_C_C_Profiteer_03", 
				"CUP_C_C_Profiteer_01", 
				"CUP_C_C_Profiteer_04", 
				"CUP_C_C_Racketeer_01", 
				"CUP_C_C_Racketeer_04", 
				"CUP_C_C_Racketeer_02", 
				"CUP_C_C_Racketeer_03", 
				"CUP_C_C_Rocker_01", 
				"CUP_C_C_Rocker_03", 
				"CUP_C_C_Rocker_02", 
				"CUP_C_C_Rocker_04", 
				"CUP_C_C_Schoolteacher_01", 
				"CUP_C_C_Citizen_Random", 
				"CUP_C_C_Worker_01", 
				"CUP_C_C_Worker_02", 
				"CUP_C_C_Worker_04", 
				"CUP_C_C_Worker_03", 
				"CUP_C_C_Woodlander_04", 
				"CUP_C_C_Woodlander_03", 
				"CUP_C_C_Woodlander_02", 
				"CUP_C_C_Woodlander_01", 
				"CUP_C_C_Villager_03", 
				"CUP_C_C_Villager_02", 
				"CUP_C_C_Villager_04", 
				"CUP_C_C_Villager_01"
			],
			[
				"CUP_C_TT650_CIV", 
				"CUP_C_Skoda_CR_CIV", 
				"CUP_C_Skoda_Blue_CIV", 
				"CUP_C_Skoda_Red_CIV", 
				"CUP_C_Skoda_White_CIV", 
				"CUP_C_S1203_CIV_CR", 
				"CUP_B_S1203_Ambulance_CR", 
				"CUP_C_Datsun_Covered", 
				"CUP_C_S1203_Militia_CIV", 
				"CUP_C_Datsun_Plain", 
				"CUP_C_Datsun_Tubeframe", 
				"CUP_C_Volha_CR_CIV", 
				"CUP_C_Golf4_red_Civ", 
				"CUP_C_Golf4_CR_Civ", 
				"CUP_C_Golf4_Sport_CR_Civ", 
				"CUP_O_Hilux_unarmed_CR_CIV", 
				"CUP_O_Hilux_unarmed_CR_CIV_Red", 
				"CUP_O_Hilux_unarmed_CR_CIV_Tan", 
				"CUP_O_Hilux_unarmed_CR_CIV_White", 
				"CUP_C_Ikarus_Chernarus", 
				"CUP_C_Bus_City_CRCIV", 
				"CUP_C_SUV_CIV", 
				"CUP_C_Tractor_CIV", 
				"CUP_C_Tractor_Old_CIV", 
				"CUP_C_Ural_Civ_03", 
				"CUP_C_Ural_Open_Civ_03", 
				"CUP_C_Lada_CIV", 
				"CUP_LADA_LM_CIV"
			],
			[
				"CUP_C_SA330_Puma_HC1_ChernAvia", 
				"CUP_C_AN2_CIV", 
				"CUP_C_DC3_ChernAvia_CIV", 
				"CUP_C_CESSNA_CIV", 
				"CUP_C_MI6T_RU", 
				"CUP_C_Mi17_Civilian_RU", 
				"CUP_C_Mi17_VIV_RU"
			]
		]
	],
	["CUP ME",
		[
			[
				"CUP_C_TK_Man_04", 
				"CUP_C_TK_Man_04_Jack", 
				"CUP_C_TK_Man_04_Waist", 
				"CUP_C_TK_Man_07", 
				"CUP_C_TK_Man_07_Coat", 
				"CUP_C_TK_Man_07_Waist", 
				"CUP_C_TK_Man_08", 
				"CUP_C_TK_Man_08_Jack", 
				"CUP_C_TK_Man_08_Waist", 
				"CUP_C_TK_Man_05_Coat", 
				"CUP_C_TK_Man_05_Jack", 
				"CUP_C_TK_Man_05_Waist", 
				"CUP_C_TK_Man_06_Coat", 
				"CUP_C_TK_Man_06_Jack", 
				"CUP_C_TK_Man_06_Waist", 
				"CUP_C_TK_Man_02", 
				"CUP_C_TK_Man_02_Jack", 
				"CUP_C_TK_Man_02_Waist", 
				"CUP_C_TK_Man_01_Waist", 
				"CUP_C_TK_Man_01_Coat", 
				"CUP_C_TK_Man_01_Jack", 
				"CUP_C_TK_Man_03_Coat", 
				"CUP_C_TK_Man_03_Jack", 
				"CUP_C_TK_Man_03_Waist"
			],
			[
				"CUP_C_TT650_TK_CIV", 
				"CUP_C_S1203_CIV", 
				"CUP_C_S1203_Ambulance_CIV", 
				"CUP_C_Volha_Gray_TKCIV", 
				"CUP_C_Volha_Blue_TKCIV", 
				"CUP_C_Volha_Limo_TKCIV", 
				"CUP_O_Hilux_unarmed_TK_CIV", 
				"CUP_O_Hilux_unarmed_TK_CIV_Red", 
				"CUP_O_Hilux_unarmed_TK_CIV_Tan", 
				"CUP_O_Hilux_unarmed_TK_CIV_White", 
				"CUP_C_Ikarus_TKC", 
				"CUP_C_Bus_City_TKCIV", 
				"CUP_C_LR_Transport_CTK", 
				"CUP_C_V3S_Open_TKC", 
				"CUP_C_V3S_Covered_TKC", 
				"CUP_C_SUV_TK", 
				"CUP_C_UAZ_Unarmed_TK_CIV", 
				"CUP_C_UAZ_Open_TK_CIV", 
				"CUP_C_Ural_Civ_01", 
				"CUP_C_Lada_TK_CIV", 
				"CUP_C_Lada_GreenTK_CIV", 
				"CUP_C_Lada_TK2_CIV"
			],
			[
				"CUP_C_AN2_AIRTAK_TK_CIV", 
				"CUP_C_AN2_AEROSCHROT_TK_CIV", 
				"CUP_C_IDAP_412_Luxury", 
				"CUP_C_IDAP_412_Utility", 
				"CUP_C_IDAP_412", 
				"CUP_C_Merlin_HC3_IDAP_Rescue", 
				"CUP_C_Merlin_HC3_IDAP_Lux", 
				"CUP_C_IDAP_412_Medic"
			]
		]
	]
];

eastFactions = keys eastHash;
indFactions = keys indHash;
civFactions = keys indHash;

publicVariable "eastHash";
publicVariable "indHash";
publicVariable "civHash";
publicVariable "eastFactions";
publicVariable "indFactions";
publicVariable "civFactions";