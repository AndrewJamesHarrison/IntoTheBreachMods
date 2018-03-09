
---- MISSION DESCRIPTION
Mission_HornetBoss = Mission_Boss:new{
--	Name = "Hornet Boss",
	BossPawn = "HornetBoss",
	GlobalSpawnMod = -1,
	BossText = "Destroy the Hornet Leader"
}

-------- BOSS DESCRIPTION
HornetBoss = {
	Name = "Hornet Leader",
	Health = 6,
	MoveSpeed = 3,
	Image = "hornet",
	ImageOffset = 2,
	SkillList = { "HornetAtkB" },
	Ranged = 1,
	SoundLocation = "/enemy/hornet_1/",
	Massive = true,
	Flying = true,
	ImpactMaterial = IMPACT_FLESH,
	DefaultTeam = TEAM_ENEMY,
	Portrait = "enemy/HornetB",
	Tier = TIER_BOSS,
}
AddPawn("HornetBoss") 


HornetAtkB = Skill:new{
	Damage = 2,
	PathSize = 1,
	Class = "Enemy",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Building = Point(2,0),
		Target = Point(2,2),
		CustomPawn = "HornetBoss"
	}
}
			
function HornetAtkB:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)	
	
	local damage = SpaceDamage(p2,self.Damage)
	damage.sAnimation = "explohornet_"..direction
	
	ret:AddQueuedMelee(p1,damage,0.25)
	
--	delay:AddDelay(0.2)
	damage.loc = p2+DIR_VECTORS[direction]
	ret:AddQueuedDamage(damage)
	
	--delay:AddDelay(0.5)
	damage.loc = p2+DIR_VECTORS[direction]+DIR_VECTORS[direction]
	ret:AddQueuedDamage(damage)
	
	
	return ret
end
