
--[[  weapons within:
---Primary

---UTILITY
	Science_Pullmech
	Science_Gravwell
	Science_Swap
	Science_Repulse
	Science_AcidShot
	--
	Science_SmokeDefense
	
--- VOLATILE
	
---POWER 
	Science_Shield
	Science_FireBeam
	Science_FreezeBeam
	Science_LocalShield
	Science_PushBeam
	
]]--


------------------------------------------------------------------------------------------------
----------------------------------- SCIENCE: PRIMARY --------------------------------------------
------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------
----------------------------------- SCIENCE: UTILITY --------------------------------------------
------------------------------------------------------------------------------------------------

---------------[[[[ Utility  ]]]]----------------------
-------------- ScienceMech - Pull  ---------------

Science_Pullmech = 	{
	Class = "Science",
	Icon = "weapons/science_pullmech.png",
	Rarity = 3,
	Sound = "",
	Damage = 0,
	Range = RANGE_PROJECTILE,
	PathSize = INT_MAX,
	Explosion = "",
	Acid = 0,
	Shield = 0,
	Push = 1,--TOOLTIP
	PowerCost = 0,
	LaunchSound = "/weapons/enhanced_tractor",
	ImpactSound = "/impact/generic/tractor_beam",
	Upgrades = 0,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,0),
		Target = Point(2,0)
	}
	--UpgradeCost = {1,2},
	--UpgradeList = { "Shield Ally",  "Acid Enemy"  }
}
		
Science_Pullmech = Skill:new(Science_Pullmech)
			
function Science_Pullmech:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
			
	local target = GetProjectileEnd(p1,p2)  
	
	
	local damage = SpaceDamage(target, self.Damage, GetDirection(p1 - p2))
	if Board:IsPawnTeam(target, TEAM_PLAYER) then
		damage.iShield = self.Shield
	elseif Board:IsPawnTeam(target, TEAM_ENEMY) then
		damage.iAcid = self.Acid
	end
	--ret.path = Board:GetSimplePath(p1, target)
	ret:AddProjectile(damage,"effects/shot_pull", NO_DELAY)
		
	local temp = p1 
	while temp ~= target  do 
		ret:AddDelay(0.05)
		ret:AddBounce(temp,-1)
		temp = temp + DIR_VECTORS[direction]
	end

	return ret
end


---------------[[[[ Utility  ]]]]----------------------
--------------GravMech - Grav Well ----------------

Science_Gravwell = LineArtillery:new{
	Class = "Science",
	Icon = "weapons/science_gravwell.png",
	Sound = "",
	Explosion = "",
	PowerCost = 0,
	Damage = 0,
		ArtilleryStart = 2,
		ArtillerySize = 8,
	LaunchSound = "/weapons/gravwell",
	Upgrades = 0,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,0),
		Target = Point(2,0)
	}
}
					
function Science_Gravwell:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	ret:AddBounce(p1,-2)
	local damage = SpaceDamage(p2, self.Damage, GetDirection(p1 - p2))
	damage.sAnimation = "airpush_"..GetDirection(p1 - p2)
	ret:AddArtillery(damage,"effects/shot_pull_U.png")
	return ret
end


---------------[[[[ Utility  ]]]]----------------------
---------------- PulseMech - Repulse  --------------

Science_Repulse = Skill:new{  
	PathSize = 1,
	Class = "Science",
	Icon = "weapons/science_repulse.png",
	LaunchSound = "/weapons/science_repulse",
	Explosion = "ExploRepulse1",
	Damage = 0,
	PowerCost = 1,
	Upgrades = 2,
	ShieldSelf = false,
	ShieldFriendly = false,
	UpgradeCost = { 1,2 },
	TipImage = StandardTips.Surrounded
}

function Science_Repulse:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	ret:AddBounce(p1,-2)
	for i = DIR_START,DIR_END do
		local curr = p1 + DIR_VECTORS[i]
		local spaceDamage = SpaceDamage(curr, 0, i)
		
		if self.ShieldFriendly and (Board:IsBuilding(curr) or Board:GetPawnTeam(curr) == TEAM_PLAYER) then
			spaceDamage.iShield = 1
		end
		
		spaceDamage.sAnimation = "airpush_"..i
		ret:AddDamage(spaceDamage)
		
		ret:AddBounce(curr,-1)
	end
	
	local selfDamage = SpaceDamage(p1,0)
	
	if self.ShieldSelf then
		selfDamage.iShield = 1
	end
		
	selfDamage.sAnimation = "ExploRepulse1"
	ret:AddDamage(selfDamage)
	
	return ret
