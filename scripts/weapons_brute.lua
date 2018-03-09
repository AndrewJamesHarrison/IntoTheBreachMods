
--[[  weapons within:


---Primary
	Brute_Tankmech
	Brute_Jetmech
	Brute_Mirrorshot
	 --
	Brute_PhaseShot
	
---UTILITY
	Brute_Grapple
	 --
	Brute_Shrapnel

---VOLATILE
	Brute_Beetle
	Brute_Unstable

---POWER 
	Brute_Heavyrocket
	Brute_Splitshot
	
	
	
---UNUSED---
--Brute_Trishot
Brute_Tank (weak)
Brute_Burst (weak)

]]--



			
------------------------------------------------------------------------------------------------
----------------------------------- BRUTE: Primary --------------------------------------------
------------------------------------------------------------------------------------------------

---------------[[[[ Primary  ]]]]----------------------
-------------- TankMech - Cannon  -----------------

	
Brute_Tankmech = TankDefault:new	{
	Class = "Brute",
	Damage = 1,
	Icon = "weapons/brute_tankmech.png",
	Explosion = "",
	Sound = "/general/combat/explode_small",
	Damage = 1,
	Push = 1,
	PowerCost = 1,
	Upgrades = 2,
	UpgradeCost = {2,3},
	LaunchSound = "/weapons/modified_cannons",
	ImpactSound = "/impact/generic/explosion",
	TipImage = StandardTips.Ranged
}
			
Brute_Tankmech_A = Brute_Tankmech:new{
	Damage = 2,
}

Brute_Tankmech_B = Brute_Tankmech:new{
	Damage = 2,
}

Brute_Tankmech_AB = Brute_Tankmech:new{
	Damage = 3,
	Explo = "explopush2_",
}


---------------[[[[ Primary  ]]]]----------------------
-------------- JetMech - Strafe -----------------

Brute_Jetmech = Skill:new{
	Class = "Brute",
	Icon = "weapons/brute_jetmech.png",
	Rarity = 3,
	AttackAnimation = "ExploRaining1",
	Sound = "/general/combat/stun_explode",
	MinMove = 2,
	Range = 2,
	Damage = 1,
	Damage2 = 1,
	AnimDelay = 0.2,
	Smoke = 1,
	Acid = 0,
	PowerCost = 1,
	DoubleAttack = 0, --does it attack again after stopping moving
	Upgrades = 2,
	UpgradeCost = {2,2},
	LaunchSound = "/weapons/bomb_strafe",
	BombSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Target = Point(2,1)
	}
}

function Brute_Jetmech:GetTargetArea(point)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		for k = self.MinMove, self.Range do
			if not Board:IsBlocked(DIR_VECTORS[i]*k + point, Pawn:GetPathProf()) then
				ret:push_back(DIR_VECTORS[i]*k + point)
			end
		end
	end
	
	return ret
end

function Brute_Jetmech:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	local move = PointList()
	move:push_back(p1)
	move:push_back(p2)
	
	local distance = p1:Manhattan(p2)
	
	ret:AddBounce(p1,2)
	if distance == 1 then
		ret:AddLeap(move, 0.5)--small delay between move and the damage, attempting to make the damage appear when jet is overhead
	else
		ret:AddLeap(move, 0.25)
	end
		
	for k = 1, (self.Range-1) do
		
		if p1 + DIR_VECTORS[dir]*k == p2 then
			break
		end
		
		local damage = SpaceDamage(p1 + DIR_VECTORS[dir]*k, self.Damage)
		
		damage.iSmoke = self.Smoke
		damage.iAcid = self.Acid
		
		damage.sAnimation = self.AttackAnimation
		damage.sSound = self.BombSound
		
		if k ~= 1 then
			ret:AddDelay(self.AnimDelay) --was 0.2
		end
		
		ret:AddDamage(damage)
		
		ret:AddBounce(p1 + DIR_VECTORS[dir]*k,3)
		
	--	ret:AddSound(self.BombLaunchSound)
	end
	
	if self.DoubleAttack == 1 then
		ret:AddDamage(SpaceDamage(p1 + DIR_VECTORS[dir]*(self.Range+1), self.Damage2))
	end
	
	
	return ret
