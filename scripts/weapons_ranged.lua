

--[[   weapons within:

	   
---PRIMARY
	Ranged_Artillerymech
	Ranged_Rockthrow
	Ranged_Defensestrike
	Ranged_Rocket
	Ranged_Ignite
	--
	Ranged_ScatterShot
	Ranged_BackShot

---UTILITY
	Ranged_Ice
	--
	Ranged_SmokeBlast
	
---VOLATILE
	Ranged_Fireball
	Ranged_RainingVolley

---POWER 
	Ranged_Wide
	Ranged_Dual


---UNUSED---
Ranged_Tribomb
Ranged_BurstDefense
Ranged_Artillery
	
]]--



------------------------------------------------------------------------------------------------
----------------------------------- RANGED: PRIMARY --------------------------------------------
------------------------------------------------------------------------------------------------
			
---------------[[[[ Primary  ]]]]----------------------
-------------- ArtiMech - Mortar Shells  ---------------


Ranged_Artillerymech = 	ArtilleryDefault:new{
	Class = "Ranged",
	Icon = "weapons/ranged_artillery.png",
	Rarity = 3,
	UpShot = "effects/shotup_tribomb_missile.png",
	ArtilleryStart = 2,
	ArtillerySize = 8,
	BuildingDamage = true,
	Push = 1,
	DamageOuter = 0,
	DamageCenter = 1,
	PowerCost = 1,
	Damage = 1,---USED FOR TOOLTIPS
	BounceAmount = 1,
	Explosion = "",
	ExplosionCenter = "ExploArt1",
	ExplosionOuter = "",
	Upgrades = 2,
	UpgradeCost = {1,3},
	--UpgradeList = { "+1 Damage", "+1 Damage"  },
	LaunchSound = "/weapons/artillery_volley",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Enemy3 = Point(2,1),
		Target = Point(2,2),
		Mountain = Point(2,3)
	}
}
		
Ranged_Artillerymech_A = Ranged_Artillerymech:new{
	--DamageCenter = 2,
	--Damage = 2,---USED FOR TOOLTIPS
	ExplosionCenter = "ExploArt2",
	BounceAmount = 2.5,
	BuildingDamage = false,
	TipImage = {
		Unit = Point(2,4),
		Building = Point(2,2),
		Enemy2 = Point(3,2),
		Enemy3 = Point(2,1),
		Target = Point(2,2),
		Mountain = Point(2,3)
	}
}
	
Ranged_Artillerymech_B = Ranged_Artillerymech:new{
	DamageCenter = 3,
	Damage = 3,---USED FOR TOOLTIPS
	ExplosionCenter = "ExploArt2",
	BounceAmount = 3,
}
			
Ranged_Artillerymech_AB = Ranged_Artillerymech:new{
		DamageCenter = 3,
		Damage = 3,---USED FOR TOOLTIPS
		ExplosionCenter = "ExploArt3",
		BuildingDamage = false,
		BounceAmount = 3,
	}
	
---------------[[[[ Primary  ]]]]----------------------
--------------- RockartMech - RockLaunch ------------------------

Ranged_Rockthrow = ArtilleryDefault:new{-- LineArtillery:new{
	Class = "Ranged",
	Icon = "weapons/ranged_rockthrow.png",
	Sound = "",
	ArtilleryStart = 2,
	ArtillerySize = 8,
	Explosion = "",
	PowerCost = 1,
	BounceAmount = 1,
	Damage = 2,
	LaunchSound = "/weapons/boulder_throw",
	ImpactSound = "/impact/dynamic/rock",
	Upgrades = 1,
	Push = false,
	UpgradeCost = {2},
	--UpgradeList = { "+1 Damage" },
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Enemy2 = Point(3,1),
		Target = Point(2,1)
	}
}
					
function Ranged_Rockthrow:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local damage = SpaceDamage(p2, self.Damage)
	
	if Board:IsValid(p2) and not Board:IsBlocked(p2,PATH_PROJECTILE) then
		damage.sPawn = "RockThrown"
		damage.sAnimation = ""
		damage.iDamage = 0
	else 
		damage.sAnimation = "rock1d" 
	end
	
	ret:AddBounce(p1, 1)
	ret:AddArtillery(damage,"effects/shotdown_rock.png")
	ret:AddBounce(p2, self.BounceAmount)
	
	local damagepush = SpaceDamage(p2 + DIR_VECTORS[(dir+1)%4], 0, (dir+1)%4)
	damagepush.sAnimation = "airpush_"..((dir+1)%4)
	ret:AddDamage(damagepush) 
	damagepush = SpaceDamage(p2 + DIR_VECTORS[(dir-1)%4], 0, (dir-1)%4)
	damagepush.sAnimation = "airpush_"..((dir-1)%4)
	ret:AddDamage(damagepush)
	
	
	return ret
end

Ranged_Rockthrow_A = Ranged_Rockthrow:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 3,
	BounceAmount = 3,
} 



---------------[[[[ Primary  ]]]]----------------------
-------------- DstrikeMech - Support Strike  ---------------