end	

Science_Repulse_A = Science_Repulse:new{
	ShieldSelf = true,
}

Science_Repulse_B = Science_Repulse:new{
	ShieldFriendly = true,
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,1),
		Enemy = Point(2,3),
		Friendly = Point(3,2),
		Building = Point(2,1)
	}
}

Science_Repulse_AB = Science_Repulse:new{
	ShieldFriendly = true,
	ShieldSelf = true,
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,1),
		Enemy = Point(2,3),
		Friendly = Point(3,2),
		Building = Point(2,1)
	}
}

---------------[[[[ Utility  ]]]]----------------------
---------------- TeleMech - Tele-Swapper  --------------

Science_Swap = Skill:new{
	Class = "Science",
	Icon = "weapons/science_swap.png",
	Rarity = 1,
	Explosion = "",
--	LaunchSound = "/weapons/titan_fist",
	Range = 1,
	Damage = 0,
	PowerCost = 0,
	Upgrades = 2,
--	UpgradeList = { "+1 Range",  "+2 Range"  },
	UpgradeCost = { 1 , 2 },
	TipImage = StandardTips.Melee,
	LaunchSound = "/weapons/swap"
	
}

function Science_Swap:GetTargetArea(point)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		for range = 1, self.Range do
			local curr = point + DIR_VECTORS[dir]*range
			if (Board:IsPawnSpace(curr) and not Board:GetPawn(curr):IsGuarding())
				or not Board:IsBlocked(curr, PATH_FLYER) then
				ret:push_back(curr)
			end
		end
	end
	
	return ret
end

function Science_Swap:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	--local target = GetProjectileEnd(p1,p2)
	local delay = Board:IsPawnSpace(p2) and 0 or FULL_DELAY
	ret:AddTeleport(p1,p2, delay)
	
	if delay ~= FULL_DELAY then
		ret:AddTeleport(p2,p1, FULL_DELAY)
	end
	
	return ret
end	

Science_Swap_A = Science_Swap:new{
	Range = 2,
	TipImage = StandardTips.Ranged,
}

Science_Swap_B = Science_Swap:new{
	Range = 3,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Target = Point(2,1)
	},
}

Science_Swap_AB = Science_Swap:new{
	Range = 4,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,0),
		Target = Point(2,0)
	},
}


---------------[[[[ Primary  ]]]]----------------------
----------------NanoMech - Acid Shot --------------

Science_AcidShot = TankDefault:new {
	Range = RANGE_PROJECTILE,
	Class = "Science",
	Icon = "weapons/mission_tankacid.png",
	Rarity = 1,
	Explosion = "",
	ProjectileArt = "effects/shot_tankacid",
	Damage = 0,
	Push = 1,
	Acid = 1,
	PowerCost = 0,
	Upgrades = 0,
	UpgradeCost = {1,2},
	LaunchSound = "/weapons/acid_shot",
	ImpactSound = "/impact/generic/acid_canister",
	TipImage = StandardTips.Ranged
}

function Science_AcidShot:GetSkillEffect(p1,p2)
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


---------------[[[[ Primary  ]]]]----------------------
----------------- ConfuseRay --------------

Science_Confuse = TankDefault:new {
	Range = RANGE_PROJECTILE,
	Class = "Science",
	Icon = "weapons/science_confuse.png",
	Explosion = "ExploRepulse3",
	Explo = "airpush_",
	ProjectileArt = "effects/shot_confuse",
	Damage = 0,
	Flip = 1,
	PowerCost = 0,
	Upgrades = 0,
	UpgradeCost = {1,2},
	LaunchSound = "",
	ImpactSound = "",
	CustomTipImage = "Science_Confuse_Tip",
	LaunchSound = "/weapons/enhanced_tractor",
	ImpactSound = "/impact/generic/tractor_beam",
}

function Science_Confuse:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local target = GetProjectileEnd(p1,p2,PATH_PROJECTILE)  
	
	local damage = SpaceDamage(target, self.Damage)
	if self.Flip == 1 then
		damage = SpaceDamage(target,self.Damage,DIR_FLIP)
	end
	ret:AddProjectile(damage, self.ProjectileArt, NO_DELAY)
	
	return ret
end

Science_Confuse_Tip = Science_Confuse:new{
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomEnemy = "Firefly2",
		Length = 4
	}
}

