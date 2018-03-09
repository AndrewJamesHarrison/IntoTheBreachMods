
---- MISSION DESCRIPTION
Mission_JellyBoss = Mission_Boss:new{
	BossPawn = "Jelly_Boss",
	GlobalSpawnMod = -1,
	BossText = "Destroy the Psion Abomination"
}

function Mission_JellyBoss:StartMission()
	self:StartBoss()
	self:GetSpawner():BlockPawns({"Jelly_Health","Jelly_Explode","Jelly_Regen","Jelly_Armor"})
end

Jelly_Boss = {
	Name = "Psion Abomination",
	Health = 5,
	Image = "jelly",
	ImageOffset = 5,
	MoveSpeed = 3,
	DefaultTeam = TEAM_ENEMY,
	ImpactMaterial = IMPACT_BLOB,
	SoundLocation = "/enemy/jelly/",
	Flying = true,
	Leader = LEADER_BOSS,
	Tooltip = "Jelly_Boss_Tooltip",
	Portrait = "enemy/JellyB",
	Tier = TIER_BOSS,
}

Jelly_Boss_Tooltip = Jelly_Health_Tooltip:new{
	Class = "Passive",
	PathSize = 1,
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,1),
		CustomPawn = "Jelly_Boss",
	}
}
	
AddPawn("Jelly_Boss")
