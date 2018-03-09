
--[[  weapons within:

---PRIMARY
	Prime_Punchmech
	Prime_Lightning
	Prime_Lasermech
	Prime_ShieldBash
	Prime_Rockmech
	Prime_RightHook
	Prime_RocketPunch
	Prime_Shift
	Prime_Flamethrower
	Prime_Areablast
	Prime_Spear

---VOLATILE
	Prime_Leap
	Prime_SpinFist
	
---POWER 
	Prime_Sword
	Prime_Smash


	

]]--


			
------------------------------------------------------------------------------------------------
----------------------------------- Prime: Primary --------------------------------------------
------------------------------------------------------------------------------------------------

---------------[[[[ Primary  ]]]]----------------------
----------- PunchMech - Titan Fist --------------------

Prime_Punchmech = Skill:new{  
	Class = "Prime",
	Icon = "weapons/prime_punchmech.png",
	Rarity = 3,
	Explosion = "",
	LaunchSound = "/weapons/titan_fist",
	Range = 1, -- Tooltip?
	PathSize = 1,
	Damage = 2,
	PushBack = false,
	Flip = false,
	Dash = false,
	Shield = false,
	Projectile = false,
	Push = 1, --Mostly for tooltip, but you could turn it off for some unknown reason
	PowerCost = 1,
	Upgrades = 2,
	--UpgradeList = { "Dash",  "+2 Damage"  },
	UpgradeCost = { 2 , 3 },
	TipImage = StandardTips.Melee
}
				
function Prime_Punchmech:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)

	local doDamage = true
	local target = GetProjectileEnd(p1,p2,PATH_PROJECTILE)
	local push_damage = self.Flip and DIR_FLIP or direction
	local damage = SpaceDamage(target, self.Damage, push_damage)
	damage.sAnimation = "explopunch1_"..direction
	if self.Flip then damage.sAnimation = "SwipeClaw2" end  -- Change the animation if it's a flip
    
	if self.Shield then
		local shield = SpaceDamage(p1,0)
		shield.iShield = EFFECT_CREATE
		ret:AddDamage(shield)
	end
	
    if self.Dash then
       
        if not Board:IsBlocked(target,PATH_PROJECTILE) then -- dont attack an empty edge square, just run to the edge
	    	doDamage = false
		    target = target + DIR_VECTORS[direction]
    	end
    	
    	ret:AddCharge(Board:GetSimplePath(p1, target - DIR_VECTORS[direction]), FULL_DELAY)
    elseif self.Projectile and target:Manhattan(p1) ~= 1 then
		damage.loc = target
		ret:AddDamage(SpaceDamage(p1,0,(direction+2)%4))
		ret:AddProjectile(damage, "effects/shot_fist")
		doDamage = false--damage covered here
	else
		target = p2
	end

	
	if doDamage then
		damage.loc = target
		ret:AddMelee(p2 - DIR_VECTORS[direction], damage)
	end
	
	if self.PushBack then
		ret:AddDamage(SpaceDamage(p1, 0, GetDirection(p1 - p2)))
	end
	return ret
end	

Prime_Punchmech_A = Prime_Punchmech:new{
	PathSize = INT_MAX, 
	Dash = true,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Target = Point(2,1)
	}
}

Prime_Punchmech_B = Prime_Punchmech:new{	
	Damage = 4, 
}

Prime_Punchmech_AB = Prime_Punchmech:new{
	PathSize = INT_MAX, 
	Dash = true,
	Damage = 4,
	TipImage = Prime_Punchmech_A.TipImage
}


---------------[[[[ Primary  ]]]]----------------------
----------- MechElectric - Chain Whip -----------------

Prime_Lightning = Skill:new{
	Class = "Prime",
	Explosion = "",
	LaunchSound = "/weapons/electric_whip",
	Icon = "weapons/prime_lightning.png",
	PathSize = 1,
	Damage = 2,
	PowerCost = 2,
	Upgrades = 2,
	Buildings = false,
	FriendlyDamage = true,
	--UpgradeList = { "Building Chain", "Damage +1"  }, --"Allies Immune" 
	UpgradeCost = { 1 , 3 },
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,2),
		Enemy1 = Point(2,2),
		Enemy2 = Point(2,1),
		Enemy3 = Point(3,1),
	}
}

