
--[[

In this file:

Passive_FlameImmune
Passive_Electric
Passive_Leech
Passive_MassRepair
Passive_Defenses
Passive_Burrows
Passive_AutoShields
Passive_Psions
Passive_Boosters
Passive_Medical
Passive_FriendlyFire
Passive_FastDecay
Passive_ForceAmp
Passive_Ammo
Passive_CritDefense

--]]


PassiveSkill = Artillery:new{ --grenade to make fake tooltips easier
	Class = "",
	Explosion  = "",
}

Passive_FlameImmune = PassiveSkill:new{
	Passive = "Flame_Immune",
	Icon = "weapons/passives/passive_flameimmune.png",
	PowerCost = 1,
	TipImage = {
		Unit = Point(2,3),
		Friendly = Point(2,1),
		Friendly2 = Point(3,2),
		Fire1 = Point(2,3),
		Fire2 = Point(2,1),
		Fire3 = Point(3,2),
	}
}

Passive_Electric = PassiveSkill:new{
	PowerCost = 1,
	Passive = "Electric_Smoke",
	Icon = "weapons/passives/passive_electric.png",
	Upgrades = 1,
	UpgradeCost = {3},
--	UpgradeList = { "+1 Damage" },
	Damage = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Smoke = Point(2,1),
		Target = Point(2,1),
	}
}

function Passive_Electric:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	ret:AddDamage(SpaceDamage(Point(2,1),self.Damage))
	return ret
end

Passive_Electric_A = Passive_Electric:new{
	Damage = 2,
	Passive = "Electric_Smoke_A"
}

-------------------

Passive_Leech = PassiveSkill:new{
	PowerCost = 1,
	Passive = "Leech_Kill",
	Icon = "weapons/passives/passive_leech.png",
	Upgrades = 1,
	Heal = 1,
	UpgradeCost = {3},
--	UpgradeList = { "+1 Heal" },
	TipImage = {
		Unit = Point(2,3),
		Enemy2 = Point(3,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
	}
}

function Passive_Leech:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(Point(2,3), 2)
	damage.bHide = true
	ret:AddMelee(Point(3,3),damage)
	ret:AddDelay(1.5)
	damage.loc = Point(2,1)
	damage.iDamage = 6
	ret:AddProjectile(damage, "effects/shot_mechtank")
	damage.loc = Point(2,3)
	damage.iDamage = -self.Heal
	ret:AddDamage(damage)
	return ret
end

Passive_Leech_A = Passive_Leech:new{
	Passive = "Leech_Kill_A",
	Heal = 2
}

----------------------

Passive_Defenses = PassiveSkill:new{
	PowerCost = 1,
	Icon = "weapons/passives/passive_defenses.png",
	Passive = "Bonus_Health",
	Upgrades = 1,
	Health = 1,
	UpgradeCost = {2},
--	UpgradeList = { "+1 Health" },
	TipImage = {
		Unit = Point(2,3),
		Friendly = Point(2,1),
		Friendly2 = Point(3,2),
	}
}

Passive_Defenses_A = Passive_Defenses:new{
	Passive = "Bonus_Health_A",
	Health = 2
}

-----------------------

Passive_MassRepair = PassiveSkill:new{
	PowerCost = 1,
	Icon = "weapons/passives/passive_massrepair.png",
	Passive = "Mass_Repair",
	TipImage = {
		Unit_Damaged = Point(2,3),
		Friendly_Damaged = Point(2,1),
		Friendly2_Damaged = Point(3,2),
		Target = Point(2,4),
	}
}

function Passive_MassRepair:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local points = {Point(2,3),Point(2,1),Point(3,2)}
	
	--for i,v in ipairs(points) do
	--	local damage = SpaceDamage(v, 2)
	--	damage.bHide = true
	--	ret:AddDamage(damage)
	--end
	
	--ret:AddDelay(1.5)
	
	for i,v in ipairs(points) do
		local damage = SpaceDamage(v, -20)
		damage.bHide = i ~= 1
		ret:AddDamage(damage)
	end
	
	return ret
end

--------------------------------------------------------

Passive_AutoShields = PassiveSkill:new{
	PowerCost = 0,
	Icon = "weapons/passives/passive_autoshields.png",
	Passive = "Auto_Shield",
	Explosion = "",
	TipImage = {
		Unit = Point(2,2),
		Building = Point(2,1),
		CustomPawn = "Scorpion1"
	}
}

function Passive_AutoShields:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(Point(2,1), 1)
	damage.bHide = true
	ret:AddDelay(0.5)
	ret:AddMelee(Point(2,2),damage)
	return ret
end

----------------------------------------------------------

Passive_Burrows = PassiveSkill:new{
	PowerCost = 1,
	Icon = "weapons/passives/passive_burrows.png",
	Passive = "Passive_Burrows",
	TipImage = {
		Unit = Point(2,2),
		Spawn = Point(2,2),
	}
}

-------------------------------------------------

Passive_Psions = PassiveSkill:new{
	PowerCost = 1,
	Icon = "weapons/passives/passive_psions.png",
	Passive = "Psion_Leech",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		CustomPawn = "Jelly_Health1"
	}
}