Ranged_Defensestrike = 	{
		Icon = "weapons/ranged_defensestrike.png",
		Rarity = 3,
		Sound = "/general/combat/explode_small",
		UpShot = "effects/shotup_dstrike_missile.png",
		ArtilleryStart = 2,
		ArtillerySize = 8,
		BuildingDamage = true,
		PowerCost = 1,
		Push = 1,
		DamageOuter = 1,
		Damage = 1,---USED FOR TOOLTIPS
		DamageCenter = 0,
		Class = "Ranged",
		BounceAmount = 0,
		BounceOuterAmount = 2, 
		ExplosionCenter = "ExploRepulse2",
		ExplosionOuter = 1,
		OuterAnimation = "explopush1_",
		Upgrades = 2,
		UpgradeCost = {2,2},
		--UpgradeList = { "Buildings Immune", "+1 Damage"   },
		LaunchSound = "/weapons/defense_strike",
		ImpactSound = "/impact/generic/explosion",
		TipImage = {
			Unit = Point(2,4),
			Building = Point(2,2),
			Enemy = Point(2,1),
			Enemy2 = Point(3,2),
			Target = Point(2,2)
		}
}
			
Ranged_Defensestrike = ArtilleryDefault:new(Ranged_Defensestrike)


Ranged_Defensestrike_A = Ranged_Defensestrike:new{
	BuildingDamage = false,
	TipImage = {
		Unit = Point(2,4),
		Building = Point(2,2),
		Building2 = Point(3,2),
		Enemy3 = Point(2,1),
		Target = Point(2,2)
	}
		
	}

Ranged_Defensestrike_B = Ranged_Defensestrike:new{
		DamageOuter = 2,
		Damage = 2,---USED FOR TOOLTIPS
		BounceOuterAmount = 3,
		OuterAnimation = "explopush2_",
	}
			
Ranged_Defensestrike_AB = Ranged_Defensestrike:new{
		DamageOuter = 2,
		Damage = 2,---USED FOR TOOLTIPS
		BounceOuterAmount = 3,
		BuildingDamage = false,
		OuterAnimation = "explopush2_"
	}
			
			
			

---------------[[[[ Primary  ]]]]----------------------
---------- RocketMech - Rocket Launcher ---------------------


Ranged_Rocket = LineArtillery:new{
	Class = "Ranged",
	Damage = 2,
	PowerCost = 1,
	LaunchSound = "/weapons/rocket_launcher",
	ImpactSound = "/impact/generic/explosion_large",
	Icon = "weapons/ranged_rocket.png",
	UpShot = "effects/shotup_guided_missile.png",
	Explosion = "",
	BounceAmount = 2,
	Smoke = 0,
	Upgrades = 2,
	--UpgradeList = { "+1 Damage",  "+1 Damage"  },
	UpgradeCost = { 2,2 },
	TipImage = StandardTips.Ranged
}

function Ranged_Rocket:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	--local target = GetProjectileEnd(p1,p2)  
	
	ret:AddBounce(p1, 1)
	local smoke = SpaceDamage(p1 - DIR_VECTORS[direction],0)
	smoke.iSmoke = 1
	smoke.sAnimation = "exploout0_"..GetDirection(p1 - p2)
	ret:AddDamage(smoke)
	
	local damage = SpaceDamage(p2, self.Damage)
	damage.iPush = direction
	damage.iSmoke = self.Smoke
	damage.sAnimation = "explopush2_"..direction

	ret:AddArtillery(damage, self.UpShot)
	ret:AddBounce(p2, self.BounceAmount)
	
	return ret
end

Ranged_Rocket_A = Ranged_Rocket:new{
	Damage = 3,
	BounceAmount = 2.5,
}

Ranged_Rocket_B = Ranged_Rocket:new{
	Damage = 3,
	BounceAmount = 2.5,
}

Ranged_Rocket_AB = Ranged_Rocket:new{
	Damage = 4,
	BounceAmount = 3,
}


---------------[[[[ Primary  ]]]]----------------------
---------- IgniteMech - Ignite Shot ---------------------

Ranged_Ignite = LineArtillery:new{
	Class = "Ranged",
	Icon = "weapons/ranged_ignite.png",
	Rarity = 3,
	UpShot = "effects/shotup_ignite_fireball.png",
	BuildingDamage = true,
	PowerCost = 1,
	Damage = 0,
	Backhit = 0,
	BounceAmount = 1,
	Upgrades = 2,
	UpgradeCost = {1,3},
--	UpgradeList = { "Backburn", "+2 Damage"  },
	LaunchSound = "/weapons/fireball",
	ImpactSound = "/props/fire_damage",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		--Fire = Point(2,2),
		Enemy2 = Point(3,1),
		--Enemy3 = Point(2,1),
		Target = Point(2,1),
		Mountain = Point(2,2)
	}
}

function Ranged_Ignite:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p1 - p2)
	
	ret:AddBounce(p1, 1)
	if self.Backhit == 1 then
		local back = SpaceDamage(p1 + DIR_VECTORS[direction], 0)
		back.iFire = 1
		--back.sAnimation = "explopush1_"..direction
		ret:AddDamage(back)
	end
	
	local damage = SpaceDamage(p2,self.Damage)
	damage.sAnimation = "ExploArt2"
	damage.iFire = 1
	ret:AddArtillery(damage, self.UpShot)
	
	for dir = DIR_START, DIR_END do
		damage = SpaceDamage(p2 + DIR_VECTORS[dir], 0)
		damage.iPush = dir
		damage.sAnimation = "airpush_"..dir
		ret:AddDamage(damage)
	end
	ret:AddBounce(p2, self.BounceAmount)
	
	return ret