Prime_Lightning_A = Prime_Lightning:new{
	Buildings = true,
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,2),
		Enemy1 = Point(2,2),
		Building = Point(2,1),
		Enemy3 = Point(3,1),
	}
}

Prime_Lightning_B = Prime_Lightning:new{
	Damage = 3,
}
		
Prime_Lightning_AB = Prime_Lightning:new{
	--FriendlyDamage = false,
	Damage = 3,
	Buildings = true,
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,2),
		Enemy2 = Point(2,2),--Friendly1 = Point(2,2),
		Building = Point(2,1),
		Enemy3 = Point(3,1),
	}
}	
	

function Prime_Lightning:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(p2,self.Damage)
	local hash = function(point) return point.x + point.y*10 end
	local explored = {[hash(p1)] = true}
	local todo = {p2}
	local origin = { [hash(p2)] = p1 }
	
	if Board:IsPawnSpace(p2) or (self.Buildings and Board:IsBuilding(p2)) then
		ret:AddAnimation(p1,"Lightning_Hit")
	end
	
	while #todo ~= 0 do
		local current = pop_back(todo)
		
		if not explored[hash(current)] then
			explored[hash(current)] = true
			
			if Board:IsPawnSpace(current) or (self.Buildings and Board:IsBuilding(current)) then
			
				local direction = GetDirection(current - origin[hash(current)])
				damage.sAnimation = "Lightning_Attack_"..direction
				damage.loc = current
				damage.iDamage = Board:IsBuilding(current) and DAMAGE_ZERO or self.Damage
				
				if not self.FriendlyDamage and Board:IsPawnTeam(current, TEAM_PLAYER) then
					damage.iDamage = DAMAGE_ZERO
				end
				
				ret:AddDamage(damage)
				
				if not Board:IsBuilding(current) then
					ret:AddAnimation(current,"Lightning_Hit")
				end
				
				for i = DIR_START, DIR_END do
					local neighbor = current + DIR_VECTORS[i]
					if not explored[hash(neighbor)] then
						todo[#todo + 1] = neighbor
						origin[hash(neighbor)] = current
					end
				end
			end		
		end
	end

	return ret
end	

	
	
--------------------[[[[ Primary  ]]]]--------------------
------------LaserMech - Burst Beam -----------------

Prime_Lasermech = LaserDefault:new{
	Class = "Prime",
	Icon = "weapons/prime_lasermech.png",
	Rarity = 3,
	Explosion = "",
	Sound = "",
	Damage = 3,
	PowerCost = 1,
	MinDamage = 1,
	FriendlyDamage = true,
	Upgrades = 2,
--	UpgradeList = { "Ally Immune", "+1 Damage" },
	UpgradeCost = { 1,3 },
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Friendly = Point(2,1),
		Target = Point(2,2),
		Mountain = Point(2,0)
	}
}
			
Prime_Lasermech_A = Prime_Lasermech:new{
	FriendlyDamage = false,
}
Prime_Lasermech_B = Prime_Lasermech:new{
	Damage = 4,
}
Prime_Lasermech_AB = Prime_Lasermech:new{
	Damage = 4,
	FriendlyDamage = false,
}



--------------------[[[[ Primary  ]]]]--------------------
------------ GuardMech - Shield Bash -----------------

Prime_ShieldBash = Prime_Punchmech:new{  
	Flip = true,
	Icon = "weapons/prime_shieldbash.png",
	Upgrades = 2,
	LaunchSound = "/weapons/shield_bash",
	Damage = 2,
	UpgradeCost = { 1 , 2 },
	CustomTipImage = "Prime_Shield_Bash_Tip"
}

Prime_ShieldBash_A = Prime_ShieldBash:new{
	Shield = true,
	CustomTipImage = "Prime_Shield_Bash_Tip_A"
}

Prime_ShieldBash_B = Prime_ShieldBash:new{
	Damage = 3, 
	CustomTipImage = "Prime_Shield_Bash_Tip_B"
}

Prime_ShieldBash_AB = Prime_ShieldBash:new{
	Shield = true,
	Damage = 3,
	CustomTipImage = "Prime_Shield_Bash_Tip_AB"
}

Prime_Shield_Bash_Tip = Prime_Punchmech:new{
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomEnemy = "Firefly2",
		Length = 4
	},
	Damage = 2,
	Shield = false,
}