function Science_Confuse_Tip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	ret.piOrigin = Point(2,3)
	local damage = SpaceDamage(0)
	damage.bHide = true
	damage.sScript = "Board:GetPawn(Point(2,1)):FireWeapon(Point(2,2),1)"
	ret:AddDamage(damage)
	damage = SpaceDamage(0)
	damage.bHide = true
	damage.fDelay = 1.5
	ret:AddDamage(damage)
	local damage = SpaceDamage(p2,0,DIR_FLIP)
	damage.bHide = true
	damage.sAnimation = "ExploRepulse3"--"airpush_"..GetDirection(p2 - p1)
	ret:AddProjectile(damage,"effects/shot_confuse")
	return ret
end



------------------------------------------------------------------------------------------------
----------------------------------- SCIENCE: VOLATILE --------------------------------------------
------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------
----------------------------------- SCIENCE: POWER --------------------------------------------
------------------------------------------------------------------------------------------------

---------------[[[[ Utility  ]]]]----------------------
---------------- Emergency Smoke  -------------------

Science_SmokeDefense = Skill:new{ 
	Class = "Science",
	Icon = "weapons/science_smokedefense.png",
	Rarity = 1,
	Selfsmoke = true,
	Allysmoke = true,
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = {1,1},
	Limited = 1,
--	UpgradeList = { "Ally Immune", "+1 Use" },
	LaunchSound = "/weapons/defensive_smoke",
	Smoke = 1,--TOOLTIP HELPER,
	TipImage = StandardTips.Surrounded
}

function Science_SmokeDefense:GetTargetArea(point)
	local ret = PointList()
	
	ret:push_back(point)
	for i = DIR_START, DIR_END do
		ret:push_back(DIR_VECTORS[i] + point)
	end
	
	return ret
end

function Science_SmokeDefense:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	
	ret:AddDamage(SoundEffect(p2,self.LaunchSound))
	
	for i = DIR_START, DIR_END do
		local damage = SpaceDamage(DIR_VECTORS[i] + p1, 0)
		damage.iSmoke = 1		
		if not self.Allysmoke and Board:IsPawnTeam(DIR_VECTORS[i] + p1, TEAM_PLAYER) then
			damage.iSmoke = 0
		end
		ret:AddDamage(damage)
	end
	
	if self.Selfsmoke then
		local damage = SpaceDamage(p1,0)
		damage.iSmoke = 1
		ret:AddDamage(damage)
	end
	
	return ret
end

Science_SmokeDefense_A = Science_SmokeDefense:new{
			Allysmoke = false,
			Selfsmoke = false,
}
Science_SmokeDefense_B = Science_SmokeDefense:new{
			Limited = 2,
}

Science_SmokeDefense_AB = Science_SmokeDefense:new{
			Allysmoke = false,
			Selfsmoke = false,
			Limited = 2
}
	

			



---------------[[[[ Power  ]]]]----------------------
-----------ScienceMech -  Science Shield---------------

Science_Shield = LineArtillery:new{  
	Class = "Science",
	Icon = "weapons/science_shield.png",
	Rarity = 1,
	SelfShield = 0,
	Shield = 1, --TOOLTIP HELP,
	Cost = "high",
	PowerCost = 1,
	Upgrades = 2,
	UpgradeCost = {2,2},
	LaunchSound = "/weapons/area_shield",
	--UpgradeList = { "+1 Use",  "Larger Area" },
	Limited = 2,
	WideArea = false,
	Explosion = "",
	TipImage = {
		Unit = Point(2,3),
		Building = Point(2,1),
		Friendly = Point(2,0),
		Target = Point(2,1)
	}
}
		
function Science_Shield:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2-p1)
	local damage = SpaceDamage(p2,0)
	damage.iShield = 1
	--damage.sAnim = ""
	ret:AddArtillery(damage,"effects/shot_pull_U.png", NO_DELAY)
--	ret:AddDamage(damage)
	for i = DIR_START, DIR_END do
		damage.loc = p2 + DIR_VECTORS[i]
		damage.bHidePath = true
		if self.WideArea or i == direction then
			ret:AddArtillery(damage,"effects/shot_pull_U.png", NO_DELAY)--ret:AddDamage(damage)
		end
	end
	
	if self.SelfShield == 1 then
		damage.loc = p1
		ret:AddDamage(damage)
	end
	
	return ret
end	

Science_Shield_A = Science_Shield:new{
		Limited = 3,
}
Science_Shield_B = Science_Shield:new{
		WideArea = true,
}
Science_Shield_AB = Science_Shield:new{
		Limited = 3,
		WideArea = true
}


