
Mission_Holes = Mission_Infinite:new{ 
	Name = "Sinkhole Hive",
	BonusPool = {BONUS_GRID, BONUS_MECHS, BONUS_KILL_FIVE}, -- Took out BONUS_BLOCK because they aren't spawning like normal
	MapTags = { "sand_hole" },
	UseBonus = true,
}

function Mission_Holes:UpdateSpawning()
	local count = self:GetSpawnCount()
	for i = 1, count do 
		Board:SpawnPawn(self:NextPawn( { "Hornet" } ), "hornets")
	end
end

function Mission_Holes:IsEndBlocked()
	return Game:GetTurnCount() < self:GetTurnLimit() - 1
end