Prime_Shield_Bash_Tip_A = Prime_Shield_Bash_Tip:new{ Shield = true }
Prime_Shield_Bash_Tip_B = Prime_Shield_Bash_Tip:new{ Damage = 3, Shield = false }
Prime_Shield_Bash_Tip_AB = Prime_Shield_Bash_Tip:new{ Damage = 3, Shield = true }

function Prime_Shield_Bash_Tip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(0)
	damage.bHide = true
	damage.sScript = "Board:GetPawn(Point(2,1)):FireWeapon(Point(2,2),1)"
	ret:AddDamage(damage)
	damage = SpaceDamage(0)
	damage.bHide = true
	damage.fDelay = 1
	ret:AddDamage(damage)
	
	if self.Shield then
		local shield = SpaceDamage(p1,0)
		shield.iShield = 1
		shield.bHide = true
		ret:AddDamage(shield)
	end
	
	local damage = SpaceDamage(p2,self.Damage,DIR_FLIP)
	damage.bHide = true
	ret:AddMelee(p1,damage)
	return ret
end
	
----------[[[[ Primary  ]]]]----------
----------- Rock Throw -----------------

Prime_Rockmech = Skill:new{
	Class = "Prime",
	Range = RANGE_PROJECTILE,
	Icon = "weapons/prime_rockmech.png",
	Rarity = 3,
	Explosion = "",
	PathSize = INT_MAX,
	Damage = 2,
	PowerCost = 1,
	Push = 0,
	Upgrades = 2,
	UpgradeCost = { 2,3 },
	--UpgradeList = { "+1 Damage", "+1 Damage" },
	Tags = {"Rock Weapon"},
	LaunchSound = "/weapons/boulder_throw",
	ImpactSound = "/impact/dynamic/rock",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,0),
		Target = Point(2,0)
	}
}

function Prime_Rockmech:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
			
	local target = p1 + DIR_VECTORS[dir]
	local spawnRock = Point(-1,-1)
	
	for i = 1, 8 do
		--target.x == p2. and target.y == p2.y
		if Board:IsBlocked(target,PATH_PROJECTILE) then
			local hitdamage = SpaceDamage(target, self.Damage)
			if self.Push == 1 then
				hitdamage = SpaceDamage(target, self.Damage, dir)
			end
		
			if target - DIR_VECTORS[dir] ~= p1 then
			    spawnRock = target - DIR_VECTORS[dir]
				hitdamage.sAnimation = "ExploAir1"
			else
				hitdamage.sAnimation = "rock1d" 
			end
			
			ret:AddProjectile(hitdamage,"effects/shot_mechrock")
			break
		end
		
		if target == p2 then
			spawnRock = target
			ret:AddProjectile(SpaceDamage(spawnRock),"effects/shot_mechrock")
			break
		end
		
		if not Board:IsValid(target) then
			spawnRock = target - DIR_VECTORS[dir]
			ret:AddProjectile(SpaceDamage(spawnRock),"effects/shot_mechrock")
			break
		end
		
		target = target + DIR_VECTORS[dir]
	end
	
	if Board:IsValid(spawnRock) then
		local damage = SpaceDamage(spawnRock)
		damage.sPawn = "RockThrown"
		ret:AddDamage(damage)
		target = spawnRock
	end
	
	--ret.path = Board:GetSimplePath(p1, target)
	
	return ret
end

Prime_Rockmech_A = Prime_Rockmech:new{
	Damage = 3,
}

Prime_Rockmech_B = Prime_Rockmech:new{
	Damage = 3,
}
		
Prime_Rockmech_AB = Prime_Rockmech:new{
	Damage = 4,
}	
	

-----------[[[[ Primary  ]]]]-----------
--------------  Right Hook -------------------

Prime_RightHook = Skill:new{  
	Class = "Prime",
	Icon = "weapons/prime_righthook.png",
	Rarity = 3,
	Explosion = "ExploAir2",
	LaunchSound = "/weapons/titan_fist",
	Range = 1, -- Tooltip?
	PathSize = 1,
	Damage = 2,
	Push = 1, --Mostly for tooltip, but you could turn it off for some unknown reason
	PowerCost = 1,
	Upgrades = 2,
	UpgradeCost = { 2, 2 },
	TipImage = StandardTips.Melee
}
				
