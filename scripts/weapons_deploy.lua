

--[[   weapons within:
	DeploySkill_ShieldTank
	DeploySkill_Tank
    DeploySkill_AcidTank
	DeploySkill_PullTank

    -----DeploySkill_IceTank
]]--


--------------------------------------------------------------------------


Deploy_Tank = Pawn:new{
	Name = "Support Tank",
	Health = 1,
	MoveSpeed = 3,
	Image = "SmallTank1",
	SkillList = { "Deploy_TankShot" },
	--SoundLocation = "/support/civilian_tank/", -- not implemented
	SoundLocation = "/mech/brute/tank",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
	--Corporate = true
}

Deploy_TankA = Deploy_Tank:new{ Health = 3 }

Deploy_TankB = Deploy_Tank:new{ SkillList = {"Deploy_TankShot2"} }

Deploy_TankAB = Deploy_Tank:new{Health = 3, SkillList = {"Deploy_TankShot2"}}

---
Deploy_TankShot = TankDefault:new {
	Rarity = 0,
	Damage = 0,
	Class = "Unique",
	Icon = "weapons/deploy_tank.png",
	Push = 1,
	LaunchSound = "/weapons/stock_cannons",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Deploy_Tank"
	}
}

Deploy_TankShot2 = Deploy_TankShot:new{ Damage = 2 }
--
DeploySkill_Tank = Deployable:new{
	Icon = "weapons/deployskill_tank.png",
	Rarity = 1,
	Deployed = "Deploy_Tank",
	Projectile = "effects/shotup_tank.png",
	Cost = "med",
	PowerCost = 2,
	Upgrades = 2,
	UpgradeCost = {1,3},
	--UpgradeList = { "+2 Health", "+2 Damage" },
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit = Point(1,3),
		Target = Point(1,1),
		Enemy = Point(3,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(2,1),
	},
}

DeploySkill_Tank_A = DeploySkill_Tank:new{
		Deployed = "Deploy_TankA",
}
DeploySkill_Tank_B = DeploySkill_Tank:new{
		Deployed = "Deploy_TankB",
}
DeploySkill_Tank_AB = DeploySkill_Tank:new{
		Deployed = "Deploy_TankAB",
}
--------------------

--------------------------------------------------------------------------
--------------------------------------------------------------------------


Deploy_ShieldTank = Pawn:new{
	Name = "Shield Tank",
	Health = 1,
	MoveSpeed = 3,
	Image = "ShieldTank1",
	SkillList = { "Deploy_ShieldTankShot" },
	--SoundLocation = "/support/civilian_tank/", -- not implemented
	SoundLocation = "/mech/brute/tank",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
--Corporate = true
}

Deploy_ShieldTankA = Deploy_ShieldTank:new{ Health = 3 }

Deploy_ShieldTankB = Deploy_ShieldTank:new{ SkillList = {"Deploy_ShieldTankShot2"} }

Deploy_ShieldTankAB = Deploy_ShieldTank:new{Health = 3, SkillList = {"Deploy_ShieldTankShot2"}}

---

Deploy_ShieldTankShot = Skill:new{  
	Icon = "weapons/deploy_shieldtank.png",
	--Explosion = "ExploAir2",
	LaunchSound = "/weapons/area_shield",
	Range = 1, -- Tooltip?
	PathSize = 1,
	Class = "Unique",
	Damage = 0,
	TipImage = {
		Unit = Point(2,2),
		Building = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Deploy_ShieldTank"
	}
}
				
function Deploy_ShieldTankShot:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	damage = SpaceDamage(p2,0)
	damage.iShield = 1
	ret:AddMelee(p1,damage)
	
	return ret
end	

Deploy_ShieldTankShot2 = TankDefault:new {
	Rarity = 0,
	Damage = 0,
	Icon = "weapons/deploy_shieldtank.png",
	ProjectileArt = "effects/shot_pull",
	Push = 0,
	Class = "Unique",
	Explosion = "",
	Shield = 1,
	LaunchSound = "/weapons/area_shield",
	--ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Building = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Deploy_ShieldTank"
	}
}

function Deploy_ShieldTankShot2:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)


	local target = GetProjectileEnd(p1,p2,PATH_PROJECTILE)  
	
	local damage = SpaceDamage(target, self.Damage)
	damage.iShield = self.Shield
	ret:AddProjectile(damage, self.ProjectileArt, NO_DELAY)
	
	return ret
end
--
DeploySkill_ShieldTank = Deployable:new{
	Icon = "weapons/deployskill_shieldtank.png",
	Rarity = 1,
	Deployed = "Deploy_ShieldTank",
	Projectile = "effects/shotup_shieldtank.png",
	Cost = "med",
	PowerCost = 2,
	Upgrades = 2,
	UpgradeCost = {1,1},
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,1),
		Friendly = Point(3,1),
		Second_Origin = Point(2,1),
		Second_Target = Point(3,1),
	},
}