---------------[[[[ Power  ]]]]----------------------
-------------- Fire Beam ---------------------------
Science_FireBeam = LaserDefault:new{
	Class = "Science",
	Icon = "weapons/science_firebeam.png",
	LaserArt = "effects/laser_fire", --laser_fire
	LaunchSound = "/weapons/fire_beam",
	Explosion = "",
	Sound = "",
	Damage = 0,
	MinDamage = 0,
	PowerCost = 1,
	Fire = 1,
	FriendlyDamage = true,
	Limited = 1,
	Upgrades = 1,
	--UpgradeList = { "+1 Use" },
	UpgradeCost = { 1 },
	--DamageTooltip = TipData("Damage","3 to 1"),
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Friendly = Point(2,1),
		Target = Point(2,2),
		Mountain = Point(2,0)
	}
}
			
Science_FireBeam_A = Science_FireBeam:new{	
		Limited = 2,
}


---------------[[[[ Power  ]]]]----------------------
-----------  Frost Beam ------------------------
Science_FreezeBeam = LaserDefault:new{
	Class = "Science",
	Icon = "weapons/science_freezebeam.png",
	LaserArt = "effects/laser_freeze",
	Explosion = "",
	LaunchSound = "/weapons/freeze_beam",
	Sound = "",
	Damage = 0,
	MinDamage = 0,
	PowerCost = 2,
	Freeze = 1,
	FriendlyDamage = true,
	Limited = 1,
	Upgrades = 1,
	UpgradeList = { "+1 Use" },
	UpgradeCost = { 2 },
	--DamageTooltip = TipData("Damage","3 to 1"),
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Friendly = Point(2,1),
		Target = Point(2,2),
		Mountain = Point(2,0)
	}
}
Science_FreezeBeam_A = Science_FreezeBeam:new{
	Limited = 2,
}



---------------[[[[ Power  ]]]]----------------------
----------- Local Shield ------------------------
Science_LocalShield = Skill:new{  
	PathSize = 1,
	Class = "Science",
	Icon = "weapons/science_localshield.png",
	Explosion = "",
	Damage = 0,
	PowerCost = 1,
	Upgrades = 2,
	IceVersion = 0,
	WideArea = 1,
	Push = 1,--TOOLTIP HELPER,
	Range = 1,--TOOLTIP HELPER
	Limited = 1,
	UpgradeCost = { 1,1 },
	UpgradeList = { "+1 Size",  "+1 Use"  },
	LaunchSound = "/weapons/localized_burst",
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,1),
		Friendly = Point(2,3),
		Friendly2 = Point(3,2),
		Building = Point(2,1)
	}
}
		
function Science_LocalShield:GetTargetArea(point)
	local ret = PointList()
	ret:push_back(point)
	for i = DIR_START, DIR_END do
		ret:push_back(point + DIR_VECTORS[i])
		
		if self.WideArea > 1 then
			ret:push_back(point + DIR_VECTORS[i] + DIR_VECTORS[i])
			ret:push_back(point + DIR_VECTORS[i] + DIR_VECTORS[(i+1)%4])
		end
		if self.WideArea > 2 then
			ret:push_back(point + DIR_VECTORS[i] * 3)
			ret:push_back(point + DIR_VECTORS[i] * 2 + DIR_VECTORS[(i+1)%4])
			ret:push_back(point + DIR_VECTORS[i]  + DIR_VECTORS[(i+1)%4] * 2)
		end
	end
	
	return ret
end

function Science_LocalShield:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local damage = SpaceDamage(p2,0)
	damage.iShield = 1

	if self.IceVersion == 1 then
		damage.iShield = 0
		damage.iFrozen = EFFECT_CREATE
		local storm_spot = p1 + Point(-1*self.WideArea,-1*self.WideArea)
		local storm_size = Point(3,3) + Point(self.WideArea,self.WideArea)
		ret:AddScript("Board:SetWeather(5,"..RAIN_SNOW..","..storm_spot:GetString()..","..storm_size:GetString()..",2)")
	end
	
	for i = DIR_START, DIR_END do
		damage.loc = p1 + DIR_VECTORS[i]
		ret:AddDamage(damage)
		
		if self.WideArea > 1 then
			damage.loc = p1 + DIR_VECTORS[i] + DIR_VECTORS[i]
			ret:AddDamage(damage)
			damage.loc = p1 + DIR_VECTORS[i] + DIR_VECTORS[(i+1)%4]
			ret:AddDamage(damage)
		end
		if self.WideArea > 2 then
			damage.loc = p1 + DIR_VECTORS[i]*3
			ret:AddDamage(damage)
			damage.loc = p1 + DIR_VECTORS[i]*2 + DIR_VECTORS[(i+1)%4]
			ret:AddDamage(damage)
			damage.loc = p1 + DIR_VECTORS[i] + DIR_VECTORS[(i+1)%4]*2
			ret:AddDamage(damage)
		end
	end
	
	damage.loc = p1 --shield self too
	ret:AddDamage(damage)
	
	return ret
	
	