function Prime_RightHook:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	if p1:Manhattan(p2) == 2 then
		ret:AddMove(Board:GetSimplePath(p1, p1 + DIR_VECTORS[direction]), FULL_DELAY)
		p1 = p1 + DIR_VECTORS[direction]
	end
	
	damage = SpaceDamage(p2,self.Damage, ((direction-1)%4)*self.Push)
	
	damage.sAnimation = "explopunch1_"..((direction-1)%4)
	ret:AddMelee(p1,damage)
	
	return ret
end	

Prime_RightHook_A = Prime_RightHook:new{
	Damage = 3, 
}

Prime_RightHook_B = Prime_RightHook:new{	
	Damage = 3, 
}

Prime_RightHook_AB = Prime_RightHook:new{
	PathSize = 2, 
	Range = 2,
	Damage = 4,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1)
	}
}

	
-----------[[[[ Primary   ]]]]-----------
--------------  Rocket Fist -------------------

Prime_RocketPunch = Prime_Punchmech:new{  
	Icon = "weapons/prime_rocketpunch.png",
	Upgrades = 2,
	PushBack = true,
	ImpactSound = "/impact/generic/explosion",
	--UpgradeList = { "Rocket",  "+2 Damage"  },
	UpgradeCost = { 2 , 2 },
	TipImage = StandardTips.Melee
}

function Prime_RocketPunch:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)

	local doDamage = true
	local target = GetProjectileEnd(p1,p2,PATH_PROJECTILE)
	local damage = SpaceDamage(target, self.Damage, direction)
	damage.sAnimation = "explopunch1_"..direction
	if self.Projectile and target:Manhattan(p1) ~= 1 then
		damage.loc = target
		ret:AddDamage(SpaceDamage(p1,0,(direction+2)%4))
		ret:AddProjectile(damage, "effects/shot_fist", NO_DELAY)
		doDamage = false--damage covered here
	else
		target = p2
	end
	
	if doDamage then
		damage.loc = target
		ret:AddDamage(damage)
	end
	
	if self.PushBack then
		local backdir = GetDirection(p1-p2)
		damage = SpaceDamage(p1, 0, backdir)
		damage.sAnimation = "airpush_"..backdir
		ret:AddDamage(damage)
	end
	return ret
end	

Prime_RocketPunch_A = Prime_RocketPunch:new{
	Projectile = true,
	PathSize = INT_MAX, 
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1)
	}
}

Prime_RocketPunch_B = Prime_RocketPunch:new{
	Damage = 4, 
}

Prime_RocketPunch_AB = Prime_RocketPunch:new{
	Projectile = true,
	PathSize = INT_MAX, 
	Damage = 4,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1)
	}
}



------------------[[[[ UTILITY  ]]]]------------------------
------------------- PRIME SHIFT -------------------------------

Prime_Shift = Skill:new{
	Class = "Prime",
	Icon = "weapons/prime_shift.png",
	Rarity = 1,
	Shield = 0,
	Damage = 1,
	FriendlyDamage = true,
	Cost = "low",
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = {2,3},
	Range = 1, --TOOLTIP INFO
	LaunchSound = "/weapons/shift",
	TipImage = StandardTips.Melee,
	ArtillerySize = 2,
}

function Prime_Shift:GetTargetArea(point)
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		for i = 1, self.ArtillerySize do
			local curr = Point(point + DIR_VECTORS[dir] * i)
			if not Board:IsValid(curr) then
				break
			end
			
			if not Board:IsBlocked(curr,PATH_FLYER) then
				ret:push_back(curr)
			end

		end
	end
	
	return ret
end

function Prime_Shift:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p1 - p2)
	local oppositeDir = GetDirection(p2 - p1)
	
	local move = PointList()
	move:push_back(p1-DIR_VECTORS[oppositeDir])
	move:push_back(p2)
	
	local fake_punch = SpaceDamage(p2,0)
	ret:AddMelee(p1,fake_punch)
	ret:AddLeap(move, FULL_DELAY)
	
	local damage = SpaceDamage(p2,self.Damage)
		
	if not self.FriendlyDamage and Board:IsPawnTeam(p1,TEAM_PLAYER) then
		damage.iDamage = 0
	end
	
	ret:AddDamage(damage)
	ret:AddBounce(damage.loc,3)
	return ret
