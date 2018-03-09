

Corp_Default = 
{
	PowAssets = { "Str_Power", "Str_Nimbus", "Str_Battery","Str_Power" },
	TechAssets = { "Str_Robotics","Str_Research" },
	RepAssets = { "Str_Bar", "Str_Clinic" },
	--High Value missions must provide 2 reputation
	Missions_High = { "Mission_Volatile", "Mission_Train", "Mission_Force"},
	--Low Value missions must provide 1 reputation
	Missions_Low =  {"Mission_Survive", "Mission_Wind" },
	Bosses = { "Mission_BlobBoss", "Mission_SpiderBoss", "Mission_BeetleBoss", "Mission_HornetBoss", "Mission_FireflyBoss", "Mission_ScorpionBoss", "Mission_JellyBoss"},   
	UniqueBosses = {},
	CEO_Name = "Mr. Business",
	CEO_Image = "ceo_portrait.png",
	CEO_Personality = "Personality_CEO",
	Color = GL_Color(200,25,25),
	Office = "default",
	Environment = "",
	
	Pilot = "Pilot_Archive",
	
	Name = "Pepsi Co",
	Tileset = "grass",
	
	
	Music = { "/music/grass/combat_delta", "/music/grass/combat_gamma"},
	Map = { "/music/grass/map" }
}

CreateClass(Corp_Default)

Corp_Grass = Corp_Default:new
{
	CEO_Name = "Dewey Alms",
	CEO_Image = "ceo_archive.png",
	CEO_Personality = "CEO_Grass",
	Office = "archive",

	Name = "Archive, Inc.",
	Bark_Name = "Archive",
	Tileset = "grass",
	Environment = "Temperate",
	
	Pilot = "Pilot_Archive",
		
	Missions_High = {"Mission_Volatile", "Mission_Train", "Mission_Satellite","Mission_Tanks"},
	Missions_Low = {"Mission_Survive","Mission_Airstrike","Mission_Artillery", "Mission_Mines", "Mission_Dam", "Mission_Tides"},
			
	Color = GL_Color(57,87,38),
	
	Music = { "/music/grass/combat_delta", "/music/grass/combat_gamma", "/music/sand/combat_guitar"},
	Map = { "/music/grass/map" },
}

Corp_Desert = Corp_Default:new
{
	CEO_Name = "Jessica Kern",
	CEO_Image = "ceo_rst.png",
	CEO_Personality = "CEO_Sand",
	Missions_High = {"Mission_Force", "Mission_Terraform", "Mission_Train", "Mission_Volatile"},
	Missions_Low =  {"Mission_Bomb", "Mission_Survive", "Mission_Lightning", "Mission_Holes", "Mission_Solar", "Mission_Cataclysm", "Mission_Crack", "Mission_Filler" },	
	Name = "R.S.T. Corporation",
	Bark_Name = "R.S.T.",
	Tileset = "sand",
	Color = GL_Color(182,114,76),
	Office = "rust",
	Pilot = "Pilot_Rust",
	Environment = "Desert",
		
	Music = { "/music/sand/combat_western", "/music/sand/combat_eastwood", "/music/sand/combat_montage" }, 
	Map = { "/music/sand/map" }
}

Corp_Snow = Corp_Default:new
{
	CEO_Name = "Zenith",
	CEO_Image = "ceo_pinnacle.png",
	CEO_Personality = "CEO_Snow",
	CEO_Image = "ceo_pinnacle.png",
	Office = "pinnacle",
	UniqueBosses = { "Mission_BotBoss" },
	Missions_High = {"Mission_FreezeBots", "Mission_BotDefense", "Mission_Factory"},
	Missions_Low =  {"Mission_Survive", "Mission_Reactivation", "Mission_SnowBattle", "Mission_Stasis", "Mission_FreezeMines", "Mission_FreezeBldg", "Mission_SnowStorm" },
	Name = "Pinnacle Robotics",
	Bark_Name = "Pinnacle",
	Color = GL_Color(235,235,235),
	Tileset = "snow",
	Environment = "Frozen",
	Pilot = "Pilot_Pinnacle",
		
	Music = { "/music/snow/combat_ice", "/music/snow/combat_zimmer",  "/music/snow/combat_train"  },
	Map = { "/music/snow/map" }
}

Corp_Factory = Corp_Default:new
{
	CEO_Name = "Vikram Singh",
	CEO_Personality = "CEO_Acid",
	CEO_Image = "ceo_detritus.png",
	Name = "Detritus Disposal",
	Bark_Name = "Detritus",
	Tileset = "acid",
	Color = GL_Color(83,87,98),
	Office = "detritus",
	Pilot = "Pilot_Detritus",
	Environment = "Industrial",
	
	--High Value missions must provide 2 reputation
	Missions_High = { "Mission_Barrels", "Mission_Disposal", "Mission_Train", "Mission_AcidTank"},
	--Low Value missions must provide 1 reputation
	Missions_Low =  {"Mission_Survive", "Mission_Acid", "Mission_Power", "Mission_Belt", "Mission_BeltRandom", "Mission_Teleporter", },

	Music = { "/music/acid/combat_synth", "/music/general/ominous_master", "/music/acid/combat_detritus" },
	Map = { "/music/acid/map" }

}