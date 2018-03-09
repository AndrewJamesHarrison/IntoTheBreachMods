
---- MISSION DESCRIPTION
Mission_FireflyBoss = Mission_Boss:new{
--	Name = "Firefly Boss",
	BossPawn = "FireflyBoss",
	GlobalSpawnMod = -1,
	BossText = "Destroy the Firefly Leader"
}

-------- BOSS DESCRIPTION
FireflyBoss = {
	Name = "Firefly Leader",
	Health = 6,
	MoveSpeed = 3,
	Image = "firefly",
	ImageOffset = 2,
	SkillList = { "FireflyAtkB" },
	Ranged = 1,
	SoundLocation = "/enemy/firefly_soldier_1/",
	Massive = true,
	ImpactMaterial = IMPACT_FLESH,
	DefaultTeam = TEAM_ENEMY,
	Portrait = "enemy/FireflyB",
	Tier = TIER_BOSS,
}
AddPawn("FireflyBoss") 


FireflyAtkB = 	{
	Damage = 4, 
	PathSize = 1,
	Range = RANGE_PROJECTILE,
	Class = "Enemy",
	Icon = "weapons/enemy_firefly1.png",
	Explosion = "ExploFirefly1",
	ImpactSound = "/impact/dynamic/enemy_projectile",
	Projectile = "effects/shot_firefly",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,0),
		Enemy2 = Point(2,4),
		Target = Point(2,1),
		CustomPawn = "FireflyBoss"
	}
}
			
FireflyAtkB = Skill:new(FireflyAtkB)

function FireflyAtkB:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local backdir = GetDirection(p1 - p2)
			
	local target = GetProjectileEnd(p1,p2)  
	local damage = SpaceDamage(target, self.Damage)
	
	ret:AddQueuedProjectile(damage,self.Projectile, NO_DELAY)
	--ret.path = Board:GetSimplePath(p1, target)
	
	
	local target2 = GetProjectileEnd(p1,p1 + DIR_VECTORS[backdir])

	if target2 ~= p1 then
		damage = SpaceDamage(target2, self.Damage)
		ret:AddQueuedProjectile(damage,self.Projectile)
	end
		
	return ret
end