end


Prime_Shift_A = Prime_Shift:new{
	ArtillerySize = 5,
	TipImage = {
		Unit = Point(2,2),
		Friendly = Point(2,1),
		Enemy = Point(3,2),
		Target = Point(2,1),
		Second_Origin = Point(2,2),
		Second_Target = Point(3,2),
	}
}

Prime_Shift_B = Prime_Shift:new{
	Damage = 3, 
}

Prime_Shift_AB = Prime_Shift:new{
	ArtillerySize = 4,
	Damage = 3,
	TipImage = {
		Unit = Point(2,2),
		Friendly = Point(2,1),
		Enemy = Point(3,2),
		Target = Point(2,1),
		Second_Origin = Point(2,2),
		Second_Target = Point(3,2),
	} 
}

------------------[[[[ UTILITY  ]]]]------------------------
---------------- Prime Flamethrower ------------------------

Prime_Flamethrower = Skill:new{  
	Class = "Prime",
	Icon = "weapons/prime_flamethrower.png",
	Rarity = 3,
	Explosion = "",
--	LaunchSound = "/weapons/titan_fist",
	Range = 1, -- Tooltip?
	PathSize = 1,
	Damage = 2,
	FireDamage = 2,
	Push = 1, --Mostly for tooltip, but you could turn it off for some unknown reason
	PowerCost = 1,
	Upgrades = 2,
	UpgradeList = { "+1 Range",  "+1 Range"  },
	UpgradeCost = { 1 , 3 },
	TipImage = StandardTips.Melee,
	LaunchSound = "/weapons/flamethrower"
}

function Prime_Flamethrower:GetTargetArea(point)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		for k = 1, self.PathSize do
			local curr = DIR_VECTORS[i]*k + point
			ret:push_back(curr)
			if not Board:IsValid(curr) or Board:GetTerrain(curr) == TERRAIN_MOUNTAIN then
				break
			end
		end
	end
	
	return ret
end
				
function Prime_Flamethrower:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local distance = p1:Manhattan(p2)

	for i = 1, distance do
		local curr = p1 + DIR_VECTORS[direction]*i
		local exploding = Board:IsPawnSpace(curr) and Board:GetPawn(curr):IsFire()
		local push = (i == distance) and direction*self.Push or DIR_NONE
		local damage = SpaceDamage(p1 + DIR_VECTORS[direction]*i,0, push)
		if exploding then
			damage.iDamage = damage.iDamage + self.FireDamage
			damage.sAnimation = "ExploAir1"
		end
		damage.iFire = EFFECT_CREATE
		if i == distance then 	
			damage.sAnimation = "flamethrower"..distance.."_"..direction 
		end
		ret:AddDamage(damage)
	end

	return ret
end	

Prime_Flamethrower_A = Prime_Flamethrower:new{
	PathSize = 2, 
	Range = 2,
	TipImage = StandardTips.Ranged,
}

Prime_Flamethrower_B = Prime_Flamethrower:new{
	PathSize = 2, 
	Range = 2,
	TipImage = StandardTips.Ranged,
}

Prime_Flamethrower_AB = Prime_Flamethrower:new{
	PathSize = 3, 
	Range = 3,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Target = Point(2,1)
	}
}


------------------[Primary]------------------------
-----------------  Area Blast-------------------------------
Prime_Areablast = Skill:new{  
	PathSize = 1,
	Class = "Prime",
	Icon = "weapons/prime_areablast.png",
	Explosion = "ExploAir2",
	Damage = 1,
	PowerCost = 1,
	Upgrades = 2,
	Push = 1,--TOOLTIP HELPER,
	Range = 1,--TOOLTIP HELPER
	UpgradeCost = { 2,2 },
	--UpgradeList = { "+1 Damage",  "+1 Damage"  },
	TipImage = StandardTips.Surrounded,
	LaunchSound = "/weapons/localized_burst"
}
		
function Prime_Areablast:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	--ret:AddDamage(SpaceDamage(p2,self.Damage, direction))
	--ret:AddSound("/weapons/localized_explosion")  -- NEED TO CHANGE 
	for i = DIR_START,DIR_END do
		local spaceDamage = SpaceDamage(p1 + DIR_VECTORS[i], self.Damage, i)
		spaceDamage.sSound = "/impact/generic/explosion"
		spaceDamage.sAnimation = "explopush1_"..i
		ret:AddDamage(spaceDamage)
	end
	return ret