end

Ranged_Ignite_A = Ranged_Ignite:new{
	Backhit = 1,
}

Ranged_Ignite_B = Ranged_Ignite:new{
	Damage = 2,
	BounceAmount = 2,
}
			
Ranged_Ignite_AB = Ranged_Ignite:new{
	Damage = 2,
	BounceAmount = 2,
	Backhit = 1
}


---------------[[[[ Primary  ]]]]----------------------
------------------ Scatter shot ---------------------

Ranged_ScatterShot = LineArtillery:new{
	Class = "Ranged",
	Icon = "weapons/ranged_scattershot.png",
	Rarity = 1,
	PowerCost = 1,
	UpShot = "effects/shotup_smallbullet_missile.png",
	Explosion = "",
	ExploArt = "explopush1_",
	BounceAmount = 2,
	Upgrades = 1.5,
	UpgradeCost = {1,2},
	--UpgradeList = { "+2 Size", "+1 Damage"  },
	LaunchSound = "/weapons/artillery_volley",
	ImpactSound = "/impact/generic/explosion",
	TipImage = StandardTips.RangedAoe,
	Damage = 1,
	BuildingDamage = true,
	Sides = false,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2, 1)
	}
}

function Ranged_ScatterShot:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	--local points = { p2,p2 + DIR_VECTORS[(dir+1)%4], p2 + DIR_VECTORS[(dir-1)%4] }
	
	ret:AddBounce(p1, 1)
	local damage = SpaceDamage(p2,self.Damage,dir)
	damage.sAnimation = self.ExploArt..dir
	
	if self.Sides then 
		ret:AddArtillery(damage,self.UpShot,NO_DELAY)  -- this is for saying no delay due to the bounce
		
		damage.loc = p2 + DIR_VECTORS[(dir+1)%4]
		damage.bHidePath = i ~= 1
		ret:AddArtillery(damage,self.UpShot,NO_DELAY)
		damage.loc = p2 + DIR_VECTORS[(dir-1)%4]
		damage.bHidePath = i ~= 1
		ret:AddArtillery(damage,self.UpShot)
		
		ret:AddBounce(p2, self.BounceAmount)
		ret:AddBounce(p2 + DIR_VECTORS[(dir+1)%4], self.BounceAmount)
		ret:AddBounce(p2 + DIR_VECTORS[(dir-1)%4], self.BounceAmount)
	else
		ret:AddArtillery(damage,self.UpShot)  -- this is for saying no delay due to the bounce
		ret:AddBounce(p2, self.BounceAmount)
		
	end
	
	
	--[[for i,v in ipairs(points) do
		if self.BuildingDamage or not Board:IsBuilding(v) then
			damage.loc = v
			damage.bHidePath = i ~= 1
			ret:AddArtillery(damage,self.UpShot,NO_DELAY)
		end
	end]]
	
	return ret
end

Ranged_ScatterShot_A = Ranged_ScatterShot:new{
	Sides = true,
	LaunchSound = "/weapons/scatter_shot",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(3,1),
		Target = Point(2, 1)
	}
}

Ranged_ScatterShot_B = Ranged_ScatterShot:new{
	Damage = 2,
	ExploArt = "explopush2_",
	BounceAmount = 3,
}

Ranged_ScatterShot_AB = Ranged_ScatterShot:new{
	Damage = 2,
	ExploArt = "explopush2_",
	BounceAmount = 3,
	Sides = true,
	LaunchSound = "/weapons/scatter_shot",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(3,1),
		Target = Point(2, 1)
	}
}


---------------[[[[ Primary  ]]]]----------------------
----------------------- BACK SHOT----------------------

Ranged_BackShot = LineArtillery:new{
	Class = "Ranged",
	Icon = "weapons/ranged_backshot.png",
	Rarity = 1,
	PowerCost = 1,
	UpShot1 = "effects/shotup_backshot2.png",
	UpShot2 = "effects/shotup_backshot1.png",
	Explosion = "",
	ExploArt = "explopush1_",
	Damage = 1,
	BuildingDamage = true,
	BounceAmount = 2,
	Upgrades = 2,
	UpgradeCost = {1,2},
	--UpgradeList = { "+1 Damage", "+1 Damage"  },
	LaunchSound = "/weapons/back_shot",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,4),
		Enemy1 = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,2),
	}
}


function Ranged_BackShot:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	ret:AddBounce(p1, 1)
	
	local p3 = p2 + DIR_VECTORS[dir]
	
	local p2dam = self.Damage--(Board:IsBuilding(p2) and not self.BuildingDamage) and 0 or self.Damage
	local p3dam = self.Damage--(Board:IsBuilding(p3) and not self.BuildingDamage) and 0 or self.Damage
	
	local damage = SpaceDamage(p2,p2dam,(dir+2)%4)
	damage.sAnimation = self.ExploArt..(dir+2)%4
	ret:AddArtillery(damage,self.UpShot1,NO_DELAY)
	damage = SpaceDamage(p3,p3dam,dir)
	damage.bHidePath = true
	damage.sAnimation = self.ExploArt..dir
	ret:AddArtillery(damage,self.UpShot2)
	
	ret:AddBounce(p2, self.BounceAmount)
	ret:AddBounce(p3, self.BounceAmount)
	
	return ret