end

Brute_Jetmech_A = Brute_Jetmech:new{
	Damage = 2, 
	AttackAnimation = "ExploRaining2",
}

Brute_Jetmech_B = Brute_Jetmech:new{
	Range = 3, 
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,0)
	}
}

Brute_Jetmech_AB = Brute_Jetmech:new{
	Damage = 2, 
	Range = 3, 
	AttackAnimation = "ExploRaining2",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,0)
	}
}

---------------[[[[ Primary  ]]]]----------------------
-------------- MirrorMech - Mirror Cannon  ------------


Brute_Mirrorshot = TankDefault:new{
		Class = "Brute",
		Icon = "weapons/brute_mirror.png",
		Sound = "/general/combat/explode_small",
		Damage = 1,
		BackShot = 1,
		Push = 1,
		PowerCost = 1,
		Upgrades = 2,
		UpgradeCost = {1,3},
		LaunchSound = "/weapons/mirror_shot",
		ImpactSound = "/impact/generic/explosion",
		TipImage = {
			Unit = Point(2,2),
			Enemy = Point(1,2),
			Enemy2 = Point(4,2),
			Target = Point(1,2)
		}
}

Brute_Mirrorshot_A = Brute_Mirrorshot:new{
	Damage = 2,
}

Brute_Mirrorshot_B = Brute_Mirrorshot:new{
	Damage = 2,
}

Brute_Mirrorshot_AB = Brute_Mirrorshot:new{
	Damage = 3,
	Explo = "explopush2_",
}

---------------[[[[ Primary  ]]]]----------------------
-------------- Phase Cannon  -----------------

Brute_PhaseShot = TankDefault:new{
	Class = "Brute",
	Icon = "weapons/brute_phaseshot.png",
	Explosion = "",
	Explo = "explopush1_",
	Sound = "/general/combat/explode_small",
	ProjectileArt = "effects/shot_phaseshot",
	Damage = 1,
	Push = 1,
	PowerCost = 1,
	Upgrades = 2,
	Phase = true,
	PhaseShield = false,
	UpgradeCost = {2,2},
	LaunchSound = "/weapons/phase_shot",
	ImpactSound = "/impact/generic/explosion",
	--TipImage = StandardTips.Ranged
	TipImage = {
		Unit = Point(2,3),
		Building = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,2)
	}
}

Brute_PhaseShot_A = Brute_PhaseShot:new{
	PhaseShield = true,
	Explo = "explopush1_",
}

Brute_PhaseShot_B = Brute_PhaseShot:new{
	Damage = 2,
	Explo = "explopush2_",
}

Brute_PhaseShot_AB = Brute_PhaseShot:new{
	PhaseShield = true,
	Damage = 2,
	Explo = "explopush2_",
}

-------------------





---------------[[[[ Utility  ]]]]----------------------
-------------- WallMech - Grapple  -----------------

Brute_Grapple = {
	Class = "Brute",
	Rarity = 1,
	Icon = "weapons/brute_grapple.png",	
	Explosion = "",
	Shield = 0,
	ShieldAlly = 0,
	Damage = 0,
	Range = RANGE_PROJECTILE,--TOOLTIP info
	Cost = "low",
	PowerCost = 0,
	Upgrades = 1,
	UpgradeCost = { 1 },
	--UpgradeList = { "Shield Self", "Damage Enemies" },
	LaunchSound = "/weapons/grapple",
	ImpactSound = "/impact/generic/grapple",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,0),
		Target = Point(2,0),
		Second_Origin = Point(2,2),
		Second_Target = Point(2,4),
		Mountain = Point(2,4),
	}
}
			
Brute_Grapple = Skill:new(Brute_Grapple)

