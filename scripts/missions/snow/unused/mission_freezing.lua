
Mission_Freezing = Mission_Infinite:new{ 
	Name = "Freeze Bursts",
	UseBonus = true,
	MapTags = { "water" },
	Environment = "Env_Freezing"
}

----- Freezing Environment

Env_Freezing = Env_LandChange:new{
	Name = "Flash Freezing ",
	Text = "Water will alternate between frozen and liquid after every turn.",
	StratText = "FLASH FREEZING",
}

function Env_Freezing:SetupLocations()
	self.Locations = {}
	for i = 0, 7 do
		for j = 0,7 do
			if Board:GetTerrain(i,j) == TERRAIN_WATER or Board:GetTerrain(i,j) == TERRAIN_ICE then
			   -- LOG("Found point, adding "..i..","..j)
				self.Locations[#self.Locations + 1] = Point(i,j)
			end
		end
	end
end

function Env_Freezing:GetTerrain()
	return self.EnvFlag == 0 and TERRAIN_WATER or TERRAIN_ICE
end