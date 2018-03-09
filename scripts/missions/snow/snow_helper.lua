
Freeze_Tank = 
{
	Name = "Freeze Tank",
	Health = 1,
	MoveSpeed = 4,
	Image = "TankIce1",
	SkillList = { "Pinnacle_FreezeTank" },
	SoundLocation = "/support/civilian_tank/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
	Corporate = true,
}
AddPawn("Freeze_Tank")

Pinnacle_FreezeTank = TankDefault:new{
	Name = "Freeze Cannon",
	Class = "",
	Description = "Shoot a projectile that freezes targets",
	Icon = "weapons/mission_tankice.png",
	ProjectileArt = "effects/shot_tankice",
	LaunchSound = "/support/civilian_tank/fire",
	Rarity = 0,
	Damage = 0,
	Push = 0,
	Freeze = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Freeze_Tank"
	}
}