end

Ranged_BackShot_A = Ranged_BackShot:new{
	Damage = 2,
	ExploArt = "explopush2_",
}

Ranged_BackShot_B = Ranged_BackShot:new{
	Damage = 2,
	ExploArt = "explopush2_",
}

Ranged_BackShot_AB = Ranged_BackShot:new{
	Damage = 3,
	BounceAmount = 3,
	ExploArt = "explopush2_",
}
			






------------------------------------------------------------------------------------------------
----------------------------------- RANGED: UTILITY --------------------------------------------
------------------------------------------------------------------------------------------------

---------------[[[[ Utility  ]]]]----------------------
--------------- IceMech - Ranged Ice ------------------

Ranged_Ice = ArtilleryDefault:new{-- LineArtillery:new{
	Class = "Ranged",
	Icon = "weapons/ranged_ice.png",
	Sound = "",
	ArtilleryStart = 2,
	ArtillerySize = 8,
	Explosion = "ExplIce1",
	PowerCost = 2,
	Damage = 0,
	SelfFreeze = 1,
	LaunchSound = "/weapons/ice_throw",
	ImpactSound = "/impact/generic/ice",
	Push = false,
	Upgrades = 0,
	--UpgradeCost = {2},
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1)
	}
}
					
function Ranged_Ice:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	ret:AddBounce(p1, 1)
	
	if self.SelfFreeze == 1 then
		damage = SpaceDamage(p1, 0)
		damage.iFrozen = EFFECT_CREATE
		ret:AddDamage(damage)
	end
	--local target = GetProjectileEnd(p1,p2)  
	local damage = SpaceDamage(p2, self.Damage)
	damage.iFrozen = EFFECT_CREATE
	ret:AddArtillery(damage,"effects/shotup_ice.png")
	
	ret:AddBounce(p2, 2)
	
	--[[
	if self.Push then
		ret:AddDamage(SpaceDamage(target + DIR_VECTORS[direction],0,direction))
	end]]
	
	return ret
end

Ranged_Ice_A = Ranged_Ice:new{
	SelfFreeze = 0
	--[[
	UpgradeDescription = "Push the tile behind the target",
	Push = true,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,2)
	}]]
}



---------------[[[[ Utility  ]]]]----------------------
------------------ Smoke Blast ------------------------

Ranged_SmokeBlast = LineArtillery:new{
	Class = "Ranged",
	Icon = "weapons/ranged_smokeblast.png",
	UpShot = "effects/shotup_smokeblast_missile.png",
	Explosion = "",
	BuildingDamage = true,
	PowerCost = 1,
	Damage = 0,
	LaunchSound = "/weapons/artillery_volley",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Enemy2 = Point(2,3),
		Enemy3 = Point(2,1),
		Target = Point(2,2),
	}
}

function Ranged_SmokeBlast:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	ret:AddBounce(p1, 1)
	
	local damage = SpaceDamage(p2,self.Damage)
	damage.sAnimation = ""
	damage.iSmoke = 1
	ret:AddArtillery(damage, self.UpShot)
	
	damage = SpaceDamage(p2 + DIR_VECTORS[dir], 0, dir)
	damage.sAnimation = "airpush_"..(dir)
	ret:AddDamage(damage)
	damage = SpaceDamage(p2 + DIR_VECTORS[(dir-2)%4], 0, (dir-2)%4)
	damage.sAnimation = "airpush_"..((dir-2)%4)
	ret:AddDamage(damage)
	
	ret:AddBounce(p2, 1)

	return ret
end



------------------------------------------------------------------------------------------------
----------------------------------- RANGED: VOLATILE --------------------------------------------
------------------------------------------------------------------------------------------------

---------------[[[[ Volatile  ]]]]----------------------
------------------ Fireball ----------------------------

Ranged_Fireball = 	{
	Class = "Ranged",
	Icon = "weapons/ranged_fireball.png",
	Rarity = 1,
	Explosion = "",
	Damage = 0,
	SelfDamage = 1,
	Push = 0,--TOOLTIP INFO
	Cost = "med",
	PowerCost = 1,
	Upgrades = 1,
	UpgradeCost = { 2, },
	LaunchSound = "/weapons/fireball",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(3,1),
		Target = Point(2, 1)
	}
}		
Ranged_Fireball = ArtilleryDefault:new(Ranged_Fireball)

