
---- MISSION DESCRIPTION
Mission_SlugBoss = Mission_Boss:new{
--	Name = "Slug Boss",
	BossPawn = "SlugBoss",
	GlobalSpawnMod = -1,
	BossText = "Destroy the Slug Leader"
}

function Mission_SlugBoss:StartMission()
	self:StartBoss()
	
	local spawns = self:SpawnSluglings()
	---we have to make sure the game doesn't spawn enemies on those tiles
	for i, v in ipairs(spawns) do
		Board:BlockSpawn(v,BLOCKED_TEMP)
	end
end

function Mission_SlugBoss:UpdateSpawning()
	self:SpawnPawns(self:GetSpawnCount())--spawn first so the spiderlings know where not to spawn
	self:SpawnSluglings()
end

function Mission_SlugBoss:SpawnSluglings()
	if self:IsBossDead() then
		return
	end
	local proj_info = { image = "effects/shotup_spider.png", launch = "/enemy/spider_boss_1/attack_egg_launch", impact = "/enemy/spider_boss_1/attack_egg_land" }
	return self:FlyingSpawns(Board:GetPawnSpace(self.BossID),2,"SlugEgg1",proj_info)  --was 2
end

-------- BOSS DESCRIPTION
SlugBoss = 
	{
		Name = "Hive Leader",
		Health = 6,
		MoveSpeed = 2,
		Image = "slugb",
		SkillList = { },--"SlugAtk1" },
		Ranged = 1,
		SoundLocation = "/enemy/spider_boss_1/",
		Massive = true,
		Explodes = true,
		ImpactMaterial = IMPACT_FLESH,
		DefaultTeam = TEAM_ENEMY,
		Portrait = "enemy/SlugB"
	}
AddPawn("SlugBoss") 

-- SUPPORT UNIT DESCRIPTION

SlugEgg1 =
	{
		Name = "Slugling Egg",
		Health = 1,
		MoveSpeed = 0,
		Image = "sluglingb",
		Minor = true,
		Explodes = true,
		DefaultTeam = TEAM_ENEMY,
		SkillList = { },
		SoundLocation = "/enemy/spiderling_egg/",
		ImpactMaterial = IMPACT_FLESH
	}
	
AddPawn("SlugEgg1")