function Brute_Grapple:GetTargetArea(point)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		local this_path = {}
		
		local target = point + DIR_VECTORS[dir]

		while not Board:IsBlocked(target, PATH_PROJECTILE) do
			this_path[#this_path+1] = target
			target = target + DIR_VECTORS[dir]
		end
		
		if Board:IsValid(target) and target:Manhattan(point) > 1 then
			this_path[#this_path+1] = target
			for i,v in ipairs(this_path) do 
				ret:push_back(v)
			end
		end
	end
	
	return ret
end

function Brute_Grapple:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)

	local target = p1 + DIR_VECTORS[direction]

	while not Board:IsBlocked(target, PATH_PROJECTILE) do
		target = target + DIR_VECTORS[direction]
	end
	
	if not Board:IsValid(target) then
		return ret
	end
	
	local damage = SpaceDamage(target)
	damage.bHidePath = true
	ret:AddProjectile(damage,"effects/shot_grapple")
	
	if Board:IsPawnSpace(target) and not Board:GetPawn(target):IsGuarding() then	-- If it's a pawn

		ret:AddCharge(Board:GetSimplePath(target, p1 + DIR_VECTORS[direction]), FULL_DELAY)
		--[[
		if Board:IsPawnTeam(target, TEAM_ENEMY) then
			ret:AddDamage(SpaceDamage(p1 + DIR_VECTORS[direction],self.Damage))
		end
		]]
		if Board:IsPawnTeam(target, TEAM_PLAYER) then
			local shielddamage = SpaceDamage(p1 + DIR_VECTORS[direction],0)
			shielddamage.iShield = self.ShieldAlly
			ret:AddDamage(shielddamage)
		end
		
		local shieldSelf = SpaceDamage(p1,0)
		shieldSelf.iShield = self.Shield
		ret:AddDamage(shieldSelf)
	elseif Board:IsBlocked(target, Pawn:GetPathProf()) then     --If it's an obstruction
		ret:AddCharge(Board:GetSimplePath(p1, target - DIR_VECTORS[direction]), FULL_DELAY)	
		local shieldSelf = SpaceDamage(target - DIR_VECTORS[direction],0)
		shieldSelf.iShield = self.Shield
		ret:AddDamage(shieldSelf)		
	end
		
	return ret
end

Brute_Grapple_A = Brute_Grapple:new{
		ShieldAlly = 1,
		TipImage = {
			Unit = Point(2,4),
			Friendly = Point(2,0),
			Target = Point(2,0)
		}
}
--[[
Brute_Grapple_B = Brute_Grapple:new{
		Damage = 1,
}
Brute_Grapple_AB = Brute_Grapple:new{
		Shield = 1,
		Damage = 1,
} ]]



---------------[[[[ Utility  ]]]]----------------------
--------------  Defensive Shrapnel  -----------------
	
Brute_Shrapnel = TankDefault:new	{
	Class = "Brute",
	Damage = 0,
	Icon = "weapons/brute_shrapnel.png",
	Explosion = "",
	Sound = "/general/combat/explode_small",
	Damage = 0,
	Push = 1,
	PowerCost = 0,
	LaunchSound = "/weapons/shrapnel",
	ImpactSound = "/impact/generic/explosion",
	TipImage = StandardTips.Ranged
}
			
function Brute_Shrapnel:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local target = GetProjectileEnd(p1,p2)  
	
	local damage = SpaceDamage(target, self.Damage)
	ret:AddProjectile(damage, "effects/shot_shrapnel")
--	ret.path = Board:GetSimplePath(p1, target)
	
	for dir = 0, 3 do
		damage = SpaceDamage(target + DIR_VECTORS[dir], 0, dir)
		damage.sAnimation = "airpush_"..dir
		if dir ~= GetDirection(p1 - p2) then
			ret:AddDamage(damage)
		end
	end
	
	return ret
end

---------------[[[[ Primary  ]]]]----------------------
--------------  Sonic Dash  ------------
	
Brute_Sonic = Skill:new{
	Class = "Brute",
	Icon = "weapons/brute_sonic.png",	
	Explosion = "",
	Push = 1,--TOOLTIP HELPER
	Fly = 1,
	--Damage = 2,
	--SelfDamage = 1,
	PathSize = INT_MAX,
	Cost = "med",
	PowerCost = 1,
	Upgrades = 0,
	LaunchSound = "/weapons/charge",
	ImpactSound = "/weapons/charge_impact",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(1,2),
		Enemy2 = Point(3,2),
		Enemy3 = Point(3,3),
		Enemy4 = Point(1,0),
		Target = Point(2,0)
	}
}
			