function Ranged_Fireball:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	local backdir = GetDirection(p1 - p2)
	
	ret:AddBounce(p1, 1)
	
	local damage = (SpaceDamage( p1 , self.SelfDamage))
	damage.sAnimation = "ExploAir1"
	if self.SelfDamage ~= 0 then ret:AddDamage(damage) end
	
	damage = SpaceDamage(p2,self.Damage)
	damage.iFire = 1
	damage.sAnimation = "explo_fire1"
	
	
	ret:AddArtillery(damage,"effects/shotup_fireball.png")
	ret:AddBounce(p2, 2)
	
	for i = DIR_START, DIR_END do
		damage.loc = p2 + DIR_VECTORS[i]
		
		if not self.BuildingDamage and Board:IsBuilding(p2 + DIR_VECTORS[i]) then
			damage.iFire = 0
		end
		damage.sAnimation = "exploout2_"..i
		ret:AddDamage(damage)
		ret:AddBounce(p2 + DIR_VECTORS[i], 2)
	end
	
	return ret
end		

Ranged_Fireball_A = Ranged_Fireball:new{
	SelfDamage = 0,
}
---------------[[[[ Volatile  ]]]]----------------------
------------------ Raining Volley ----------------------------

Ranged_RainingVolley = LineArtillery:new{
	Class = "Ranged",
	Icon = "weapons/ranged_rainingvolley.png",
	Rarity = 3,
	UpShot = "effects/shotup_ignite_fireball.png",
	BuildingDamage = true,
	PowerCost = 1,
	Damage = 2,
	LineDamage = 1,
	SelfDamage = 1,
	Upgrades = 2,
	Explosion = "",
	UpgradeCost = {2,2},
	--UpgradeList = { "Buildings Immune", "+1 Damage Each"  },
	LaunchSound = "/weapons/raining_volley",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
	--	Fire = Point(2,2),
		Enemy2 = Point(2,0),
		Enemy3 = Point(2,1),
		Target = Point(2,0),
		Building = Point(2,3)
	}
}

function Ranged_RainingVolley:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	ret:AddBounce(p1, 1)
	
	local damage = SpaceDamage(p1 , self.SelfDamage)
	damage.sAnimation = "ExploAir1"
	ret:AddDamage(damage)
	
	damage = SpaceDamage(p2,self.Damage)
	damage.sAnimation = "ExploArt2"
	
	if not self.BuildingDamage and Board:IsBuilding(p2) then  
		damage.iDamage = DAMAGE_ZERO
	end
	ret:AddArtillery(damage, self.UpShot, NO_DELAY)
	
	local target = p1 + DIR_VECTORS[dir]
	while target ~= p2 do 
		ret:AddBounce(target, 1)
		ret:AddDelay(0.1)
		damage = SpaceDamage(target,self.LineDamage)
		damage.sAnimation = "ExploRaining1"
		damage.sSound = "/weapons/raining_volley_tile"
		if self.BuildingDamage or not Board:IsBuilding(target)then
			ret:AddDamage(damage)
		end
		target = target + DIR_VECTORS[dir]
	end
	
	ret:AddBounce(p2, 2)
	return ret
end

Ranged_RainingVolley_A = Ranged_RainingVolley:new{
	BuildingDamage = false,
}

Ranged_RainingVolley_B = Ranged_RainingVolley:new{
	Damage = 3,
	LineDamage = 2,
	SelfDamage = 2,
}
			
Ranged_RainingVolley_AB = Ranged_RainingVolley:new{
	Damage = 3,
	LineDamage = 2,
	SelfDamage = 2,
	BuildingDamage = false
}

------------------------------------------------------------------------------------------------
----------------------------------- RANGED: POWER --------------------------------------------
------------------------------------------------------------------------------------------------


---------------[[[[ Volatile  ]]]]----------------------
------------------ Overpower ----------------------------

Ranged_Wide = 	ArtilleryDefault:new{
	Class = "Ranged",
	Icon = "weapons/ranged_wide.png",
	Rarity = 1,
	Explosion = "ExploArt2",
	Damage = 2,
	SelfDamage = 0,
	Push = 0,--TOOLTIP INFO
	BuildingDamage = true,
	Cost = "med",
	BounceAmount = 2,
	PowerCost = 1,
	Limited = 1,
	Upgrades = 2,
	UpgradeCost = {1,2},
	--UpgradeList = { "+1 Use", "+1 Damage" },
	LaunchSound = "/weapons/wide_shot",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(3,1),
		Target = Point(2, 1)
	}
}		

function Ranged_Wide:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	local backdir = GetDirection(p1 - p2)
	
	ret:AddBounce(p1, 1)
	local damage = SpaceDamage(p2,self.Damage)
	if not self.BuildingDamage and Board:IsBuilding(p2) then	
		damage.iDamage = 0
	end
	ret:AddArtillery(damage,"effects/shot_artimech.png", NO_DELAY)
	
	for i = DIR_START, DIR_END do
		damage = SpaceDamage(p2 + DIR_VECTORS[i],  self.Damage)
		if not self.BuildingDamage and Board:IsBuilding(p2 + DIR_VECTORS[i]) then		-- Target Buildings - Board:IsBuilding(x,y) and Board:IsBuilding(p)
			damage.iDamage = 0
		end
		damage.bHidePath = true
		ret:AddArtillery(damage,"effects/shot_artimech.png", NO_DELAY)--AddDamage(damage)
	end
	
	
	ret:AddDelay(0.7)
	ret:AddBounce(p2, self.BounceAmount)
	for i = DIR_START, DIR_END do  -- NOT IDEAL....
		ret:AddBounce(p2 + DIR_VECTORS[i], self.BounceAmount)
	end
	return ret
