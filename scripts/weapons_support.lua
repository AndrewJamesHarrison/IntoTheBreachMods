

--[[   weapons within:

	"Support_Boosters",
	"Support_Smoke",
	"Support_Refrigerate",
		--
	"DeploySkill_SGenerator",
	"DeploySkill_Tank",
		--
	"Support_Force",
	"Support_SmokeDrop",
	"Support_Repair",
	"Support_Missiles"
	"Support_Wind"
	"Support_Blizzard"
	
	
 UNUSED
--Support_Rockwall

]]--


------------------------------------------------------------------------------------------------
----------------------------------- SUPPORT: GENERAL --------------------------------------------
------------------------------------------------------------------------------------------------

----

Support_Boosters = Leap_Attack:new{
	Class = "",
	Icon = "weapons/brute_boosters.png",	
	Rarity = 1,
	Range = 7,
	Cost = "med",
	PowerCost = 0, 
	Upgrades =0,
	Push = 1,
	SelfDamage = 0,
	LaunchSound = "/weapons/boosters",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Enemy2 = Point(3,2),
		Target = Point(2,2)
	}
}

-------

Support_Smoke = Brute_Jetmech:new{
	Class = "",
	Rarity = 1,
	Icon = "weapons/support_smoke.png",
	AttackAnimation = "",
	MinMove = 2,
	Range = 2,
	Damage = 0,
	Smoke = 1,
	Cost = "low",
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = {1,1},
	UpgradeList = { "+1 Range", "+1 Range" },
	LaunchSound = "/weapons/bomb_strafe",
	BombSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,1),
		Enemy = Point(2,2)
	}
}
					
Support_Smoke_A = Support_Smoke:new{
		Range = 3, 
		TipImage = {
			Unit = Point(2,3),
			Target = Point(2,0),
			Enemy = Point(2,2),
			Enemy2 = Point(2,1)
		}
}
				
Support_Smoke_B = Support_Smoke:new{
		Range = 3, 
		TipImage = {
			Unit = Point(2,3),
			Target = Point(2,0),
			Enemy = Point(2,2),
			Enemy2 = Point(2,1)
		}
}
			
Support_Smoke_AB = Support_Smoke:new{
		Range = 4,
		TipImage = {
			Unit = Point(2,4),
			Target = Point(2,0),
			Enemy = Point(2,2),
			Enemy2 = Point(2,1),
			Enemy3 = Point(2,3),
		}
}

-------------- Refrigerate ---------------------------

Support_Refrigerate = Skill:new{  
	Class = "",
	Icon = "weapons/support_refrigerate.png",
	Explosion = "",
	LaunchSound = "/weapons/refrigerate",
	Range = 1, -- Tooltip?
	PathSize = 1,
	Damage = 0,
	PowerCost = 1,
	Limited = 1,
	Upgrades = 1,
	UpgradeCost = {1},
	--UpgradeList = { "+1 Use" },
	TipImage = StandardTips.Melee
}
				
function Support_Refrigerate:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	damage = SpaceDamage(p2, 0)
	damage.iFrozen = 1
	ret:AddDamage(damage)
	
	damage = SpaceDamage(p1 - DIR_VECTORS[dir], 0)
	damage.iFire = 1
	ret:AddDamage(damage)
	
	return ret
end	

Support_Refrigerate_A = Support_Refrigerate:new{
		Limited = 2, 
}


-------------- Self Destruct ---------------------------

Support_Destruct = Skill:new{  
	Class = "",
	Icon = "weapons/support_destruct.png",
	Explosion = "explo_fire1",  --explo_fire1
	LaunchSound = "",
	Range = 1, 
	PathSize = 1,
	Damage = DAMAGE_DEATH,
	PowerCost = 0,
	Upgrades = 0,
	Limited = 1,
	TipImage = StandardTips.Surrounded
}
				
function Support_Destruct:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local damage = SpaceDamage(p1 , self.Damage)
	ret:AddDamage(damage)
	ret:AddBounce(p1, 3)
	
	for i = DIR_START,DIR_END do
		damage = SpaceDamage(p1 + DIR_VECTORS[i], self.Damage)
		--local direction = GetDirection(p1, p1 - DIR_VECTORS[i])
		damage.sSound = "/impact/generic/explosion"
		damage.sAnimation = "exploout2_"..i   --correct is exploout2_
		ret:AddDamage(damage)
		ret:AddBounce(p1 + DIR_VECTORS[i], 2)
	end
	
	return ret
