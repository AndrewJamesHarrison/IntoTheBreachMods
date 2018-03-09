
---- MISSION DESCRIPTION
Mission_BeetleBoss = Mission_Boss:new{
--	Name = "Beetle Boss",
	BossPawn = "BeetleBoss",
	GlobalSpawnMod = -1,
	BossText = "Destroy the Beetle Leader"
}

-------- BOSS DESCRIPTION
BeetleBoss = {
	Name = "Beetle Leader",
	Health = 6,
	MoveSpeed = 3,
	Image = "beetle",
	ImageOffset = 2,
	SkillList = { "BeetleAtkB" },
	Ranged = 1,
	SoundLocation = "/enemy/beetle_1/",
	Massive = true,
	ImpactMaterial = IMPACT_FLESH,
	DefaultTeam = TEAM_ENEMY,
	Portrait = "enemy/BeetleB",
	Tier = TIER_BOSS,
}
AddPawn("BeetleBoss") 


BeetleAtkB = BeetleAtk1:new{
	Damage = 3, 
	Fly = 1,
	Fire = true,
	Class = "Enemy",
	Explosion = "",
	ImpactSound = "/impact/dynamic/enemy_projectile",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,2),
		CustomPawn = "BeetleBoss"
	}
}