end		

Ranged_Wide_A = Ranged_Wide:new{
		Limited = 2,
}

Ranged_Wide_B = Ranged_Wide:new{
		Damage = 3,
		BounceAmount = 3,
}

Ranged_Wide_AB = Ranged_Wide:new{
		Limited = 2,
		Damage = 3,
		BounceAmount = 3,
}

---------------[[[[ Volatile  ]]]]----------------------
------------------ Overpower ----------------------------

Ranged_Dual = ArtilleryDefault:new{
	Class = "Ranged",
	Icon = "weapons/ranged_dual.png",
	Rarity = 1,
	Explosion = "",
	ExploArt = "explopush1_",
	Damage = 3,
	BounceAmount = 2,
	PowerCost = 2,
	Upgrades = 2,
	Limited = 1,
	UpgradeCost = {1,1},
	--UpgradeList = {  "+1 Use","+1 Damage" },
	LaunchSound = "/weapons/dual_missiles",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(1,2),
		Enemy2 = Point(3,2),
		Target = Point(2,2)
	}
}		

function Ranged_Dual:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	local damage = SpaceDamage(p2 + DIR_VECTORS[(direction+1)%4], self.Damage, direction)
	local damage2 = SpaceDamage(p2 + DIR_VECTORS[(direction-1)%4], self.Damage, direction)
	
	
	ret:AddBounce(p1, 1)
	--this is not the most elegant script ever.
	
	---dummy artillery shots for the visual
	---it has actual art when fired, but hidden when aiming
	local dummy = SpaceDamage(damage.loc)
	dummy.bHide = true
	dummy.sAnimation = self.ExploArt..direction
	ret:AddArtillery(dummy,"effects/shotup_guided_missile.png",NO_DELAY)
	dummy.loc = damage2.loc
	ret:AddArtillery(dummy,"effects/shotup_guided_missile.png",NO_DELAY)
	
	--invisible artillery shot for actual damage and projectile pathing
	--it has no art when fired, but visuals when aiming
	ret:AddArtillery(SpaceDamage(p2),"")
	ret:AddDamage(damage)
	ret:AddDamage(damage2)
	
	ret:AddBounce(p2 + DIR_VECTORS[(direction+1)%4], self.BounceAmount)
	ret:AddBounce(p2 + DIR_VECTORS[(direction-1)%4], self.BounceAmount)
	return ret
end		

Ranged_Dual_A = Ranged_Dual:new{
		Limited = 2,
	--	UpgradeDescription = "Increases uses per battle by 1."
}

Ranged_Dual_B = Ranged_Dual:new{
		Damage = 4,
		ExploArt = "explopush2_",
		BounceAmount = 3,
		--UpgradeDescription = "Increases damage by 1."
}