DeploySkill_ShieldTank_A = DeploySkill_ShieldTank:new{
		Deployed = "Deploy_ShieldTankA",
}
DeploySkill_ShieldTank_B = DeploySkill_ShieldTank:new{
		Deployed = "Deploy_ShieldTankB",
		TipImage = {
			Unit = Point(1,3),
			Target = Point(1,1),
			Friendly = Point(3,1),
			Second_Origin = Point(1,1),
			Second_Target = Point(2,1),
		},
}
DeploySkill_ShieldTank_AB = DeploySkill_ShieldTank:new{
		Deployed = "Deploy_ShieldTankAB",
		TipImage = {
			Unit = Point(1,3),
			Target = Point(1,1),
			Friendly = Point(3,1),
			Second_Origin = Point(1,1),
			Second_Target = Point(2,1),
		},
}

---- just to preserve obsolete versions of the game -----
DeploySkill_SGenerator = DeploySkill_ShieldTank
DeploySkill_SGenerator_A = DeploySkill_ShieldTank_A
DeploySkill_SGenerator_B = DeploySkill_ShieldTank_B
DeploySkill_SGenerator_AB = DeploySkill_ShieldTank_AB
--------------------

--------------------------------------------------------------------------
--------------------------------------------------------------------------


Deploy_AcidTank = Pawn:new{
	Name = "A.C.I.D. Tank",
	Health = 1,
	MoveSpeed = 3,
	Image = "TankAcid2",
	SkillList = { "Deploy_AcidTankShot" },
	SoundLocation = "/support/civilian_tank/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
	--Corporate = true
}

Deploy_AcidTankA = Deploy_AcidTank:new{ Health = 3 }

Deploy_AcidTankB = Deploy_AcidTank:new{ SkillList = {"Deploy_AcidTankShot2"} }

Deploy_AcidTankAB = Deploy_AcidTank:new{Health = 3, SkillList = {"Deploy_AcidTankShot2"}}

---
Deploy_AcidTankShot = TankDefault:new {
	Range = RANGE_PROJECTILE,
	Class = "Unique",
	Icon = "weapons/deploy_acidtank.png",
	Rarity = 0,
	Explosion = "ExploAcid1",
	ProjectileArt = "effects/shot_tankacid",
	Damage = 0,
	Push = 0,
	Acid = 1,
	PowerCost = 0,
	Upgrades = 0,
	LaunchSound = "/weapons/acid_shot",
	ImpactSound = "/impact/generic/acid_canister",
	TipImage = StandardTips.Ranged
}

function Deploy_AcidTankShot:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)


	local target = GetProjectileEnd(p1,p2,PATH_PROJECTILE)  
	
	local damage = SpaceDamage(target, self.Damage)
	if self.Push == 1 then
		damage = SpaceDamage(target, self.Damage, direction)
	end
	damage.iAcid = self.Acid
	damage.sAnimation = "ExploAcid1"
	ret:AddProjectile(damage, self.ProjectileArt, NO_DELAY)
	
	return ret
end

Deploy_AcidTankShot2 = Deploy_AcidTankShot:new{ Push = 1 }
--
DeploySkill_AcidTank = Deployable:new{
	Icon = "weapons/deployskill_acidtank.png",
	Rarity = 1,
	Deployed = "Deploy_AcidTank",
	Projectile = "effects/shotup_acidtank.png",
	Cost = "med",
	PowerCost = 2,
	Upgrades = 2,
	UpgradeCost = {1,1},
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit = Point(1,3),
		Target = Point(1,1),
		Enemy = Point(3,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(2,1),
	},
}

DeploySkill_AcidTank_A = DeploySkill_AcidTank:new{
		Deployed = "Deploy_AcidTankA",
}
DeploySkill_AcidTank_B = DeploySkill_AcidTank:new{
		Deployed = "Deploy_AcidTankB",
}
DeploySkill_AcidTank_AB = DeploySkill_AcidTank:new{
		Deployed = "Deploy_AcidTankAB",
}

--------------------

--------------------------------------------------------------------------
--------------------------------------------------------------------------

Deploy_IceTank = Pawn:new{
	Name = "Support IceTank",
	Health = 1,
	MoveSpeed = 3,
	Image = "TankIce1",
	SkillList = { "Deploy_IceTankShot" },
	--SoundLocation = "/support/civilian_tank/", -- not implemented
	SoundLocation = "/mech/brute/tank",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
	--Corporate = true
}

Deploy_IceTankA = Deploy_IceTank:new{Health = 2}

Deploy_IceTankB = Deploy_IceTank:new{Health = 2}

Deploy_IceTankAB = Deploy_IceTank:new{Health = 3}

---
Deploy_IceTankShot = TankDefault:new {
	Range = RANGE_PROJECTILE,
	Class = "Unique",
	Icon = "weapons/mission_tankice.png",
	Rarity = 0,
	Explosion = "",
	ProjectileArt = "effects/shot_tankice",
	Damage = 0,
	Push = 0,
	Freeze = 1,
	PowerCost = 0,
	Upgrades = 0,
	LaunchSound = "/enemy/snowtank_1/attack",
	ImpactSound = "/impact/generic/explosion",
	TipImage = StandardTips.Ranged
}

