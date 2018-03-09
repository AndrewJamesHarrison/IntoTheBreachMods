
---- MISSION DESCRIPTION
Mission_BlobBoss = Mission_Boss:new{
	SpawnStartMod = -1,
	SpawnMod = -1,
	BlobDeaths = 5,
	BossText = "Destroy 5 Goos",
	BossPawn = "BlobBoss",
	BlobList = nil
}

function Mission_BlobBoss:StartMission()
	self:StartBoss()
	self:GetSpawner():BlockPawns("Jelly_Explode")
end

function Mission_BlobBoss:CountDeadBlobs()
	self.BlobList = self.BlobList or {}
	
	local dead = 0
	for id, dummy in pairs(self.BlobList) do
		dead = dead + bool_int(not Board:IsPawnAlive(id))
	end
	
	return dead
end

function Mission_BlobBoss:UpdateMission()
	self.BlobList = self.BlobList or {}
	
	local pawns = extract_table(Board:GetPawns(TEAM_ENEMY))
	local count = 0
	for i, v in ipairs(pawns) do
		if string.find(Board:GetPawn(v):GetType(), "BlobBoss") ~= nil then
			self.BlobList[v] = true
		end
	end
end

function Mission_BlobBoss:UpdateObjectives()
	local status = self:CountDeadBlobs() >= self.BlobDeaths and OBJ_COMPLETE or OBJ_STANDARD
	if status ~= OBJ_COMPLETE then
		Game:AddObjective("Destroy "..self.BlobDeaths.." Goos \n("..self:CountDeadBlobs().." killed so far)",status)
	else
		Game:AddObjective("Destroy "..self.BlobDeaths.." Goos",status)
	end
end

function Mission_BlobBoss:IsBossDead()
	return self:CountDeadBlobs() >= self.BlobDeaths
end

BlobBoss = {
	Name = "Large Goo",
	Health = 3,
	MoveSpeed = 3,
	Image = "slimeb",		
	SkillList = { "BlobBossAtk" },
	DeathSpawn = "BlobBossMed",
	Massive = true,
	DefaultTeam = TEAM_ENEMY,
	Ranged = 0,
	SoundLocation = "/enemy/goo_boss/",
	ImpactMaterial = IMPACT_BLOB,
	IsDeathEffect = true,
	Tier = TIER_BOSS
	--Minor = true -- no XP
}
AddPawn("BlobBoss") 

function BlobBoss:GetDeathEffect(point)
	local ret = SkillEffect()
	
	if self.DeathSpawn == "" then return ret end
	
	ret:AddSound("/enemy/goo_boss/split")
	
	local vicinity = extract_table(general_DiamondTarget(point,4))
	local spawnPoints = {}
	local backup = {}
	for i,v in ipairs(vicinity) do
		if not Board:IsBlocked(v,PATH_GROUND) and
				v ~= point	then
			
			if point:Manhattan(v) > 2 then
				backup[#backup + 1] = v
			else
				spawnPoints[#spawnPoints + 1] = v
				--LOG("Valid target = "..spawnPoints[#spawnPoints]:GetString())
			end
			
		end
	end
	
	local spawn_amount = 2
		
	for i = 1, spawn_amount do
	
		local damage = SpaceDamage(0)
		if #spawnPoints ~= 0 then
			damage.loc = random_removal(spawnPoints)
		elseif #backup ~= 0 then
			damage.loc = random_removal(backup)
		else
			ret:AddScript("Board:AddAlert("..point:GetString()..",\"Alert_BlobSpawn\")")
			break
		end
		
		damage.sPawn = self.DeathSpawn
		damage.sSound = '/impact/generic/blob'
		ret:AddArtillery(damage,"effects/shotup_crab2.png",NO_DELAY)
		
	end
	
	return ret
end

BlobBossMed = BlobBoss:new{
	Name = "Medium Goo",
	Health = 2,
	Image = "slimeb2",		
	DeathSpawn = "BlobBossSmall",
	Massive = true,
	DefaultTeam = TEAM_ENEMY,
	Portrait = "enemy/BlobBoss",
	SoundLocation = "/enemy/goo_boss/",
	SkillList = { "BlobBossAtkMed" },
	ImpactMaterial = IMPACT_BLOB,
	--Minor = true -- no XP
}
	
AddPawnName("BlobBossMed") 

BlobBossSmall = BlobBoss:new{
	Name = "Small Goo",
	Health = 1,
	Image = "slimeb3",		
	DeathSpawn = "",
	DefaultTeam = TEAM_ENEMY,
	Portrait = "enemy/BlobBoss",
	SoundLocation = "/enemy/goo_boss/",
	ImpactMaterial = IMPACT_BLOB,
	SkillList = { "BlobBossAtkSmall" },
	Tier = TIER_NORMAL,
}
		
AddPawnName("BlobBossSmall") 

BlobBossAtk = Skill:new{
	PathSize = 1,
	ScoreNothing = 0,
	Class = "Enemy",
	TipImage = {
		Unit = Point(2,2),
		Building = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "BlobBoss",
	}
}

function BlobBossAtk:GetTargetArea(p1)
	local ret = PointList()
	--it can attack / destroy anything it moves over so it just has to check immovable things
	for dir = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[dir]
		
		if 	Board:IsValid(curr) then
			ret:push_back(curr)
		end
	end
	
	return ret
end
		
function BlobBossAtk:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	ret:AddQueuedDamage(SpaceDamage(p2,4))
	
	if Board:GetTerrain(p2) == TERRAIN_MOUNTAIN then
		ret:AddQueuedDamage(SpaceDamage(p2,4))
	end
	
	local pawn = Board:GetPawn(p2)
	
	if pawn == nil or not pawn:IsMech() then
		ret:AddQueuedMove(Board:GetSimplePath(p1, p2), FULL_DELAY)
	end
		
	return ret
end	

BlobBossAtkMed = BlobBossAtk:new{
	TipImage = {
		Unit = Point(2,2),
		Building = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "BlobBossMed",
	}
}

BlobBossAtkSmall = BlobBossAtk:new{
	TipImage = {
		Unit = Point(2,2),
		Building = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "BlobBossSmall",
	}
}