end	

Science_LocalShield_A = Science_LocalShield:new{
		WideArea = 2,
		TipImage = {
			Unit = Point(2,2),
			Target = Point(2,1),
			Friendly = Point(2,3),
			Friendly2 = Point(3,2),
			Friendly2 = Point(4,2),
			Building = Point(2,1),
			Building1 = Point(1,1),
			Enemy = Point(1,2)
		}
}

Science_LocalShield_B = Science_LocalShield:new{
		Limited = 2,
}

Science_LocalShield_AB = Science_LocalShield:new{
		WideArea = 2,
		Limited = 2,
		TipImage = {
			Unit = Point(2,2),
			Target = Point(2,1),
			Friendly = Point(2,3),
			Friendly2 = Point(3,2),
			Friendly2 = Point(4,2),
			Building = Point(2,1),
			Building1 = Point(1,1),
			Enemy = Point(1,2)
		}
}



---------------[[[[ Power  ]]]]----------------------
-------------- Push Beam ---------------------------
Science_PushBeam = Skill:new{
	Class = "Science",
	Icon = "weapons/science_pushbeam.png",
	LaserArt = "effects/laser_push", --laser_fire
	LaunchSound = "",
	Explosion = "",
	Sound = "",
	Damage = 0,
	MinDamage = 0,
	PowerCost = 1,
	Limited = 1,
	Upgrades = 1,
	UpgradeCost = { 1 },
	LaunchSound = "/weapons/push_beam",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Friendly = Point(2,1),
		Target = Point(2,2),
		Mountain = Point(2,0)
	}
}
			
function Science_PushBeam:GetTargetArea(point)
	local ret = PointList()
	
	for i = DIR_START, DIR_END do
		for k = 1, 8 do
			local curr = DIR_VECTORS[i]*k + point
			if Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and not Board:IsBuilding(curr) and Board:IsValid(curr) then
			--if Board:IsValid(curr) and not Board:IsBlocked(curr, Pawn:GetPathProf()) then
				ret:push_back(DIR_VECTORS[i]*k + point)
			else
				break
			end
		end
	end
	
	return ret
end

function Science_PushBeam:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	local targets = {}
	local curr = p1 + DIR_VECTORS[dir]
	while Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and not Board:IsBuilding(curr) and Board:IsValid(curr) do
		targets[#targets+1] = curr
		curr = curr + DIR_VECTORS[dir]
	end
	
	local dam = SpaceDamage(curr, 0)
	ret:AddProjectile(dam,self.LaserArt)
	
	for i = 1, #targets do
		local curr = targets[#targets - i + 1]
		if Board:IsPawnSpace(curr) then
			ret:AddDelay(0.1)
		end
		
		local damage = SpaceDamage(curr, 0, dir)
		ret:AddDamage(damage)
	end
	
	return ret
end

Science_PushBeam_A = Science_PushBeam:new{	
		Limited = 0,
}

-------------------------------------------
---------------UNUSED----------------------
-------------------------------------------


---------------[[[[ Utility  ]]]]----------------------
--------------GravMech - Grav Well ----------------
--[[
Science_Gravsink = LineArtillery:new{
	Class = "Science",
	Icon = "weapons/skill_default.png",
	Sound = "",
	Explosion = "",
	PowerCost = 0,
	Damage = 0,
		ArtilleryStart = 2,
		ArtillerySize = 2,
	LaunchSound = "/weapons/gravwell",
	Upgrades = 0,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,0),
		Target = Point(2,0)
	}
}
					
function Science_Gravsink:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	

	for i = DIR_START, DIR_END do
	
		local damage = SpaceDamage(p1 + DIR_VECTORS[i]*2, 0, ((i-2)%4))
		ret:AddArtillery(damage,"effects/shot_pull_U.png", NO_DELAY)
		
	end	


	return ret
end


]]