Ranged_Dual_AB = Ranged_Dual:new{
		Damage = 4,
		Limited = 2,
		ExploArt = "explopush2_",
		BounceAmount = 3,
}














		--[[
----&&&&&&&&&&&&&&&&&&&&&&&&&&&&---
------- UNUSED / TO DO --------
----&&&&&&&&&&&&&&&&&&&&&&&&&&&&---



--------------- Primary  ----------------------
------------------ Marksman's Ca----------------------------

Ranged_Marksman = LineArtillery:new{
	Class = "Ranged",
	Icon = "weapons/skill_default.png",
	UpShot = "effects/shotup_ignite_fireball.png",
	BuildingDamage = true,
	PowerCost = 2,
	Damage = 0,
	Push = 1,
	MaxDamage = 3,
	Upgrades = 2,
	Explosion = "",
	UpgradeCost = {1,1},
	LaunchSound = "/weapons/raining_volley",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
	--	Fire = Point(2,2),
		Enemy2 = Point(2,0),
		Enemy3 = Point(2,1),
		Target = Point(2,0),
		Building = Point(2,3)
	}
}

function Ranged_Marksman:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	
	local counter = p1 + DIR_VECTORS[dir]
	local dist = -1
	
	while counter ~= p2  and  dist ~= 8 do 
		dist = dist + 1
		counter = counter + DIR_VECTORS[dir]
	end
	local damage = SpaceDamage(p2,math.min(self.MaxDamage, dist))
	damage.sAnimation = "ExploArt2"
	ret:AddArtillery(damage, self.UpShot)
	
	
	for dir = 0, 3 do
		damage = SpaceDamage(p2 + DIR_VECTORS[dir],  0, dir)
		damage.sAnimation = "airpush_"..dir
		ret:AddDamage(damage)
	end

	
	return ret
end

Ranged_Marksman_A = Ranged_Marksman:new{
	MaxDamage = 4,
}

Ranged_Marksman_B = Ranged_Marksman:new{
	MaxDamage = 4,
}
			
Ranged_Marksman_AB = Ranged_Marksman:new{
	MaxDamage = 5,
}

----------------------------


Ranged_BurstDefense = Skill:new{ 
	Name = "Defensive Burst", 
	Class = "Ranged",
	Description = "Defend yourself in emergencies by pushing adjacent enemies away.",
	Icon = "weapons/ranged_burstdefense.png",
	Damage = 0,
	Selfshield = false,
	Cost = "low",
	PowerCost = 1,
	Upgrades = 2,
	UpgradeCost = {2,2},
	UpgradeList = { "Shield Self", "Enemy Damage +1" },
	Range = 1, --TOOLTIP info
	Push = 1, --TOOLTIP info
	LaunchSound = "/weapons/defensive_burst"
}

function Ranged_BurstDefense:GetTargetArea(point)
	local ret = PointList()
	
	ret:push_back(point)
	for i = DIR_START, DIR_END do
		ret:push_back(DIR_VECTORS[i] + point)
	end
	
	return ret
end

function Ranged_BurstDefense:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	
	ret:AddDamage(SoundEffect(p2,self.LaunchSound))
	for i = DIR_START, DIR_END do
		local damage = SpaceDamage(DIR_VECTORS[i] + p1, self.Damage, i)
		if  Board:IsBuilding(DIR_VECTORS[i] + p1) then		
			damage.iDamage = 0
		end
		ret:AddDamage(damage)
	end
	
	if self.Selfshield then
		local sdamage = SpaceDamage(p1,0)
		sdamage.iShield = 1
		ret:AddDamage(sdamage)
	end
	
	
	return ret
end


Ranged_BurstDefense_A = Ranged_BurstDefense:new{
			Selfshield = true,
			UpgradeDescription = "Shields the unit when activated."
}
		
Ranged_BurstDefense_B = Ranged_BurstDefense:new{
			Damage = 1,
			UpgradeDescription = "Enemy units will take 1 damage when hit."
}

Ranged_BurstDefense_AB = Ranged_BurstDefense:new{
			Selfshield = true,
			Damage = 1
}
		
		
		
		
		
		
		
		
		
		
------------------------------------------------------------------------------------------------
----------------------------------- UNUSED  --------------------------------------------
------------------------------------------------------------------------------------------------


Ranged_Airblast = 	{
	Name = "Airblast", 
	Class = "Ranged",
	Description = "Powerful attack that damages a large area.", 
	Icon = "weapons/skill_default.png",
	Explosion = "ExploArt1",
	Damage = 0,
	PowerCost = 0,
	Upgrades = 0,
	LaunchSound = "/weapons/barrage",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(2,4),
		Target = Point(2,1)
	}
}		
Ranged_Airblast = ArtilleryDefault:new(Ranged_Airblast)

function Ranged_Airblast:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local backdir = GetDirection(p1 - p2)
	
	local damage = SpaceDamage(p2,0, dir)
	ret:AddArtillery(damage,"effects/shot_artimech.png")
	
	ret:AddDamage(SpaceDamage(p1 + DIR_VECTORS[backdir], 0, backdir))
	
	return ret
end		

--------


Ranged_Tribomb = 	{
	Name = "Tri-bombard", 
	Class = "Ranged",
	Description = "Artillery attack that hits and pushes 3 tiles in a line with gaps in between.", 
	Icon = "weapons/ranged_tribomb.png",
	Rarity = 1,
	Explosion = "",
	Damage = 2,
	BuildingDamage = false,
	SelfDamage = 0,
	Cost = "med",
	PowerCost = 1,
	Upgrades = 2,
	Limited = 1,
	UpgradeCost = {1,2},
	UpgradeList = {  "+1 Use", "+2 Damage" },
	LaunchSound = "/weapons/dual_shot",
	ImpactSound = "/impact/generic/explosion"
}		

		
	
Ranged_Tribomb = ArtilleryDefault:new(Ranged_Tribomb)

function Ranged_Tribomb:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	--this is not the most elegant script ever.
	
	local damage = SpaceDamage(p2, self.Damage, direction)
	local damage2 = SpaceDamage(p2 + DIR_VECTORS[direction]*2, self.Damage, direction)
	local damage3 = SpaceDamage(p2 + DIR_VECTORS[direction]*4, self.Damage, direction)
	
	
	local dummy = SpaceDamage(damage.loc)
	dummy.bHide = true
	dummy.sAnimation = "explopush1_"..direction
	
	if not self.BuildingDamage and Board:IsBuilding(p2) then	
		damage.iDamage = 0
	else
		ret:AddArtillery(dummy,"effects/shotup_tribomb_missile.png",NO_DELAY)
	end
	
	if not self.BuildingDamage and Board:IsBuilding(p2 + DIR_VECTORS[direction]*2) then	
		damage2.iDamage = 0
	else	
		dummy.loc = damage2.loc
		ret:AddArtillery(dummy,"effects/shotup_tribomb_missile.png",NO_DELAY) 
	end
	if not self.BuildingDamage and Board:IsBuilding(p2 + DIR_VECTORS[direction]*4) then	
		damage3.iDamage = 0
	else
		dummy.loc = damage3.loc
		ret:AddArtillery(dummy,"effects/shotup_tribomb_missile.png",NO_DELAY) 
	end
	
	ret:AddDamage(SpaceDamage( p1 , self.SelfDamage))
	
	ret:AddArtillery(SpaceDamage(p2),"")
	ret:AddDamage(damage)
	ret:AddDamage(damage2)
	ret:AddDamage(damage3)
	
	---dummy artillery shots for the visual
	---it has actual art when fired, but hidden when aiming
	
	
	
	return ret