function Brute_Sonic:GetTargetArea(point)
	local ret = PointList()
	
	for i = DIR_START, DIR_END do
		for k = 1, 8 do
			local curr = DIR_VECTORS[i]*k + point
			if Board:IsValid(curr) and not Board:IsBlocked(curr, Pawn:GetPathProf()) then
				ret:push_back(DIR_VECTORS[i]*k + point)
			else
				break
			end
		end
	end
	
	return ret
end

function Brute_Sonic:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)

	local distance = p1:Manhattan(p2)  --target
	
	ret:AddCharge(Board:GetSimplePath(p1, p2), NO_DELAY)
	

	for i = 0, distance do
		ret:AddDelay(0.06)
		ret:AddBounce(p1 + DIR_VECTORS[dir]*i, -3)
	
		local damage = SpaceDamage(p1 + DIR_VECTORS[dir]*i + DIR_VECTORS[(dir+1)%4], 0, (dir+1)%4)
		damage.sAnimation = "exploout0_"..(dir+1)%4
		ret:AddDamage(damage)
		damage = SpaceDamage(p1 + DIR_VECTORS[dir]*i + DIR_VECTORS[(dir-1)%4], 0, (dir-1)%4)
		damage.sAnimation = "exploout0_"..(dir-1)%4
		ret:AddDamage(damage)
	end
	
	
	return ret
end

Brute_Sonic_A = Brute_Sonic:new{
		Damage = 3,
		SelfDamage = 2,
}

Brute_Sonic_B = Brute_Sonic:new{
		Damage = 3,
}

Brute_Sonic_AB = Brute_Sonic:new{
		Damage = 4,
		SelfDamage = 2,
}

------------------------------------------------------------------------------------------------
----------------------------------- BRUTE: Volatile --------------------------------------------
------------------------------------------------------------------------------------------------

---------------[[[[ Volatile  ]]]]----------------------
--------------  ChargeMech - Beetle charge  ------------
	
Brute_Beetle = Skill:new{
	Class = "Brute",
	Icon = "weapons/brute_beetle.png",	
	Rarity = 3,
	Explosion = "ExploAir1",
	Push = 1,--TOOLTIP HELPER
	Fly = 1,
	Damage = 2,
	SelfDamage = 1,
	BackSmoke = 0,
	PathSize = INT_MAX,
	Cost = "med",
	PowerCost = 1,
	Upgrades = 2,
	UpgradeCost = {1,3},
	LaunchSound = "/weapons/charge",
	ImpactSound = "/weapons/charge_impact",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Target = Point(2,1)
	}
}
			