end	

Prime_Areablast_A = Prime_Areablast:new{
		Damage = 2,
}

Prime_Areablast_B = Prime_Areablast:new{
		Damage = 2,
}

Prime_Areablast_AB = Prime_Areablast:new{
		Damage = 3
}



------------------[Primary]------------------------
---------------- Prime Spear ------------------------

Prime_Spear = Skill:new{  
	Class = "Prime",
	Icon = "weapons/prime_spear.png",
	Explosion = "",
	Range = 2, 
	PathSize = 2,
	Damage = 2,
	Push = 1,
	Acid = 0,
	PowerCost = 2,
	Upgrades = 2,
	UpgradeCost = { 1 , 2 },
	LaunchSound = "/weapons/sword",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,1)
	}
}

function Prime_Spear:GetTargetArea(point)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		for k = 1, self.PathSize do
			local curr = DIR_VECTORS[i]*k + point
			ret:push_back(curr)
			if not Board:IsValid(curr) then --or Board:GetTerrain(curr) == TERRAIN_MOUNTAIN then
				break
			end
		end
	end
	
	return ret
end
				
function Prime_Spear:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local distance = p1:Manhattan(p2)

	for i = 1, distance do
		local push = (i == distance) and direction*self.Push or DIR_NONE
		local damage = SpaceDamage(p1 + DIR_VECTORS[direction]*i,self.Damage, push)
		if i == distance then
			damage.iAcid = self.Acid
		end
		if i == 1 then
			damage.sAnimation = "explospear"..distance.."_"..direction
		end
		ret:AddDamage(damage)
	end

	return ret
end	

Prime_Spear_A = Prime_Spear:new{
	Acid = 1,
}

Prime_Spear_B = Prime_Spear:new{
	PathSize = 3, 
	Range = 3,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,1)
	}
}

Prime_Spear_AB = Prime_Spear:new{
	Acid = 1,
	PathSize = 3, 
	Range = 3,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,1)
	}
}

------------------------------------------------------------------------------------------------
----------------------------------- PRIME: VOLATILE --------------------------------------------
------------------------------------------------------------------------------------------------

------------------[Volatile]------------------------
--------------------- PRIME LEAP ------------------------------

Prime_Leap = Leap_Attack:new{
	Class = "Prime",
	Icon = "weapons/prime_leap.png",	
	Rarity = 1,
	Range = 7,
	Cost = "med",
	Cost = 1,
	--BuildingDamage = false,
	Damage = 1,
	Push = 1,
	SelfDamage = 1,
	PushAnimation = 1, -- 0 = airpush; 1 = explopush1; 2 = explopush2
	Limited = 0,
	PowerCost = 1,
	Upgrades = 2,
	UpgradeCost = {1,3},
	--UpgradeList = { "+1 Damage Each", "+1 Damage" },
	LaunchSound = "/weapons/leap",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Enemy2 = Point(3,2),
		Target = Point(2,2)
	}
}

Prime_Leap_A = Prime_Leap:new{	
		Damage = 2,
		SelfDamage = 2,
		SelfAnimation = "ExploAir2",
}
Prime_Leap_B = Prime_Leap:new{
		Damage = 2,
}
Prime_Leap_AB = Prime_Leap:new{
		Damage = 3,
		SelfDamage = 2,
		PushAnimation = 2,
		SelfAnimation = "ExploAir2",
}


	
------------------[Volatile]------------------------
-------------- Prime - Spinfist ---------------------------

Prime_SpinFist = Skill:new{  
	Class = "Prime",
	Icon = "weapons/prime_spinfist.png",
	Rarity = 3,
	Explosion = "ExploAir2",
	LaunchSound = "/weapons/titan_fist",
	Range = 1, -- Tooltip?
	PathSize = 1,
	Damage = 2,
	Push = 1,
	PowerCost = 1,
	SelfDamage = 2,
	Upgrades = 2,
--	UpgradeList = { "+1 Damage Each",  "+1 Damage"  },
	UpgradeCost = { 1 , 3 },
	TipImage = StandardTips.Surrounded
}
				
