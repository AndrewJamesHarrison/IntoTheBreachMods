
Mission_MineBase = Mission_Infinite:new{ 
	MineCount = 8, 
	SpawnStartMod = 1,
	MineType = "Item_Mine",
	BlockedUnits = {},
}

function Mission_MineBase:StartMission()
	--self.MineLocations = {}
	for i,v in ipairs(self.BlockedUnits) do
		self:GetSpawner():BlockPawns(v)
	end
	
	local choices = {}
	for i = 1, 6 do
		for j = 1, 6 do
			if 	Board:GetTerrain(Point(i,j)) == TERRAIN_ROAD or 
				Board:GetTerrain(Point(i,j)) == TERRAIN_FOREST or
				Board:GetTerrain(Point(i,j)) == TERRAIN_SAND then
			    choices[#choices+1] = Point(i,j)
			end
		end
	end
	
	self.MineCount = math.min(#choices,self.MineCount)
	for i = 1, self.MineCount do
		local point = random_removal(choices)
		--self.MineLocations[#self.MineLocations+1] = point
		Board:SetTerrain(point,TERRAIN_ROAD)
		Board:SetItem(point,self.MineType)
	end
end	