
--Note: *ANY* variable (Name / Cost / etc.) can be replaced by a function
--by defining it as Get<name>

--------------------------------------------------
----------------WEAPON SKILLS---------------------
--------------------------------------------------

--local ret = PointList()
--LOG(ret:size()) -- would print 0 since nothing is in it
--ret:push_back(Point(0,0)) -- adds (0,0) to the list
--LOG(ret:size()) -- would print 1 now
--LOG(ret:index(1)) 
--LOG(ret:index(ret:size()) 
--ret:push_back(Point(10,10))

--PointLists are readonly -- no way to manipulate the data once its in the list
--Use extract_table to pull out a standard lua table from a pointlist

---<<<< Default members of Skill -----------------------

--CornersAllowed = false,
--PathSize = INT_MAX,
--Explosion = "ExploAir2",
--Name = "Default",
--Description = "No Desc",

---- SkillEffect API ----------------------

--PointList path
--PointList move

--void AddDamage(SpaceDamage damage);
--void AddQueuedDamage(SpaceDamage damage);
--SpaceDamage& GetDamage(int index);



---- PointList API ----------------------------

--int size()
--Point index(int i)
--void push_back(Point p)
--Point back()

--<<<-----------------------------


------------------------------------------------------
-------------- Targeting Helper Functions  -----------
------------------------------------------------------

--This gets the target for if a shot hits the first object (like the turret)
function GetProjectileEnd(p1,p2,profile)
	profile = profile or PATH_PROJECTILE
	local direction = GetDirection(p2 - p1)
	local target = p1 + DIR_VECTORS[direction]

	while not Board:IsBlocked(target, profile) do
		target = target + DIR_VECTORS[direction]
	end

	if not Board:IsValid(target) then
		target = target - DIR_VECTORS[direction]
	end
	
	return target
end

function general_SquareTarget(center, size)

	local ret = PointList()
	
	local corner = center - Point(size, size)
	local p = Point(corner)
		
	for i = 0, ((size*2+1)*(size*2+1)) do
		if Board:IsValid(p) then
			ret:push_back(p)
		end
		p = p + VEC_RIGHT
		if math.abs(p.x - corner.x) == (size*2+1) then
			p.x = p.x - (size*2+1)
			p = p + VEC_DOWN
		end
	end
	
	return ret

end

function general_DiamondTarget(center, size)

	local ret = PointList()
	
	local corner = center - Point(size, size)
	
	local p = Point(corner)
		
	for i = 0, ((size*2+1)*(size*2+1)) do
		local diff = center - p
		local dist = math.abs(diff.x) + math.abs(diff.y)
		if Board:IsValid(p) and dist <= size then
			ret:push_back(p)
		end
		p = p + VEC_RIGHT
		if math.abs(p.x - corner.x) == (size*2+1) then
			p.x = p.x - (size*2+1)
			p = p + VEC_DOWN
		end
	end
	
	return ret
	
end

----------------------------------------------------
------------MORE HELPER FUNCTIONS------------------


function getUnoccupiedSpaces(count, point, size)
	local choices = {}
	point = point or Point(0,0)
	size = size or Board:GetSize()
	for i = point.x, point.x + size.x - 1 do
		for j = point.y, point.x + size.y - 1  do
			if not Board:IsBlocked(Point(i,j),PATH_GROUND) then
				choices[#choices+1] = Point(i,j)
			end
		end
	end
	
	local ret = {}
	while count > 0 and #choices > 0 do
		ret[#ret] = random_removal(choices)
		count = count - 1
	end
	
	return ret
end

------------------------------------------------------
-------------- MOVE SKILLS ---------------------------
------------------------------------------------------

Move =  {

}
		
Move = Skill:new(Move)

function Move:GetDescription() 
	return "Move " .. Pawn:GetMoveSpeed() .. " spaces"
end
		
function Move:GetTargetArea(point)
	return Board:GetReachable(point, Pawn:GetMoveSpeed(), Pawn:GetPathProf())
end

function Move:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	if Pawn:IsJumper() then
		ret:AddLeap(p1,p2,FULL_DELAY)
	elseif Pawn:IsTeleporter() then
		ret:AddTeleport(p1,p2,FULL_DELAY)
	else
		ret:AddMove(Board:GetPath(p1, p2, Pawn:GetPathProf()), FULL_DELAY)
	end
	
	return ret
end


------------------------------------------------------
-------------- BASIC ATTACKS ---------------------------
------------------------------------------------------


--<<<------------------------------

PunchValues = {
			PathSize = 1,
			Description = "Melee attack",
			Damage = 3
		}

Punch = Skill:new(PunchValues) 

function Punch:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	ret:AddDamage(SpaceDamage(p2,self.Damage,direction))
	return ret
end	
	
----------------------

SelfTarget =	{
					Name = "INVALID",
					Explosion = ""
				}

SelfTarget = Skill:new(SelfTarget)
				
function SelfTarget:GetTargetArea(point)
	local ret = PointList()
	ret:push_back(point)
	return ret
end

function SelfTarget:GetTargetScore(p1,p2)
	return 10
end

-------------------------------

Leap_Attack = Skill:new{
	Range = 2,
	Damage = 0,
	SelfDamage = 0,
	SelfAnimation = "ExploAir1",
	BuildingDamage = true,
	Push = 0,
	PushAnimation = 0 -- 0 = airpush; 1 = explopush1; 2 = explopush2

}

function Leap_Attack:GetTargetArea(point)
	local ret = PointList()
	
	for i = DIR_START, DIR_END do
		for k = 1, self.Range do
			local curr = DIR_VECTORS[i]*k + point
			if Board:IsValid(curr) and not Board:IsBlocked(curr, Pawn:GetPathProf()) then
				ret:push_back(DIR_VECTORS[i]*k + point)
			end
		end
	end
	
	return ret
end

function Leap_Attack:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	local move = PointList()
	move:push_back(p1)
	move:push_back(p2)
	ret:AddBurst(p1,"Emitter_Burst_$tile",DIR_NONE)
	ret:AddLeap(move, FULL_DELAY)
	ret:AddBurst(p2,"Emitter_Burst_$tile",DIR_NONE)
	
	local backwards = (dir + 2) % 4
	for i = DIR_START, DIR_END do
		if p1:Manhattan(p2) ~= 1 or i ~= backwards then
			local dam = SpaceDamage(p2 + DIR_VECTORS[i], self.Damage)
			if self.Push == 1 then dam.iPush = i end
			dam.sAnimation = PUSH_ANIMS[i]
			if self.PushAnimation == 1 then dam.sAnimation = PUSHEXPLO1_ANIMS[i]   --JUSTIN ADDED
			elseif self.PushAnimation == 2 then dam.sAnimation = PUSHEXPLO2_ANIMS[i] end
			
			if not self.BuildingDamage and Board:IsBuilding(p2 + DIR_VECTORS[i]) then		-- Target Buildings - 
				dam.iDamage = 0
			end
			ret:AddDamage(dam)
		end
	end

	local damage = SpaceDamage(p2, self.SelfDamage)
	damage.sAnimation = self.SelfAnimation
	if self.SelfDamage ~= 0 then ret:AddDamage(damage) end
	ret:AddBounce(p2,3)
	
	return ret
	
end

--------------------------------

LineArtillery = {
	Name = "INVALID",
	ArtillerySize = 8,
	Explosion = "ExploArt2",
	OnlyEmpty = false,
	Range = RANGE_ARTILLERY
}

LineArtillery = Skill:new(LineArtillery)
				
function LineArtillery:GetTargetArea(point)
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		for i = 2, self.ArtillerySize do
			local curr = Point(point + DIR_VECTORS[dir] * i)
			if not Board:IsValid(curr) then
				break
			end
			
			if not self.OnlyEmpty or not Board:IsBlocked(curr,PATH_GROUND) then
				ret:push_back(curr)
			end

		end
	end
	
	return ret
end

----------------------------------

Artillery =	{
				Name = "INVALID",
				ArtillerySize = 4,
				Explosion = "ExploArt2"
			}

Artillery = Skill:new(Artillery)
				
function Artillery:GetTargetArea(point)
	return general_DiamondTarget(point, self.ArtillerySize)
end

-----<<<-----------------------------------

Deployable = LineArtillery:new{
	Explosion = "",
	Deployed = "TBA",
	Projectile = "TBA",
	Limited = 1,
	OnlyEmpty = true,
	Class = "",
}

function Deployable:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()	
	local damage = SpaceDamage(p2,0)
	damage.sPawn = self.Deployed
	ret:AddArtillery(damage,self.Projectile)
	return ret
end		



------------------------------------------


ArtilleryDefault = 	{
			Range = RANGE_ARTILLERY,	
			UpShot = "effects/shot_artimech.png",
			ArtilleryStart = 2,
			ArtillerySize = 8,
			BounceAmount = 3,
			BounceOuterAmount = 0,  --REMOVED BECAUSE CAUSES RENDER ORDER ISSUE IF PUSHING UNITS DOWN/LEFT
			BuildingDamage = true,
			Push = 1,
			DamageOuter = 0,
			DamageCenter = 1,
			Damage = 1,---USED FOR TOOLTIPS
			Explosion = "",
			ExplosionCenter = "ExploArt1",
			ExplosionOuter = "",
			OuterAnimation = "airpush_",
}
			
ArtilleryDefault = LineArtillery:new(ArtilleryDefault)

function ArtilleryDefault:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	
	local damage = SpaceDamage(p2,self.DamageCenter)
	damage.sAnimation = self.ExplosionCenter
	
	if not self.BuildingDamage and Board:IsBuilding(p2) then		-- Target Buildings - 
		damage.iDamage = DAMAGE_ZERO
	end
	
	ret:AddBounce(p1, 1)
	ret:AddArtillery(damage, self.UpShot)
	
	if self.BounceAmount ~= 0 then	ret:AddBounce(p2, self.BounceAmount) end
	
	for dir = 0, 3 do
		damage = SpaceDamage(p2 + DIR_VECTORS[dir],  self.DamageOuter)
		
		if self.Push == 1 then
			damage.iPush = dir
		end
		damage.sAnimation = self.OuterAnimation..dir
		--[[
		if self.ExplosionOuter == "" then
			damage.sAnimation = "airpush_"..dir
		elseif self.ExplosionOuter == 1 then
			damage.sAnimation = "explopush1_"..dir
		end]]
		
		if not self.BuildingDamage and Board:IsBuilding(p2 + DIR_VECTORS[dir]) then	
			damage.iDamage = 0
			damage.sAnimation = "airpush_"..dir
		end
		
		ret:AddDamage(damage)
		if self.BounceOuterAmount ~= 0 then	ret:AddBounce(p2 + DIR_VECTORS[dir], self.BounceOuterAmount) end  
	end

	return ret
end		

------------------------------------------


TankDefault = 	{
			Range = RANGE_PROJECTILE,
			PathSize = INT_MAX,
			Name = "TBA",
			Description = "TBA",
			Explo = "explopush1_",
			Class = "",
			Damage = 1,
			PushBack = 0,
			BackShot = 0,
			ProjectileArt = "effects/shot_mechtank",
			Push = 1,
			Freeze = 0,
			Acid = 0,
			Flip = 0,
			Shield = 0,
			Phase = false,
			PhaseShield = false,
		}
			
TankDefault = Skill:new(TankDefault)

function TankDefault:GetTargetArea(p1)

	if not self.Phase then
		return Board:GetSimpleReachable(p1, self.PathSize, self.CornersAllowed)
	else
		local ret = PointList()
	
		for dir = DIR_START, DIR_END do
			for i = 1, 8 do
				local curr = Point(p1 + DIR_VECTORS[dir] * i)
				if not Board:IsValid(curr) then
					break
				end
				
				ret:push_back(curr)
				
				if Board:IsBlocked(curr,PATH_PHASING) then
					break
				end
			end
		end
	
	return ret
	
	end
end

function TankDefault:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)

	if self.PushBack == 1 then
		local selfDam = SpaceDamage(p1, self.SelfDamage, GetDirection(p1 - p2))
		ret:AddDamage(selfDam)
	end

	local pathing = self.Phase and PATH_PHASING or PATH_PROJECTILE
	local target = GetProjectileEnd(p1,p2,pathing)  
	
	local damage = SpaceDamage(target, self.Damage)
	if self.Flip == 1 then
		damage = SpaceDamage(target,self.Damage,DIR_FLIP)
	end
	if self.Push == 1 then
		damage.iPush = direction
	end
	damage.iAcid = self.Acid
	damage.iFrozen = self.Freeze
	damage.iShield = self.Shield
	damage.sAnimation = self.Explo..direction
	ret:AddProjectile(damage, self.ProjectileArt, NO_DELAY)--"effects/shot_mechtank")
	
	--ret.path = Board:GetSimplePath(p1, target)
	
	if self.BackShot == 1 then
		local backdir = GetDirection(p1 - p2)
		local target2 = GetProjectileEnd(p1,p1 + DIR_VECTORS[backdir])

		if target2 ~= p1 then
			damage = SpaceDamage(target2, self.Damage, backdir)
			damage.sAnimation = self.Explo..backdir
			ret:AddProjectile(damage,self.ProjectileArt)
		end
	end
	
	if self.PhaseShield then
		local temp = p1 + DIR_VECTORS[direction]
		while temp ~= target do
			if Board:IsBuilding(temp) then
				damage = SpaceDamage(temp, 0)
				damage.iShield = 1
				ret:AddDamage(damage)
			end
			
			temp = temp + DIR_VECTORS[direction]
		end
	
	end
	
	return ret
end


----------------------

Civilian_Primary = TankDefault:new
	{
		Damage= 0, 
		Description = "PROJECTILE that pushes the target", 
	}
	

----------------------

Laser_Base = Skill:new{
	Damage = 3,
	MinDamage = 1,
	PowerCost = 1,
	Smoke = 0,
	Acid = 0,
	Fire = 0,
	Freeze = 0,
	FriendlyDamage = true,
	LaserAnimation = "ExploAir1",
	LaserArt = "effects/laser1",
	LaunchSound = "/weapons/burst_beam"
}

function Laser_Base:GetTargetArea(point)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		local curr = point + DIR_VECTORS[dir]
		while Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and not Board:IsBuilding(curr) and Board:IsValid(curr) do
			ret:push_back(curr)
			curr = curr + DIR_VECTORS[dir]
		end
		
		if Board:IsValid(curr) then
			ret:push_back(curr)
		end
	end
	
	return ret
end

function Laser_Base:AddQueuedLaser(ret,point,direction)
	self:AddLaser(ret,point,direction,true)
end

function Laser_Base:AddLaser(ret,point,direction,queued)
	local queued = queued or false
	local minDamage = self.MinDamage or 1
	local damage = self.Damage
	while Board:IsValid(point) do
	
		local temp_damage = damage  --This is so that if damage is set to 0 because of an ally, it doesn't affect the damage calculation of the laser.
		
		if not self.FriendlyDamage and Board:IsPawnTeam(point, TEAM_PLAYER) then
			temp_damage = DAMAGE_ZERO
		end
		
		local dam = SpaceDamage(point, temp_damage)
		
		dam.iSmoke = self.Smoke
		dam.iAcid = self.Acid
		dam.iFire = self.Fire
		dam.iFrozen = self.Freeze
		
		-- if it's the end of the line (ha), add the laser art -- not pretty
		if Board:IsBuilding(point) or Board:GetTerrain(point) == TERRAIN_MOUNTAIN or not Board:IsValid(point + DIR_VECTORS[direction]) then
			if queued then 
				ret:AddQueuedProjectile(dam,self.LaserArt)
			else
				ret:AddProjectile(dam,self.LaserArt)
			end
			break
		else
			if queued then
				ret:AddQueuedDamage(dam)  
			else
				ret:AddDamage(dam)   --JUSTIN TEST
			end
		end
		
		damage = damage - 1
		if damage < minDamage then damage = minDamage end
					
		point = point + DIR_VECTORS[direction]	
	end
end

------
LaserDefault = Laser_Base:new{
			Explosion = "",
			Sound = "",
			Damage = 3,
			PowerCost = 1,
			MinDamage = 1,
			FriendlyDamage = true,
		}
			
function LaserDefault:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local target = p1 + DIR_VECTORS[direction]
	
	self:AddLaser(ret, target, direction)
	
	return ret
end


-------------- GRENADE SKILLS ---------------------------

Grenade_Base = Artillery:new{
				Explosion = "",
				DamageInner = 0,
				DamageOuter = 0,
				PushOuter = 1,
				FireInner = 0,
				FireOuter = 0,
				SmokeInner = 0,
				ShieldInner = 0,
				ShieldOuter = 0,
				ArtillerySize = 15,--3
				InnerAnimation = "PulseBlast",
				OuterAnimation = ""
				}

function Grenade_Base:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	
	local damage = SpaceDamage(p2,self.DamageInner)
	if self.FireInner == 1 then
		damage.iFire = EFFECT_CREATE
	end
	if self.SmokeInner == 1 then
		damage.iSmoke = 1
	end
	if self.ShieldInner == 1 then
		damage.iShield = 1
	end
	damage.sAnimation = self.InnerAnimation
	ret:AddDamage(damage)
	
	local damU
	local damR
	local damD
	local damL
	
	if self.PushOuter == 1 then
		 damU = SpaceDamage(p2 + DIR_VECTORS[DIR_UP], self.DamageOuter, DIR_UP)
		damU.sAnimation = "airpush_U"

		 damR = SpaceDamage(p2 + DIR_VECTORS[DIR_RIGHT], self.DamageOuter, DIR_RIGHT)
		damR.sAnimation = "airpush_R"
		
		 damD = SpaceDamage(p2 + DIR_VECTORS[DIR_DOWN], self.DamageOuter, DIR_DOWN)
		damD.sAnimation = "airpush_D"
		
		 damL = SpaceDamage(p2 + DIR_VECTORS[DIR_LEFT], self.DamageOuter, DIR_LEFT)
		damL.sAnimation = "airpush_L"
	else
		 damU = SpaceDamage(p2 + DIR_VECTORS[DIR_UP], self.DamageOuter )
		 damR = SpaceDamage(p2 + DIR_VECTORS[DIR_RIGHT], self.DamageOuter )
		 damD = SpaceDamage(p2 + DIR_VECTORS[DIR_DOWN], self.DamageOuter )
		 damL = SpaceDamage(p2 + DIR_VECTORS[DIR_LEFT], self.DamageOuter )
	end
	
	if self.FireOuter == 1 then
		damU.iFire = EFFECT_CREATE
		damR.iFire = EFFECT_CREATE
		damD.iFire = EFFECT_CREATE
		damL.iFire = EFFECT_CREATE
	end
	if self.SmokeOuter == 1 then
		damU.iSmoke = 1
		damR.iSmoke = 1
		damD.iSmoke = 1
		damL.iSmoke = 1
	end
	if self.ShieldOuter == 1 then
		damU.iShield = 1
		damR.iShield = 1
		damD.iShield = 1
		damL.iShield = 1
	end
	ret:AddDamage(damU)
	ret:AddDamage(damR)
	ret:AddDamage(damD)
	ret:AddDamage(damL)
	
	return ret
end


----------------------


Grenade_Force = Grenade_Base:new{  
				InnerAnimation = "explo_fire1",
				DamageInner = 1,
				Limited = 1,
				PowerCost = 1,
				Upgrades = 2,
				UpgradeCost = { 1,1 },
				UpgradeList = { "+1 Use",  "+1 Damage"  },
			}
Grenade_Force_A = Grenade_Force:new{ 
			Limited = 2,
			UpgradeDescription = "Increases uses by 1."
			}
Grenade_Force_B = Grenade_Force:new{
			DamageInner = 2,
			UpgradeDescription = "Add fire to the center tile."
			}
Grenade_Force_AB = Grenade_Force:new{
			Limited = 2,
			DamageInner = 2
			}


------------------------------------------------------
-------------- BASE ENEMY SKILLS ---------------------------
------------------------------------------------------

EggHatch = SelfTarget:new{}

function EggHatch:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(p1,3)
	damage.sPawn = "Mantis1"
	ret:AddQueuedDamage(damage)
	return ret
end

------------------------------------------------------

Skill_Repair = SelfTarget:new{ 
	Amount = -1, 
	Upgrades = 2,
	UpgradeCost = {1,1},
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		Fire = Point(2,2)
	}
}