function Prime_SpinFist:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	local damage = SpaceDamage(p1, self.SelfDamage)
	if self.SelfDamage == 1 then damage.sAnimation = "ExploAir1" end
	ret:AddDamage(damage)
	
	damage = SpaceDamage(p1 + DIR_VECTORS[0],self.Damage, 3)
	damage.sAnimation = "explopunch1_3"
	ret:AddDamage(damage)
		
	damage = SpaceDamage(p1 + DIR_VECTORS[2],self.Damage, 1)
	damage.sAnimation = "explopunch1_1"
	ret:AddDamage(damage)
	
	ret:AddDelay(0.2)
		
	damage = SpaceDamage(p1 + DIR_VECTORS[1],self.Damage, 0)
	damage.sAnimation = "explopunch1_0"
	ret:AddDamage(damage)
		
	damage = SpaceDamage(p1 + DIR_VECTORS[3],self.Damage, 2)
	damage.sAnimation = "explopunch1_2"
	ret:AddDamage(damage)
	--[[
	if p1:Manhattan(p2) == 2 then
		ret:AddMove(Board:GetSimplePath(p1, p1 + DIR_VECTORS[direction]), FULL_DELAY)
		p1 = p1 + DIR_VECTORS[direction]
	end
	
	
	
	for i = DIR_START, DIR_END do
		damage = SpaceDamage(p1 + DIR_VECTORS[i],self.Damage, ((i-1)%4)*self.Push)
		--ret:AddMelee(p1,damage)
		damage.sAnimation = "explopunch1_"..((i-1)%4)
		ret:AddDamage(damage)
	end
	]]
	
	return ret
end	

Prime_SpinFist_A = Prime_SpinFist:new{
		SelfDamage = 1,
}

Prime_SpinFist_B = Prime_SpinFist:new{	
		Damage = 3, 
}

Prime_SpinFist_AB = Prime_SpinFist:new{
		Damage = 3,
		SelfDamage = 1,
}

			
------------------------------------------------------------------------------------------------
----------------------------------- Prime: Limited --------------------------------------------
------------------------------------------------------------------------------------------------

------------------[[[[ Limited  ]]]]------------------------
--------------------  SWORD-------------------------

Prime_Sword = Skill:new{  
	Class = "Prime",
	Icon = "weapons/prime_sword.png",
	Rarity = 1,
	PathSize = 1,
	Damage = 2,
	Push = 1,
	Cost = "high",
	PowerCost = 1,
	Upgrades = 2,
	UpgradeCost = { 1,3 },
--	UpgradeList = { "+1 Use", "+2 Damage" },
	Limited = 1,
	LaunchSound = "/weapons/sword",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Target = Point(2,2)
	}
}

function Prime_Sword:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local dir = direction
	
	if self.AddPush == 0 then
		direction = DIR_NONE
	end 
	
	ret:AddDamage(SoundEffect(p2,self.LaunchSound))
	ret:AddDamage(SpaceDamage(p2 + DIR_VECTORS[(direction + 1)% 4], self.Damage, direction))
	ret:AddDamage(SpaceDamage(p2 - DIR_VECTORS[(direction + 1)% 4], self.Damage, direction))
	
	--ret:AddDamage(SpaceDamage(p2,self.Damage, direction))
	
	local centerdamage = SpaceDamage(p2, self.Damage, direction)
	centerdamage.sAnimation = "explosword_"..dir
	ret:AddDamage(centerdamage)
	
	return ret
end	

Prime_Sword_A = Prime_Sword:new{
		Limited = 2,
}

Prime_Sword_B = Prime_Sword:new{
		Damage = 4, 
}

Prime_Sword_AB = Prime_Sword:new{
		Damage = 4, 
		Limited = 2
}


------------------[[[[ Limited  ]]]]------------------------
--------------------  GROUND SMASH-------------------------

Prime_Smash = Skill:new{  
	Class = "Prime",
	Icon = "weapons/prime_smash.png",
	PathSize = 1,
	Damage = 4,
	PowerCost = 1,
	Upgrades = 2,
	UpgradeCost = { 2,1 },
	Limited = 1,
	LaunchSound = "/weapons/mercury_fist",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Target = Point(2,2)
	}
}