function Brute_Beetle:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)

	local pathing = PATH_PROJECTILE
	if self.Fly == 0 then pathing = Pawn:GetPathProf() end

	local doDamage = true
	local target = GetProjectileEnd(p1,p2,pathing)
	local distance = p1:Manhattan(target)
	
	if not Board:IsBlocked(target,pathing) then -- dont attack an empty edge square, just run to the edge
		doDamage = false
		target = target + DIR_VECTORS[direction]
	end
	
	if self.BackSmoke == 1 then
		local smoke = SpaceDamage(p1 - DIR_VECTORS[direction], 0)
		smoke.iSmoke = 1
		ret:AddDamage(smoke)
	end
	
	local damage = SpaceDamage(target, self.Damage, direction)
	damage.sAnimation = "ExploAir2"
	damage.sSound = self.ImpactSound
	
	if distance == 1 and doDamage then
		ret:AddMelee(p1,damage, NO_DELAY)
		if doDamage then ret:AddDamage(SpaceDamage( target - DIR_VECTORS[direction] , self.SelfDamage)) end
	else
		ret:AddCharge(Board:GetSimplePath(p1, target - DIR_VECTORS[direction]), NO_DELAY)--FULL_DELAY)

		local temp = p1 
		while temp ~= target  do 
			ret:AddBounce(temp,-3)
			temp = temp + DIR_VECTORS[direction]
			if temp ~= target then
				ret:AddDelay(0.06)
			end
		end
		
		if doDamage then
			ret:AddDamage(damage)
			ret:AddDamage(SpaceDamage( target - DIR_VECTORS[direction] , self.SelfDamage))
		end
	
	end
	

	return ret
end

Brute_Beetle_A = Brute_Beetle:new{
		Damage = 3,
		SelfDamage = 2,
}

Brute_Beetle_B = Brute_Beetle:new{
		Damage = 3,
}

Brute_Beetle_AB = Brute_Beetle:new{
		Damage = 4,
		SelfDamage = 2,
}


---------------[[[[ Volatile  ]]]]----------------------
--------------  UnstableMech - Unstable Cannon  -----------------
Brute_Unstable = TankDefault:new{
		Damage = 3,
		Class = "Brute",
		Icon = "weapons/brute_unstable.png",
		Rarity = 1,
		Sound = "/general/combat/explode_small",
		Damage = 2,
		SelfDamage = 1,
		PushBack = 1,
		Push = 1,
		PowerCost = 1,
		Upgrades = 2,
		UpgradeCost = {1,3},
		LaunchSound = "/weapons/unstable_cannon",
		ImpactSound = "/impact/generic/explosion",
		TipImage = StandardTips.Ranged
}

Brute_Unstable_A = Brute_Unstable:new{
	Damage = 3,
	SelfDamage = 2,
}

Brute_Unstable_B = Brute_Unstable:new{
	Damage = 3,
}

Brute_Unstable_AB = Brute_Unstable:new{
	Damage = 4,
	SelfDamage = 2
}



------------------------------------------------------------------------------------------------
----------------------------------- BRUTE: POWER --------------------------------------------
------------------------------------------------------------------------------------------------


---------------[[[[ Power  ]]]]----------------------
--------------  Heavy Rocket   -----------------

Brute_Heavyrocket = 	{
	Range = RANGE_PROJECTILE,
	Class = "Brute",
	Icon = "weapons/brute_heavyrocket.png", 
	Rarity = 1,
	Explosion = "ExploAir2",
	Sound = "/general/combat/explode_small",
	Damage = 3,
	PowerCost = 1,
	Upgrades = 2,
	UpgradeCost = {1,2},
	Limited = 1,
	LaunchSound = "/weapons/heavy_rocket", 
	ImpactSound = "/impact/generic/explosion_large",
	TipImage = StandardTips.RangedAoe
}
			
Brute_Heavyrocket = Skill:new(Brute_Heavyrocket)

function Brute_Heavyrocket:GetTargetArea(point)
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		local curr = Point(point + DIR_VECTORS[dir])
		ret:push_back(curr)
		while not Board:IsBlocked(curr, PATH_PROJECTILE) do
			curr = curr + DIR_VECTORS[dir]
			ret:push_back(curr)
		end
	end
	
	return ret
end

function Brute_Heavyrocket:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	local target = GetProjectileEnd(p1,p2)  

	local damage = SpaceDamage(target, self.Damage)
	damage.sAnimation = self.Explosion-- "explopush1_"..direction
	ret:AddProjectile(damage,"effects/shot_heavyrocket")
	
	for i = 0, 2 do
		local dir = (direction - 1 + i)% 4.
		local damage = SpaceDamage(target + DIR_VECTORS[dir],0, dir)
		damage.sAnimation = PUSH_ANIMS[dir]
		ret:AddDamage(damage)
	end
	
	--ret.path = Board:GetSimplePath(p1, target)
	
	return ret