end	


------------------------------------------------------------------------------------------------
----------------------------------- SUPPORT: GLOBAL --------------------------------------------
------------------------------------------------------------------------------------------------

-----------------FORCE -----------------

Support_Force = Grenade_Base:new{  
	Icon = "weapons/structure_force.png",
	Rarity = 1,
	PowerCost = 0, 
	DamageInner = 1,
	Damage = 1,
	InnerAnimation = "ExploArt2",
	LaunchSound = "/weapons/bomber_run",
	Limited = 1,
	TipImage = {
		Unit = Point(5,3),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Target = Point(2, 2)
	}
}	

function Support_Force:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	ret:AddSound("/weapons/airstrike")
	ret:AddAirstrike(p2,"units/mission/bomber_1.png")
	local dam = SpaceDamage(p2,self.Damage)
	dam.sAnimation = "ExploArt2"
	dam.sSound = "/impact/generic/explosion_large"
	ret:AddDamage(dam)
	ret:AddBounce(p2, 2)
	
	for i = DIR_START, DIR_END do
		dam = SpaceDamage(p2 + DIR_VECTORS[i],0,i)
		dam.sAnimation = PUSH_ANIMS[i]
		ret:AddDamage(dam)
	end
	
	return ret
end				


-----------------Support Smoke Drop -----------------

Support_SmokeDrop = Grenade_Base:new{  
	Icon = "weapons/support_smokedrop.png",
	Explosion = "",
	PowerCost = 0, 
	InnerAnimation = "explo_fire1",
	LaunchSound = "/weapons/bomber_run",
	Limited = 1,
	TipImage = StandardTips.RangedAoe
}	

function Support_SmokeDrop:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	ret:AddSound("/weapons/airstrike")
	ret:AddAirstrike(p2,"units/mission/drone_1.png")
	
	local damage = SpaceDamage(p2,0)
	damage.iSmoke = 1
	ret:AddDamage(damage)
	
	for i = DIR_START, DIR_END do
		damage = SpaceDamage(p2 + DIR_VECTORS[i],0)
		damage.iSmoke = 1
		ret:AddDamage(damage)
	end
	
	return ret
end				



---------------[[[[ Support - Global  ]]]]----------------------
--------------  Repair   -----------------

Support_Repair = Skill:new{
	Icon = "weapons/support_repair.png",
	Power = 1,
	Limited = 1,
	CustomTipImage = "Support_Repair_Tooltip",
}

function Support_Repair:GetTargetArea(point)
	local ret = PointList()
	
	local board_size = Board:GetSize()
	for i = 0, board_size.x - 1 do
		for j = 0, board_size.y - 1  do
			if Board:IsPawnTeam(Point(i,j),TEAM_PLAYER) then
				ret:push_back(Point(i,j))
			end
		end
	end
	
	return ret
end
				
function Support_Repair:GetSkillEffect(p1, p2)
	local targets = Support_Repair:GetTargetArea(point)
	
	local ret = SkillEffect()
		
	for i = 1, targets:size() do
		ret:AddSound("/weapons/airstrike")
		ret:AddAirstrike(targets:index(i),"units/mission/drone_1.png")
		ret:AddDamage(SpaceDamage(targets:index(i),-10))
	end
	
	return ret
end

Support_Repair_Tooltip = SelfTarget:new{ 
	Amount = -1, 
	Name = "Mech Repair",
	Description = "Repair 1 damage and remove Fire, Ice, or Acid",
	Upgrades = 1,
	UpgradeCost = {1},
	TipImage = {
		Unit_Damaged = Point(2,3),
		Target = Point(2,3),
		--Fire = Point(2,2),
		Friendly_Damaged = Point(1,1),
		--Fire2 = Point(2,3),
		Friendly2_Damaged = Point(2,1),
		--Fire3 = Point(3,1),
		Length = 5,
	}
}

function Support_Repair_Tooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	--damage = SpaceDamage(Point(2,2),2)
	--damage.bHide = true
	--ret:AddDamage(damage)
	--ret:AddDelay(1.5)
	
	local damage = SpaceDamage(Point(2,3),-10)
	damage.iFire = EFFECT_REMOVE
	ret:AddDamage(damage)
	
	damage = SpaceDamage(Point(1,1),-10)
	damage.iFire = EFFECT_REMOVE
	ret:AddDamage(damage)
	
	damage = SpaceDamage(Point(2,1),-10)
	damage.iFire = EFFECT_REMOVE
	ret:AddDamage(damage)
	
	return ret