end		

Ranged_Tribomb_A = Ranged_Tribomb:new{
		Limited = 2,
		UpgradeDescription = "Increases uses per battle to 2."
}

Ranged_Tribomb_B = Ranged_Tribomb:new{
		Damage = 5,
		UpgradeDescription = "Increases damage by 2."
}

Ranged_Tribomb_AB = Ranged_Tribomb:new{
		Damage = 5,
		Limited = 2
}

-----------

Flying_Guided = 	{
			Name = "Guided Missile", 
			Class = "Flying",
			Description = "Artillery attack that hits and pushes a single target.", 
			Icon = "weapons/flying_guided.png",
			Rarity = 0,
			Explosion = "ExploArt1",
			Damage = 1,
			Cost = "low",
			PowerCost = 1,
			Upgrades = 2,
			UpgradeCost = {1,1},
			UpgradeList = { "+1 Damage", "Stun Enemy" },
			LaunchSound = "/weapons/guided_missile",
			ImpactSound = "/impact/generic/explosion"
}		

Flying_Guided = ArtilleryDefault:new(Flying_Guided)

function Flying_Guided:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	local damage = SpaceDamage(p2,self.Damage, direction)
	
	ret:AddArtillery(damage,"effects/shotup_guided_missile.png")
	
	return ret
end		

Flying_Guided_A = Flying_Guided:new{
		Damage = 2,
		UpgradeDescription = "Increases damage by 1."
}

Flying_Guided_B = Flying_Guided:new{
		UpgradeDescription = "Will stun the target if it is an enemy."
}

Flying_Guided_AB = Flying_Guided:new{
		Damage = 2,
}


-----------------------

Ranged_Artillery = ArtilleryDefault:new{
	Name = "Basic Mortar",
	Description = "Launch a weak artillery, damaging a single tile and pushing adjacent tiles",
	Icon = "weapons/ranged_artillery.png",
	Rarity = 1,
	PowerCost = 2,
	DamageCenter = 3,
	Damage = 3,
	Limited = 2,
	Upgrades = 2,
	UpgradeCost = {3,1},
	UpgradeList = { "+2 Damage",  "Buildings Immune"  },
	LaunchSound = "/weapons/artillery_shot",
	ImpactSound = "/impact/generic/explosion"
}
Ranged_Artillery_A = Ranged_Artillery:new{
		DamageCenter = 4,
		Damage = 4,---USED FOR TOOLTIPS
		ExplosionCenter = "ExploArt2",
		UpgradeDescription = "+1 damage to target"
	}
Ranged_Artillery_B = Ranged_Artillery:new{
		BuildingDamage = false,
		UpgradeDescription = "This attack will no longer damage buildings"
	}
Ranged_Artillery_AB = Ranged_Artillery:new{
		DamageCenter = 4,
		Damage = 4,---USED FOR TOOLTIPS
		ExplosionCenter = "ExploArt2",
		BuildingDamage = false
	}
	
	
------------------------------------------------------
-------------- Acidshot MECH PRIMARY  ---------------


Ranged_AcidShot = LineArtillery:new{
	Name = "Acid Artillery",
	Class = "Ranged",
	Description = "???",
	Rarity = 3,
	UpShot = "effects/shotup_ignite_fireball.png",
	Range = RANGE_ARTILLERY,	
	Push = 1,
	Acid = 0,
	DamageOuter = 0,
	DamageCenter = 0,
	Damage = 1,---USED FOR TOOLTIPS
	Explosion = "",
	ExplosionCenter = "ExploArt1",
	ExplosionOuter = "",
	Upgrades = 2,
	UpgradeCost = {1,3},
	UpgradeList = { "Acid", "+2 Damage"  },
	TipImage = StandardTips.RangedAoe
}
			
function Ranged_AcidShot:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	
	local damage = SpaceDamage(p2,self.DamageCenter)
	damage.sAnimation = self.ExplosionCenter
	if self.Acid then
		damage.iAcid = self.Acid
	end
	ret:AddArtillery(damage, self.UpShot)
	
	for dir = 0, 3 do
		damage = SpaceDamage(p2 + DIR_VECTORS[dir],  self.DamageOuter)
		
		if self.Push == 1 then
			damage.iPush = dir
		end
		
		if self.ExplosionOuter == "" then
			damage.sAnimation = "airpush_"..dir
		elseif self.ExplosionOuter == 1 then
			damage.sAnimation = "explopush1_"..dir
		end
		
		ret:AddDamage(damage)
	end

	return ret
end		


Ranged_AcidShot_A = Ranged_AcidShot:new{
	Acid = 1,
	UpgradeDescription = "Adds acid to the center target.",
}

Ranged_AcidShot_B = Ranged_AcidShot:new{
	DamageCenter = 2,
	UpgradeDescription = "Increases damage by 2."
}
			
Ranged_AcidShot_AB = Ranged_AcidShot:new{
	DamageCenter = 2,
	Acid = 1
}
--]]