--
DeploySkill_IceTank = Deployable:new{
	Icon = "weapons/skill_default.png",
	Rarity = 1,
	Deployed = "Deploy_IceTank",
	Projectile = "effects/shotup_tank.png",
	Cost = "med",
	PowerCost = 2,
	Upgrades = 2,
	UpgradeCost = {1,1},
	TipImage = StandardTips.Deploy,
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
}

DeploySkill_IceTank_A = DeploySkill_IceTank:new{
		Deployed = "Deploy_IceTankB",
}
DeploySkill_IceTank_B = DeploySkill_IceTank:new{
		Deployed = "Deploy_IceTankA",
}
DeploySkill_IceTank_AB = DeploySkill_IceTank:new{
		Deployed = "Deploy_IceTankAB",
}

--------------------------------------------------------------------------
--------------------------------------------------------------------------


Deploy_PullTank = Pawn:new{
	Name = "Pull Tank",
	Health = 1,
	MoveSpeed = 3,
	Image = "PullTank1",
	SkillList = { "Deploy_PullTankShot" },
	--SoundLocation = "/support/civilian_tank/", -- not implemented
	SoundLocation = "/mech/brute/tank",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
--Corporate = true
}

Deploy_PullTankA = Deploy_PullTank:new{ Health = 3 }

Deploy_PullTankB = Deploy_PullTank:new{Flying = true, Image = "PullTank2", }

Deploy_PullTankAB = Deploy_PullTank:new{Health = 3, Flying = true, Image = "PullTank2", }

---

Deploy_PullTankShot = Science_Pullmech:new{ Class = "Unique", } --Weapon for the actual tank
				
--
DeploySkill_PullTank = Deployable:new{
	Icon = "weapons/deployskill_pulltank.png",
	Rarity = 1,
	Deployed = "Deploy_PullTank",
	Projectile = "effects/shotup_pulltank.png",
	Cost = "med",
	PowerCost = 2,
	Upgrades = 2,
	UpgradeCost = {1,1},
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit = Point(1,3),
		Target = Point(1,1),
		Enemy = Point(3,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(2,1),
	},
}

DeploySkill_PullTank_A = DeploySkill_PullTank:new{
		Deployed = "Deploy_PullTankA",
}
DeploySkill_PullTank_B = DeploySkill_PullTank:new{
		Deployed = "Deploy_PullTankB",
}
DeploySkill_PullTank_AB = DeploySkill_PullTank:new{
		Deployed = "Deploy_PullTankAB",
}

--------------------------------UNUSED------------------------------------------
--------------------------------UNUSED------------------------------------------
--------------------------------UNUSED------------------------------------------
--[[
SGenerator = Pawn:new{
	Name = "Shield Generator",
	Image = "generator1",
	Health = 1,
	MoveSpeed = 0,
	SoundLocation = "/support/sgenerator",
	SkillList = { "SGenerator1_Attack" },  -- Turret_Base
	DefaultTeam = TEAM_PLAYER
}

SGeneratorA = SGenerator:new{ SkillList = {"SGenerator2_Attack"} }

SGeneratorB = SGenerator:new{Health = 3}

SGeneratorAB = SGenerator:new{Health = 3, SkillList = {"SGenerator2_Attack"}}

-------------

SGenerator1_Attack = Skill:new{  
	Range = 1,
	PathSize = 1,
	Icon = "weapons/deployskill_sgenerator.png",
	IgnoreEnemy = false,
	Explosion = "",
	Upgrades = 0,
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,1),
		Enemy = Point(2,3),
		Building1 = Point(3,2),
		Building2 = Point(2,1),
		CustomPawn = "SGenerator"
	}
}
				
function SGenerator1_Attack:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local damage = SpaceDamage(p1,0)
	damage.iShield = 1
	for i = DIR_START, DIR_END do
		damage.loc = p1 + DIR_VECTORS[i]
		if not self.IgnoreEnemy or not Board:IsPawnTeam(p1 + DIR_VECTORS[i], TEAM_ENEMY) then
			ret:AddDamage(damage)
		end
	end
	
	return ret
end	
--
SGenerator2_Attack = SGenerator1_Attack:new{ Description = "Shield the adjacent tiles, ignoring enemies.", IgnoreEnemy = true }
--

DeploySkill_SGenerator = Deployable:new{
	Icon = "weapons/deployskill_sgenerator.png",
	Rarity = 1,
	Deployed = "SGenerator",
	Projectile = "effects/shotup_sgenerator.png",
	Cost = "med",
	PowerCost = 2,
	Limited = 1,
	Upgrades = 2,
	UpgradeCost = {1,2},
	--UpgradeList = { "Ignore Enemies", "+2 Health" },
	TipImage = StandardTips.Deploy,
	LaunchSound = "/weapons/deploy_shield",
	ImpactSound = "/impact/generic/mech",
}

DeploySkill_SGenerator_A = DeploySkill_SGenerator:new{
		Deployed = "SGeneratorA",
}
DeploySkill_SGenerator_B = DeploySkill_SGenerator:new{
		Deployed = "SGeneratorB",
}
DeploySkill_SGenerator_AB = DeploySkill_SGenerator:new{
		Deployed = "SGeneratorAB",
}
]]