end



---------------[[[[ Support - Global  ]]]]----------------------
--------------  Missile Barrage    -----------------

Support_Missiles = Skill:new{
		Class = "",
		Icon = "weapons/support_missiles.png",
		UpShot = "effects/shotup_missileswarm.png",
		PowerCost = 1,
		Damage = 1,
		Limited = 1,
		Upgrades = 1,
		UpgradeList = { "+1 Damage" },
		ImpactSound = "/impact/generic/explosion",
		UpgradeCost = { 2 },
		TipImage = {
			Unit = Point(2,2),
			Enemy = Point(1,2),
			Enemy2 = Point(4,2),
			Enemy3 = Point(3,3),
			Enemy4 = Point(3,1),
			Enemy5 = Point(0,1),
			Target = Point(1,2)
		}
}

function Support_Missiles:GetTargetArea(point)
	local ret = PointList()
	
	local board_size = Board:GetSize()
	for i = 0, board_size.x - 1 do
		for j = 0, board_size.y - 1  do
			if Board:IsPawnTeam(Point(i,j),TEAM_ENEMY) then
				ret:push_back(Point(i,j))
			end
		end
	end
	
	return ret
end
				
function Support_Missiles:GetSkillEffect(p1, p2)
	local targets = Support_Missiles:GetTargetArea(point)
	
	local ret = SkillEffect()
	
	for i = 1, targets:size() do
		--ret:AddSound("/weapons/airstrike")
		--ret:AddAirstrike(targets:index(i),"units/mission/drone_1.png")
		--ret:AddDamage(SpaceDamage(targets:index(i), 1))
		ret:AddSound("/weapons/artillery_volley")
		local damage = SpaceDamage(targets:index(i), self.Damage)
		damage.sAnimation = "ExploAir1"
		damage.bHidePath = true
		ret:AddArtillery(damage,self.UpShot, 0.1) --,NO_DELAY
	end
	
	return ret
end

Support_Missiles_A = Support_Missiles:new{
	Damage = 2,
}


---------------[[[[ Support - Global  ]]]]----------------------
--------------  Storm Surge    -----------------

Support_Wind = Skill:new{
	Class = "",
	Icon = "weapons/support_wind.png",
	UpShot = "effects/shotup_swarm.png",
	Damage = 0,
	PathSize = 1,
	PowerCost = 1,
	Limited = 1,
	Upgrades = 1,
	UpgradeCost = { 1 },
	LaunchSound = "/weapons/wind",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(3,2),
		Enemy3 = Point(0,2),
		Mountain = Point(3,1),
		Friendly = Point(1,2),
		Target = Point(3,2),
		
	}
}

function Support_Wind:GetTargetArea(point)

	local ret = PointList()
	
	ret:push_back(Point(1,3))
	ret:push_back(Point(1,4))
	ret:push_back(Point(2,3))
	ret:push_back(Point(2,4))
	
	ret:push_back(Point(5,3))
	ret:push_back(Point(5,4))
	ret:push_back(Point(6,3))
	ret:push_back(Point(6,4))
	
	ret:push_back(Point(3,1))
	ret:push_back(Point(3,2))
	ret:push_back(Point(4,1))
	ret:push_back(Point(4,2))
	
	ret:push_back(Point(3,5))
	ret:push_back(Point(3,6))
	ret:push_back(Point(4,5))
	ret:push_back(Point(4,6))
	
	return ret
end
	
function Support_Wind:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = DIR_NONE
	
	if p2.x == 1 or p2.x == 2 then dir = DIR_LEFT
	elseif p2.x == 5 or p2.x == 6 then dir = DIR_RIGHT
	elseif p2.y == 1 or p2.y == 2 then dir = DIR_UP
	elseif p2.y == 5 or p2.y == 6 then dir = DIR_DOWN end
	
	
	ret:AddEmitter(Point(3,3),"Emitter_Wind_"..dir)
	ret:AddEmitter(Point(4,4),"Emitter_Wind_"..dir)
	local board_size = Board:GetSize()
	for i = 0, 7 do
		for j = 0, 7  do
			local point = Point(i,j) -- DIR_LEFT
			if dir == DIR_RIGHT then
				point = Point(7 - i, j)
			elseif dir == DIR_UP then
				point = Point(j,i)
			elseif dir == DIR_DOWN then
				point = Point(j,7-i)
			end
			
			if Board:IsPawnSpace(point) then
				ret:AddDamage(SpaceDamage(point, 0, dir))
				ret:AddDelay(0.2)
			end
		end
	end
	
	return ret
	