end


Brute_Heavyrocket_A = Brute_Heavyrocket:new{
		Limited = 2,
}

Brute_Heavyrocket_B = Brute_Heavyrocket:new{
		Damage = 5,
}

Brute_Heavyrocket_AB = Brute_Heavyrocket:new{
		Damage = 5,
		Limited = 2
}


---------------[[[[ Power  ]]]]----------------------
-------------- Splitshot  -----------------

	
Brute_Splitshot = TankDefault:new	{
		Class = "Brute",
		Icon = "weapons/brute_splitshot.png",
		Explosion = "ExploAir1",
		Sound = "/general/combat/explode_small",
		Damage = 2,
		Push = 1,
		PowerCost = 1,
		Limited = 1,
		Upgrades = 2,
		UpgradeCost = {1,2},
		--UpgradeList = { "+1 Use",  "+1 Damage"  },
		LaunchSound = "/weapons/modified_cannons",
		ImpactSound = "/impact/generic/explosion",
		TipImage = {
			Unit = Point(2,3),
			Enemy = Point(2,1),
			Enemy2 = Point(1,1),
			Enemy3 = Point(3,1),
			Target = Point(2,1)
		}
}
			
function Brute_Splitshot:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	
	local dir = GetDirection(p2 - p1)
	local target = GetProjectileEnd(p1,p2)  
	local damage = SpaceDamage(target, self.Damage, dir)
	
	damage.sAnimation = "explopush2_"..dir
	ret:AddProjectile(damage, self.ProjectileArt)
	--ret.path = Board:GetSimplePath(p1, target)
	
	damage = SpaceDamage(target+DIR_VECTORS[(dir-1)%4], self.Damage, (dir-1)%4)
	damage.sAnimation = "explopush2_"..((dir-1)%4)
	ret:AddDamage(damage)
	damage = SpaceDamage(target+DIR_VECTORS[(dir+1)%4], self.Damage, (dir+1)%4)
	damage.sAnimation = "explopush2_"..((dir+1)%4)
	ret:AddDamage(damage)
	
	
	
	return ret
end

Brute_Splitshot_A = Brute_Splitshot:new{
	Limited = 2,
}

Brute_Splitshot_B = Brute_Splitshot:new{
	Damage = 3,
}

Brute_Splitshot_AB = Brute_Splitshot:new{
	Limited = 2,
	Damage = 3
}



---------------[[[[ Power  ]]]]----------------------
--------------  Shockblast   -----------------

Brute_Shockblast = 	{
	Range = RANGE_PROJECTILE,
	Class = "Brute",
	Icon = "weapons/brute_shockblast.png", 
	ProjectileArt = "effects/shot_shockblast",
	Rarity = 1,
	Explosion = "explopush1_",
	Sound = "/general/combat/explode_small",
	Damage = 1,
	PowerCost = 2,
	Upgrades = 2,
	UpgradeCost = {1,2},
	LaunchSound = "/weapons/heavy_rocket", 
	ImpactSound = "/impact/generic/explosion_large",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,2)	
	}
}
			
Brute_Shockblast = Skill:new(Brute_Shockblast)

function Brute_Shockblast:GetTargetArea(point)
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		local curr = Point(point + DIR_VECTORS[dir])
		ret:push_back(curr)
		while not Board:IsBlocked(curr, PATH_PROJECTILE) do
			curr = curr + DIR_VECTORS[dir]
			ret:push_back(curr)
		end
	end
	
	return ret
end

function Brute_Shockblast:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local backdir = GetDirection(p1 - p2)
	
	local target = GetProjectileEnd(p1,p2)  

	local damage = SpaceDamage(target, self.Damage, backdir )
	damage.sAnimation = self.Explosion..backdir
	ret:AddProjectile(damage,self.ProjectileArt)
	
	local damage2 = SpaceDamage(target+DIR_VECTORS[dir], self.Damage, dir)
	damage2.sAnimation = self.Explosion..dir
	ret:AddDamage(damage2)
	
	return ret
