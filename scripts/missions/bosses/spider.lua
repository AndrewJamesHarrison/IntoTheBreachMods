
---- MISSION DESCRIPTION
Mission_SpiderBoss = Mission_Boss:new{
--	Name = "Spider Boss",
	BossPawn = "SpiderBoss",
	GlobalSpawnMod = -2,
	BossText = "Destroy the Spider Leader",
	EggCount = -1,
}

function Mission_SpiderBoss:StartMission()
	self:StartBoss()
	self:GetSpawner():BlockPawns("Blobber")
	self:GetSpawner():BlockPawns("Spider")
	
	for i = 1,2 do
		Board:AddPawn("SpiderlingEgg1")
	end
	--local spawns = self:SpawnSpiderlings()
	---we have to make sure the game doesn't spawn enemies on those tiles
	--for i, v in ipairs(spawns) do
	--	Board:BlockSpawn(v,BLOCKED_TEMP)
	--end`
end

function Mission_SpiderBoss:UpdateSpawning()
	self:SpawnPawns(self:GetSpawnCount())--spawn first so the spiderlings know where not to spawn
	self:SpawnSpiderlings()
end

function Mission_SpiderBoss:SpawnSpiderlings()
	if self:IsBossDead() then
		return
	end
	
	if Board:GetPawn(self.BossID):IsFrozen() then
		return
	end
	
	if self.EggCount == -1 or GetDifficulty() == DIFF_EASY then
		self.EggCount = 2
	else
		self.EggCount = self.EggCount == 2 and 3 or 2
	end
	
	local proj_info = { image = "effects/shotup_spider.png", launch = "/enemy/spider_boss_1/attack_egg_launch", impact = "/enemy/spider_boss_1/attack_egg_land" }
	return self:FlyingSpawns(Board:GetPawnSpace(self.BossID),self.EggCount,"SpiderlingEgg1",proj_info)
end

-------- BOSS DESCRIPTION
SpiderBoss = {
	Name = "Spider Leader",
	Health = 6,
	MoveSpeed = 2,
	Image = "spider",
	ImageOffset = 2,
	SkillList = { },--"SpiderAtk1" },
	Ranged = 1,
	SoundLocation = "/enemy/spider_boss_1/",
	Massive = true,
	Jumper = true,
	IgnoreSmoke = true,
	ImpactMaterial = IMPACT_FLESH,
	DefaultTeam = TEAM_ENEMY,
	Portrait = "enemy/SpiderB",
	Tooltip = "SpiderBoss_Tooltip",
	Tier = TIER_BOSS,
}
AddPawn("SpiderBoss") 

SpiderBoss_Tooltip = SelfTarget:new{
	Class = "Enemy",
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		CustomPawn = "SpiderBoss",
		Length = 6,
	}
}

function SpiderBoss_Tooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	ret:AddScript("Mission:FlyingSpawns(Point(2,2),3,\"SpiderlingEgg1\", { image = \"effects/shotup_spider.png\", launch = \"/enemy/spider_boss_1/attack_egg_launch\", impact = \"/enemy/spider_boss_1/attack_egg_land\" })")
	return ret
end

-- SUPPORT UNIT DESCRIPTION

SpiderlingEgg1 ={
	Name = "Spiderling Egg",
	Health = 1,
	MoveSpeed = 0,
	Image = "spiderling_egg1",
	Minor = true,
	IgnoreSmoke = true,
	IsPortrait = false,
	DefaultTeam = TEAM_ENEMY,
	SkillList = { "SpiderlingHatch1" },
	SoundLocation = "/enemy/spiderling_egg/",
	ImpactMaterial = IMPACT_FLESH,
}
	
AddPawn("SpiderlingEgg1")

SpiderlingHatch1 = SelfTarget:new{ 
	SpiderType = "Spiderling1",
	Class = "Enemy",
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		CustomPawn = "SpiderlingEgg1",
	}	
}

function SpiderlingHatch1:GetTargetScore(p)
	return 10
end

function SpiderlingHatch1:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	ret:AddScript("Board:RemovePawn("..p1:GetString()..")")
	local damage = SpaceDamage(p1)
	damage.sPawn = self.SpiderType
	damage.sSound = "/enemy/spiderling_egg/hatch"
	ret:AddDamage(damage)
	
	return ret
end