end

Support_Wind_A = Support_Wind:new{
	Limited = 0,
}


---------------[[[[ Power  ]]]]----------------------
----------- Local Blizzard ------------------------
Support_Blizzard = Science_LocalShield:new{  
	Class = "",
	Icon = "weapons/support_blizzard.png",
	Explosion = "",
	Damage = 0,
	PathSize = 1,
	PowerCost = 2,
	IceVersion = 1,
	WideArea = 1,
	Push = 1,--TOOLTIP HELPER,
	Range = 1,--TOOLTIP HELPER
	Limited = 1,
	Upgrades = 2,
	UpgradeCost = { 1,2 },
	UpgradeList = { "+1 Size",  "+1 Size"  },
	LaunchSound = "/weapons/blizzard",
}

Support_Blizzard_A = Support_Blizzard:new{
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

Support_Blizzard_B = Support_Blizzard:new{
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

Support_Blizzard_AB = Support_Blizzard:new{
		WideArea = 3,
		TipImage = {
			Unit = Point(2,2),
			Target = Point(2,1),
			Friendly = Point(2,3),
			Friendly2 = Point(3,2),
			Friendly2 = Point(4,2),
			Building = Point(2,1),
			Building1 = Point(1,1),
			Building2 = Point(0,1),
			Building3 = Point(4,3),
			Enemy = Point(1,2)
		}
}

--[[
-------------------------------
--*************UNUSED************
---------------------------------

-- NEED TO REMOVE
Support_Rockwall = {
	Name = "Rock Wall",
	Description = "Throw three rocks in a horizontal line.",
	Icon = "weapons/prime_rockwall.png",
	Explosion = "",
	ArtilleryStart = 1,
	ArtillerySize = 8,
	Damage = 2,
	Range = RANGE_ARTILLERY,--TOOLTIP HELPER
	FriendlyDamage = true,
	RowSize = 3,
	PowerCost = 1,  
	Upgrades = 2,
	UpgradeCost = { 1,1 },
	UpgradeList = { "+2 Width", "+2 Width" },
	Limited = 1,
	Tags = { "Rock Weapon" },
	LaunchSound = "/weapons/rockwall"
}
		
Support_Rockwall = LineArtillery:new(Support_Rockwall)

function Support_Rockwall:GetRockDamage(target)
	local damage = SpaceDamage(target)
	if not Board:IsBlocked(target, PATH_PROJECTILE) then
		damage.iDamage = 0
		damage.sPawn = "Wall"
	 
	elseif self.FriendlyDamage or not Board:IsPawnTeam(target, TEAM_PLAYER) then
		damage.iDamage = self.Damage
		damage.sAnimation = "rock1d" 
	end 
	return damage
end

function Support_Rockwall:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	ret:AddArtillery(self:GetRockDamage(p2), "effects/shotup_rock.png")
	ret:AddDamage(self:GetRockDamage(p2 + DIR_VECTORS[(dir + 1) % 4]))
	ret:AddDamage(self:GetRockDamage(p2 - DIR_VECTORS[(dir + 1) % 4]))

	if self.RowSize >= 5 then
		ret:AddDamage(self:GetRockDamage(p2 + DIR_VECTORS[(dir + 1) % 4]*2))
		ret:AddDamage(self:GetRockDamage(p2 - DIR_VECTORS[(dir + 1) % 4]*2))
	end
	
	if self.RowSize >= 7 then
		ret:AddDamage(self:GetRockDamage(p2 + DIR_VECTORS[(dir + 1) % 4]*3))
		ret:AddDamage(self:GetRockDamage(p2 - DIR_VECTORS[(dir + 1) % 4]*3))
	end
	
	return ret
end
	
Support_Rockwall_A = Support_Rockwall:new{
		RowSize = 5,
		UpgradeDescription = "Increases width of wall by 2."
}

Support_Rockwall_B = Support_Rockwall:new{
		RowSize = 5,
		UpgradeDescription = "Increases width of wall by 2."
}

Support_Rockwall_AB = Support_Rockwall:new{
		RowSize = 7,
}



-----------------------
]]--