function Prime_Smash:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	ret:AddDamage(SoundEffect(p2,self.LaunchSound))
	
	damage = SpaceDamage(p2, self.Damage)
	damage.sAnimation = "explosmash_"..direction
	
	ret:AddDamage(damage)
	
	ret:AddDelay(0.1)
	ret:AddBounce(p2,3)
	ret:AddDelay(0.2)
	
	local damage = SpaceDamage(p2 + DIR_VECTORS[direction], 0, direction)
	damage.sAnimation = "airpush_"..direction
	ret:AddDamage(damage)
	
	damage = SpaceDamage(p2 + DIR_VECTORS[(direction + 1)% 4], 0, (direction+1)%4)
	damage.sAnimation = "airpush_"..((direction+1)%4)
	ret:AddDamage(damage)
	
	damage = SpaceDamage(p2 + DIR_VECTORS[(direction - 1)% 4],0, (direction-1)%4)
	damage.sAnimation = "airpush_"..((direction-1)%4)
	ret:AddDamage(damage)
	
	
	return ret
end	

Prime_Smash_A = Prime_Smash:new{
		Limited = 2,
}

Prime_Smash_B = Prime_Smash:new{
		Damage = 5, 
}

Prime_Smash_AB = Prime_Smash:new{
		Damage = 5, 
		Limited = 2
}


--[[
--!!!!!!!------!!!!!!!------!!!!!!!------!!!!!!!------!!!!!!!------!!!!!!!----
----------------------------- PRIME: UNUSED?! --------------------------
--------------------------------- Prime Punch---------------------------------
Prime_Punch = Prime_Punchmech:new{
	Name = "Atlas Fist",
	Icon = "weapons/prime_punch.png",
	Rarity = 1,
	Damage = 3,
	PowerCost = 2,
	LaunchSound = "/weapons/titan_hit",
	Limited = 2,
	Upgrades = 2,
	UpgradeList = { "+1 Range",  "+2 Damage"  },
	UpgradeCost = { 1 , 3 }
		
}

Prime_Punch_A = Prime_Punch:new{
		Range = 2, 
		UpgradeDescription = "Allows moving 1 forward before attack"
}

Prime_Punch_B = Prime_Punch:new{	
		Damage = 5, 
		UpgradeDescription = "Increase Damage to 5"
	}

Prime_Punch_AB = Prime_Punch:new{
	Range = 2, 
	Damage = 5
}


--------------------------------- Prime Rock---------------------------------
	
Prime_Rockthrow = Prime_Rockmech:new{
			Name = "Rock Throw",
			Icon = "weapons/prime_rock.png",
			Rarity = 1,
			Damage = 3,
			LaunchSound = "/weapons/boulder_throw",
			ImpactSound = "/impact/dynamic/rock",
			Limited = 2,
			PowerCost = 2,
			UpgradeCost = { 3,1 },
			UpgradeList = { "+2 Damage", "Adds Push " },
			Tags = {}
}
Prime_Rockthrow_A = Prime_Rockthrow:new{
		Damage = 5,
		UpgradeDescription = "Increases damage by 2."
	}

Prime_Rockthrow_B = Prime_Rockthrow:new{
		Push = 1,
		UpgradeDescription = "Adds push on hit tile.",
	}
		
Prime_Rockthrow_AB = Prime_Rockthrow:new{
		Damage = 5,
		Push = 1,
	}	
	
	
--------------------------------- Prime Laser---------------------------------

Prime_Laser = Prime_Lasermech:new{
			Name = "Basic Beam",
			Icon = "weapons/prime_laser.png",
			Rarity = 0,
			PowerCost = 2,
			Damage = 4,
			Limited = 2,
			UpgradeList = { "+1 Damage",  "Ally Immune"  },
			UpgradeCost = { 3,1 },
			LaunchSound = "/weapons/basic_beam"
}
Prime_Laser_A = Prime_Laser:new{
		Damage = 5,
		UpgradeDescription = "Increase the starting damage to 5.",
		DamageTooltip = TipData("Damage","4 $1(+1) to 1")
}
Prime_Laser_B = Prime_Laser:new{
		FriendlyDamage = false,
		UpgradeDescription = "Friendly units will not take damage from this attack."
}
Prime_Laser_AB = Prime_Laser:new{
		Damage = 5,
		FriendlyDamage = false,
		DamageTooltip = TipData("Damage","4 $1(+1) to 1")
}

--]]