function Skill_Repair:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(p2,self.Amount)
	damage.iFire = EFFECT_REMOVE
	damage.iAcid = EFFECT_REMOVE
	
	if self.Pulse then
		damage.sAnimation = "ExploRepulse1"
	end
	
	ret:AddDamage(damage)
	
	if IsPassiveSkill("Mass_Repair") then
		local mechs = extract_table(Board:GetPawns(TEAM_MECH))
		for i,id in pairs(mechs) do
			if Board:GetPawnSpace(id) ~= p2 then
				damage.loc = Board:GetPawnSpace(id)
				ret:AddDamage(damage)
			end
		end
	end	
	
	if self.Pulse then
		for i = DIR_START,DIR_END do
			local curr = p1 + DIR_VECTORS[i]
			local spaceDamage = SpaceDamage(curr, 0, i)	
			spaceDamage.sAnimation = "airpush_"..i
			ret:AddDamage(spaceDamage)
		end
	end
	
	return ret
end

Skill_Repair_A = Skill_Repair:new{ Amount = -20}

function Skill_Repair_A:GetTargetArea(p1,p2)
	local ret = PointList()
	ret:push_back(p1)
	for dir = DIR_START, DIR_END do
		ret:push_back(p1 + DIR_VECTORS[dir])
	end
	return ret