---------------------------------------------

Passive_Boosters = PassiveSkill:new{
	PowerCost = 0,
	Icon = "weapons/passives/passive_boosters.png",
	Passive = "Kickoff_Booster",
	Upgrades = 1,
	UpgradeCost = {2},
--	UpgradeList = { "+1 Movement" },
	TipImage = {
		Unit = Point(2,2),
		Friendly = Point(2,1),
	}
}

function Passive_Boosters:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	--ret:AddDelay(1)
	ret:AddScript("Board:GetPawn(Point(2,2)):AddMoveBonus(1)")
	ret:AddScript("Board:GetPawn(Point(2,1)):AddMoveBonus(1)")
	ret:AddDelay(1)
	return ret
end

Passive_Boosters_A = Passive_Boosters:new{
	Passive = "Kickoff_Booster_A"
}

-------------------------------------------------

Passive_Medical = PassiveSkill:new{
	PowerCost = 1,
	Icon = "weapons/passives/passive_medical.png",
	Passive = "Passive_Medical",
	Upgrades = 0,
	TipImage = {
		Unit = Point(2,2),
	}
}

function Passive_Medical:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(Point(2,2),5)
	damage.bHide = true
	ret:AddDelay(1)
	ret:AddDamage(damage)
	return ret
end

------------------------------------------------------

Passive_FriendlyFire = PassiveSkill:new{
	PowerCost = 1,
	Icon = "weapons/passives/passive_friendlyfire.png",
	Upgrades = 2,
	UpgradeCost = {1,2},
	Damage = 1,--only used for tooltips
	--UpgradeList = { "+1 Damage", "+1 Damage" },
	Passive = "Passive_FriendlyFire",
	TipImage = {
		Unit = Point(2,2),
		CustomPawn = "Scorpion2",
		Friendly = Point(2,1),
	}
}

function Passive_FriendlyFire:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	ret:AddMelee(Point(2,1),SpaceDamage(Point(2,2),1 + self.Damage))
	return ret
end

Passive_FriendlyFire_A = Passive_FriendlyFire:new{
	Damage = 2,
	Passive = "Passive_FriendlyFire_A"
}

Passive_FriendlyFire_B = Passive_FriendlyFire:new{
	Damage = 2,
	Passive = "Passive_FriendlyFire_B"
}

Passive_FriendlyFire_AB = Passive_FriendlyFire:new{
	Damage = 3,
	Passive = "Passive_FriendlyFire_AB"
}

--------------------

Passive_FastDecay = PassiveSkill:new{
	PowerCost = 0,
	Icon = "weapons/passives/passive_fastdecay.png",
	Upgrades = 0,
	Passive = "Passive_FastDecay",
	TipImage = {
		Unit = Point(2,2),
		CustomPawn = "Scorpion1",
	}
}

function Passive_FastDecay:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(Point(2,2),5)
	damage.bHide = true
	ret:AddDelay(1)
	ret:AddDamage(damage)
	return ret
end

---------------------------

Passive_ForceAmp = PassiveSkill:new{
	PowerCost = 1,
	Icon = "weapons/passives/passive_forceamp.png",
	Upgrades = 0,
	Passive = "Passive_ForceAmp",
	TipImage = {
		Unit = Point(2,2),
		CustomPawn = "Scorpion1",
		Enemy = Point(2,1),
		Mountain = Point(2,3),
		Friendly2 = Point(3,2),
		Spawn = Point(3,2),
	}
}

function Passive_ForceAmp:GetSkillEffect(p1,p2)
	return Science_Repulse:GetSkillEffect(Point(2,1),Point(2,2))
end

----------------------------

Passive_Ammo = PassiveSkill:new{
	PowerCost = 1,
	Icon = "weapons/passives/passive_ammo.png",
	Upgrades = 0,
	Passive = "Passive_Ammo",
	TipImage = {
		Unit = Point(2,2),
	}
}

----------------------------

Passive_CritDefense = PassiveSkill:new{
	PowerCost = 1,
	Icon = "weapons/passives/passive_critdefense.png",
	Upgrades = 0,
	Passive = "Passive_CritDefense",
	TipImage = {
		Unit = Point(2,2),
		Building1 = Point(2,1),
		Building2 = Point(1,1),
		Building3 = Point(3,3),
		CustomPawn = "Scorpion1",
	}
}

function Passive_CritDefense:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	ret:AddMelee(Point(2,2),SpaceDamage(Point(2,1),1))
	local shield = SpaceDamage(Point(2,1),0)
	shield.bHide = true
	shield.iShield = 1
	ret:AddDamage(shield)
	shield.loc = Point(1,1)
	ret:AddDamage(shield)
	shield.loc = Point(3,3)
	ret:AddDamage(shield)
	return ret
end