end


Brute_Shockblast_A = Brute_Shockblast:new{
		Damage = 2,
}

Brute_Shockblast_B = Brute_Shockblast:new{
		Explosion = "explopush2_",
		Damage = 2,
}

Brute_Shockblast_AB = Brute_Shockblast:new{
		Explosion = "explopush2_",
		Damage = 3,
}




---------------[[[[ Primary  ]]]]----------------------
-------------- Bombing run -----------------

Brute_Bombrun = Brute_Jetmech:new{
	Class = "Brute",
	Icon = "weapons/brute_bombrun.png",
	Rarity = 3,
	AttackAnimation = "ExploRaining1",
	Sound = "/general/combat/stun_explode",
	MinMove = 2,
	Range = 8,
	Damage = 1,
	Damage2 = 2,
	Smoke = 0,
	AnimDelay = 0.1,
	Acid = 0,
	PowerCost = 1,
	DoubleAttack = 0, --does it attack again after stopping moving
	Limited = 1,
	Upgrades = 2,
	UpgradeCost = {1,3},
	LaunchSound = "/weapons/bomb_strafe",
	BombSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,0)
	}
}

Brute_Bombrun_A = Brute_Bombrun:new{
		Limited = 2,
}

Brute_Bombrun_B = Brute_Bombrun:new{
		Damage = 3,
}

Brute_Bombrun_AB = Brute_Bombrun:new{
		Damage = 3,
		Limited = 2,
}


---------------[[[[ Primary  ]]]]----------------------
------------------ Sniper Rifle ----------------------------

Brute_Sniper = TankDefault:new{
	Class = "Brute",
	Icon = "weapons/brute_sniper.png",
	PowerCost = 1,
	ProjectileArt = "effects/shot_sniper",
	Damage = 2, -- for tooltip
	Push = 1,
	MaxDamage = 2,
	MinDamage = 0,
	Upgrades = 2,
	Explosion = "",
	UpgradeCost = {1,1},
	LaunchSound = "/weapons/raining_volley",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(2,1)
	},
}

function Brute_Sniper:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	local counter = p1 + DIR_VECTORS[dir]
	local dist = 0
	
	local target = GetProjectileEnd(p1,p2,PATH_PROJECTILE)  
	
	while counter ~= target  and  dist ~= 8 do 
		dist = dist + 1
		counter = counter + DIR_VECTORS[dir]
	end
	
	
	local damage = SpaceDamage(target, math.min(self.MaxDamage, dist), dir)
	damage.sAnimation = "explopush1_"..dir
	ret:AddProjectile(damage, self.ProjectileArt, NO_DELAY)

	--ret.path = Board:GetSimplePath(p1, target)
	
	return ret
end




Brute_Sniper_A = Brute_Sniper:new{
	MaxDamage = 3,
	Damage = 3,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,0),
		Target = Point(2,1),
	},
}

Brute_Sniper_B = Brute_Sniper:new{
	MaxDamage = 3,
	Damage = 3,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,0),
		Target = Point(2,1),
	},
}
			
Brute_Sniper_AB = Brute_Sniper:new{
	MaxDamage = 4,
	Damage = 4,
	TipImage = {
		Unit = Point(2,5),
		Enemy = Point(2,0),
		Target = Point(2,1),
	},
}

------------------------------------------------------------------------------------------------
----------------------------------- BRUTE: UNUSED --------------------------------------------
------------------------------------------------------------------------------------------------

