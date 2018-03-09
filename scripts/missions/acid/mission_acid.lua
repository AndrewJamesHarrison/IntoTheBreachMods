
Mission_Acid = Mission_Infinite:new{ 
	MapTags = { "acid_pool" },
	UseBonus = true,
	SpawnTable = nil,
	SpawnMod = -1,
	AcidSpawn = 1,
	BonusPool = {BONUS_GRID, BONUS_MECHS, BONUS_KILL_FIVE}
}

function Mission_Acid:StartMission()
	--if Board:IsAcid(Point(0,0)) then LOG("ACID") else LOG("NOT ACID") end
	self.SpawnTable = self:GetBoardList(function(p) return Board:IsAcid(p) and Board:GetTerrain(p) == TERRAIN_WATER end)
	--self:SpawnAcidMonsters(1)
end

function Mission_Acid:UpdateSpawning()
	self:SpawnPawns(self:GetSpawnCount())
	if not self:IsFinalTurn() then
		self:SpawnAcidMonsters(self.AcidSpawn)
	end
end

function Mission_Acid:SpawnAcidMonsters(count)
	local options = {}
	for i,v in ipairs(self.SpawnTable) do
		if not Board:IsBlocked(v, PATH_FLYER) and not Board:IsPod(v) and not Board:IsSpawning(v) then
			options[#options+1] = v
		end
	end
	count = math.min(count,#options)
	
	for i = 1, count do
		local pawn = self:NextPawn()
		Board:SpawnPawn(pawn,random_removal(options))
		pawn:SetAcid(true)
	end
end