end

Skill_Repair_Power = Skill_Repair:new{
	Pulse = true,
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		Enemy = Point(2,1),
		Fire = Point(2,2)
	}
}

Skill_Repair_Punch = Skill:new{  
	LaunchSound = "/weapons/titan_fist",
	PathSize = 1,
	Damage = 2,
	TipImage = StandardTips.Melee
}
				
function Skill_Repair_Punch:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	local ice_repair = SpaceDamage(p1,0)
	ice_repair.iFrozen = EFFECT_REMOVE
	ret:AddDamage(ice_repair)
	
	local damage = SpaceDamage(p2,self.Damage,direction)
	damage.sAnimation = "SwipeClaw2"
	ret:AddMelee(p2 - DIR_VECTORS[direction], damage)
	return ret
end	


--[[Skill_RepairTooltip = SelfTarget:new{ 
	Amount = -1, 
	Name = "Mech Repair",
	Description = "Repair 1 damage and remove Fire, Ice, or Acid",
	Upgrades = 1,
	UpgradeCost = {1},
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		Fire = Point(2,2)
		--Enemy = Point(3,2)
	}
}

function Skill_RepairTooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	--local damage = SpaceDamage(Point(2,2),2)
	--damage.bHide = true
	--ret:AddMelee(Point(3,2),damage)
	--ret:AddDelay(1.5)
	local damage = SpaceDamage(Point(2,2),-1)
	damage.iFire = EFFECT_REMOVE
	--damage.bHide = true
	ret:AddDamage(damage)
	
	return ret
end--]]

-----<---------------------------------