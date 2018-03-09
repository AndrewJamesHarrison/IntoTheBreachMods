
---- MISSION DESCRIPTION
Mission_ScorpionBoss = Mission_Boss:new{
--	Name = "Scorpion Boss",
	BossPawn = "ScorpionBoss",
	GlobalSpawnMod = -1,
	BossText = "Destroy the Scorpion Leader"
}

-------- BOSS DESCRIPTION
ScorpionBoss = {
	Name = "Scorpion Leader",
	Health = 7,
	MoveSpeed = 3,
	Image = "scorpion",
	ImageOffset = 2,
	SkillList = { "ScorpionAtkB" },
	Ranged = 1,
	SoundLocation = "/enemy/scorpion_soldier_1/",
	Massive = true,
	ImpactMaterial = IMPACT_FLESH,
	DefaultTeam = TEAM_ENEMY,
	Portrait = "enemy/ScorpionB",
	Tier = TIER_BOSS,
}
AddPawn("ScorpionBoss") 


ScorpionAtkB = Skill:new{
	Name = "XXXx",
	Description = "XXXX",
	Damage = 2, 
	Class = "Enemy",
	Explosion = "",
	LaunchSound = "",
	SoundBase = "/enemy/scorpion_soldier_1",
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		Enemy = Point(2,3),
		Enemy2 = Point(3,2),
		Building = Point(2,1),
		CustomPawn = "ScorpionBoss"
	}
}

function ScorpionAtkB:GetTargetArea(point)
	local ret = PointList()
	ret:push_back(point)
	return ret
end
			
function ScorpionAtkB:GetSkillEffect(p1,p2)
	local ret = SkillEffect()

	for dir = DIR_START, DIR_END do 
		local damage = SpaceDamage(p1 + DIR_VECTORS[dir],self.Damage, dir)
		damage.sAnimation = "SwipeClaw2"
		damage.sSound = self.SoundBase.."/attack"
		ret:AddQueuedMelee(p1,damage,0.35)
		
		ret:AddDamage(SoundEffect(p1 + DIR_VECTORS[dir],self.SoundBase.."/attack_web"))
		ret:AddGrapple(p1,p1 + DIR_VECTORS[dir],"hold")
		
	end
	
	
	return ret
end