--[[

-------------- Brute - Trishot  -----------------

	
Brute_Trishot = TankDefault:new	{
		Name = "Tri-Shot",
		Class = "Brute",
		Description = "Shoot 3 projectiles that damage and push the targets.",
		Icon = "weapons/skill_default.png",
		Explosion = "ExploAir1",
		Sound = "/general/combat/explode_small",
		Damage = 1,
		SelfDamage = 1,
		Push = 1,
		PowerCost = 1,
		Upgrades = 2,
		UpgradeCost = {2,2},
		UpgradeList = { "+1 Damage",  "+1 Damage"  },
		LaunchSound = "/weapons/modified_cannons",
		ImpactSound = "/impact/generic/explosion",
		TipImage = {
			Unit = Point(2,3),
			Enemy = Point(2,1),
			Enemy2 = Point(1,3),
			Enemy3 = Point(3,3),
			Target = Point(2,1)
		}
}
			
function Brute_Trishot:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	
	local dir = GetDirection(p2 - p1)
	local target = GetProjectileEnd(p1,p2)  
	local damage = SpaceDamage(target, self.Damage, dir)
	ret:AddProjectile(damage, self.ProjectileArt)
	--ret.path = Board:GetSimplePath(p1, target)
	
	local dir2 = GetDirection(DIR_VECTORS[(dir+1)%4])
	local target2 = GetProjectileEnd(p1,p1+DIR_VECTORS[(dir+1)%4])  
	local damage2 = SpaceDamage(target2, self.Damage, dir2)
	ret:AddProjectile(damage2, self.ProjectileArt)
	
	local dir3 = GetDirection(DIR_VECTORS[(dir-1)%4])
	local target3 = GetProjectileEnd(p1,p1+DIR_VECTORS[(dir-1)%4])  
	local damage3 = SpaceDamage(target3, self.Damage, dir3)
	ret:AddProjectile(damage3, self.ProjectileArt)
	
	ret:AddDamage(SpaceDamage(p1, self.SelfDamage))
	
	return ret
end

Brute_Trishot_A = Brute_Trishot:new{
	Damage = 2,
	UpgradeDescription = "Increases damage by 1."
}

Brute_Trishot_B = Brute_Trishot:new{
	Damage = 2,
	UpgradeDescription = "Increases damage by 1."
}

Brute_Trishot_AB = Brute_Trishot:new{
	Damage = 3
}


----------
Brute_Tank = TankDefault:new {
			Name = "Stock Cannon",
			SkillName = "Shot",
			Range = RANGE_PROJECTILE,
			Class = "Brute",
			Description = "Shoot a powerful projectile",
			Icon = "weapons/brute_tank.png",
			Rarity = 1,
			Explosion = "ExploAir1",
			Sound = "/general/combat/explode_small",
			Damage = 1,
			Push = 1,
			PowerCost = 1,
			Upgrades = 2,
			UpgradeCost = {1,2},
			UpgradeList = { "+1 Damage",  "+1 Damage"  },
			LaunchSound = "/weapons/stock_cannons",
			ImpactSound = "/impact/generic/explosion"
		}
			
Brute_Tank_A = Brute_Tank:new{
		Damage = 1,
		UpgradeDescription = "Add 1 damage to the shot"
}

Brute_Tank_B = Brute_Tank:new{
		Damage = 1,
		UpgradeDescription = "Add 1 damage to the shot"
}

Brute_Tank_AB = Brute_Tank:new{
		Damage = 2
}

---------------------------------

Brute_Burst = Prime_Areablast:new{
	Name = "Area Push",
	Description = "Push all adjacent tiles back.",
	Icon = "weapons/brute_burst.png",
	Rarity = 1,
	PowerCost = 1,
	Damage = 0,
	UpgradeCost = { 2,2 },
	UpgradeList = { "+1 Damage",  "+1 Damage"  }
}

Brute_Burst_A = Brute_Burst:new{
		Damage = 1,
		UpgradeDescription = "Adds 1 damage"
}

Brute_Burst_B = Brute_Burst:new{
		Damage = 1,
		UpgradeDescription = "Adds 1 damage"
}

Brute_Burst_AB = Brute_Burst:new{
		Damage = 2
}

]]--