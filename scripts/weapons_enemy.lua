
SpiderlingAtk1 = Skill:new{
	PathSize = 1, 
	Damage = 1,
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Spiderling1"
	}
}

function SpiderlingAtk1:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(p2,self.Damage)
	ret:AddQueuedMelee(p1,damage)
	return ret
end

SpiderlingAtk2 = SpiderlingAtk1:new{
	Damage = 2, 
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Spiderling2"
	}
}

--------------

ScorpionAtk1 = {
	PathSize = 1,
	Icon = "weapons/enemy_scorpion1.png",	
	Damage = 1,
	PreDamage = 0,
	Range = 1,
	Web = 1,
	Acid = 0,
	Push = 0,
	Class = "Enemy",
	LaunchSound = "",
	SoundBase = "/enemy/scorpion_soldier_1",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Scorpion1"
	}
}

ScorpionAtk1 = Skill:new(ScorpionAtk1) 

function ScorpionAtk1:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local push = self.Push == 1 and direction or DIR_NONE
	

	if self.Web == 1 then--TRAILER
		local sound = SpaceDamage(p2)
		ret:AddDamage(SoundEffect(p2,self.SoundBase.."/attack_web"))
		ret:AddGrapple(p1,p2,"hold")
	end
	
	local damage = SpaceDamage(p2,self.Damage,push)
	damage.sAnimation = "SwipeClaw2"
	damage.iAcid = self.Acid
	damage.sSound = self.SoundBase.."/attack"
	
	ret:AddQueuedMelee(p1,damage)--TRAILER
		
	return ret
end	

-----||||-----

ScorpionAtk2 = ScorpionAtk1:new{
	Damage = 3, 
	PreDamage = 0, 
	Web = 1, 
	Class = "Enemy",
	Icon = "weapons/enemy_scorpion2.png",
	SoundBase = "/enemy/scorpion_soldier_2",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Scorpion2"
	}
}

ScorpionAtk_Acid = ScorpionAtk1:new{
	Acid = 1
}

-------------

Burrower_Atk = Skill:new{
	Class = "Enemy",
	PathSize = 1,
	Explosion = "SwipeClaw2",
	Damage = 1,
	LaunchSound = "",
	SoundBase = "/enemy/burrower_1/",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Target = Point(2,2),
		CustomPawn = "Burrower1",
	}
}

function Burrower_Atk:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local damage = SpaceDamage(p2,self.Damage)
	damage.sSound = self.SoundBase.."attack"
	
	ret:AddQueuedDamage(damage)
	damage.loc = p2 + DIR_VECTORS[(direction + 1)% 4]
	ret:AddQueuedDamage(damage)
	damage.loc = p2 - DIR_VECTORS[(direction + 1)% 4]
	ret:AddQueuedDamage(damage)
	
	return ret
end

Burrower_Atk2 = Burrower_Atk:new{
	Damage = 2,
	SoundBase = "/enemy/burrower_2/",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Target = Point(2,2),
		CustomPawn = "Burrower2",
	}
}

-------------------------------------------------------

HornetAtk1 = Skill:new{
	Damage = 1,
	PathSize = 1,
	Class = "Enemy",
	TargetBehind = false,
	Icon = "weapons/enemy_hornet1.png",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Hornet1"
	}
}

function HornetAtk1:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)	
	
	local damage = SpaceDamage(p2,self.Damage)
	damage.sAnimation = "explohornet_"..direction
	
	ret:AddQueuedMelee(p1,damage, 0.25)
	
	if self.TargetBehind then
		damage.loc = p2+DIR_VECTORS[direction]
		ret:AddQueuedDamage(damage)
	end
	
	return ret
end	

----|||----

HornetAtk2 = HornetAtk1:new{
	Damage = 2, 
	TargetBehind = true,
	Class = "Enemy",
	Icon = "weapons/enemy_hornet2.png",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,2),
		CustomPawn = "Hornet2"
	}
}

HornetAtk_Acid = HornetAtk1:new{
	Acid = 1
}

-------------------------------------------------------

CrabAtk1 = {   
	ArtillerySize = 5,
	Explosion = "ExploArt1",
	Damage = 1,
	Type = 2, 
	Class = "Enemy",
	Icon = "weapons/enemy_crab1.png",
	ImpactSound = "/impact/generic/explosion",
	Projectile = "effects/shotup_crab1.png",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Enemy2 = Point(2,0),
		Building = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Crab1"
	}
}

CrabAtk1 = LineArtillery:new(CrabAtk1)

function CrabAtk1:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2-p1)
	ret:AddQueuedArtillery(SpaceDamage(p2, self.Damage),self.Projectile)
	
	if self.Type == 2 then
		ret:AddQueuedDamage(SpaceDamage(p2 + DIR_VECTORS[dir], self.Damage)) -- added for 'simpler'
	end
	
	return ret
end

-----|||||-----

CrabAtk2 = CrabAtk1:new{
	Damage = 3,
	Type = 2,
	Class = "Enemy",
	Icon = "weapons/enemy_crab2.png",
	Projectile = "effects/shotup_crab2.png",
	Explosion = "explo_fire1",
	ImpactSound = "/impact/generic/explosion_large",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Enemy2 = Point(2,0),
		Building = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Crab2"
	}
}

-------------------------------------------------------

ScarabAtk1 = CrabAtk1:new{
	Damage = 1,
	Type = 1,
	Class = "Enemy",
	Icon = "weapons/enemy_scarab1.png",
	Projectile = "effects/shotup_ant1.png",
	Explosion = "ExploArt1",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Building = Point(2,2),
		Target = Point(2,1),
		CustomPawn = "Scarab1"
	}
}

-----|||||-----

ScarabAtk2 = CrabAtk1:new{
	Damage = 3,
	Type = 1,
	Class = "Enemy",
	Icon = "weapons/enemy_scarab2.png",
	Projectile = "effects/shotup_ant2.png",
	Explosion = "ExploArt2",
	ImpactSound = "/impact/generic/explosion_large",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Building = Point(2,2),
		Target = Point(2,1),
		CustomPawn = "Scarab2"
	}
}
-------------------------------------------------------

CentipedeAtk1 = 	{
	Damage = 1,
	PathSize = 1,
	Range = RANGE_PROJECTILE,
	Push = 0,
	Fire = 0,
	Freeze = 0,
	Acid = 1,
	Class = "Enemy",
	Icon = "weapons/enemy_firefly1.png",
	Explosion = "ExploFirefly1",
	ImpactSound = "/impact/dynamic/enemy_projectile",
	Projectile = "effects/shot_firefly",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,2),
		CustomPawn = "Centipede1"
	}
}
			
CentipedeAtk1 = Skill:new(CentipedeAtk1)

function CentipedeAtk1:GetTargetScore(p1,p2)
	local effect = SkillEffect()
	
	-- don't allow the centipede to specifically attack an enemy unit since it might not have moved yet,
	-- which would then disrupt its final targeting and create strange behavior. "splash damage" against
	-- enemy targets is ok.
	if Board:GetPawnTeam(p2) == TEAM_ENEMY then
		return -10
	end
		
	return self:ScoreList(self:GetSkillEffect(p1,p2).q_effect, true)
end

function CentipedeAtk1:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
			
	local target = GetProjectileEnd(p1,p2)  
		
	local damage1 = SpaceDamage(target, self.Damage)
	local damage2 = SpaceDamage(target + DIR_VECTORS[(dir + 1)% 4], self.Damage)
	local damage3 = SpaceDamage(target + DIR_VECTORS[(dir - 1)% 4], self.Damage)
	
	damage1.iAcid = self.Acid
	damage2.iAcid = self.Acid
	damage3.iAcid = self.Acid
	
	ret:AddQueuedProjectile(damage1,self.Projectile)
	ret:AddQueuedDamage(damage2)
	ret:AddQueuedDamage(damage3)
		
	--ret.path = Board:GetSimplePath(p1, target)
	
	return ret
end

----|||-----

CentipedeAtk2 = CentipedeAtk1:new{
	Damage = 2,
	Class = "Enemy",
	Icon = "weapons/enemy_firefly2.png",
	Explosion = "ExploFirefly1",
	Projectile = "effects/shot_firefly2",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,2),
		CustomPawn = "Centipede2"
	}
}

CentipedeAtk_Acid = CentipedeAtk1:new{
	Acid = 1
}

-------------------------------------------------------

LeaperAtk1 = ScorpionAtk1:new{
	Damage = 3,
	Icon = "weapons/enemy_leaper1.png",
	SoundBase = "/enemy/leaper_1",
	Class = "Enemy",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Leaper1"
	}
}
----------|||------------

LeaperAtk2 = LeaperAtk1:new{
	Class = "Enemy",
	Damage = 5,
	Icon = "weapons/enemy_leaper1.png",
	SoundBase = "/enemy/leaper_2",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Leaper2"
	}
}

-------------------------------------------------------


FireflyAtk1 = 	{
	Damage = 1,
	PathSize = 1,
	Range = RANGE_PROJECTILE,
	Push = 0,
	Fire = 0,
	Freeze = 0,
	Acid = 0,
	Class = "Enemy",
	Icon = "weapons/enemy_firefly1.png",
	Explosion = "ExploFirefly1",
	ImpactSound = "/impact/dynamic/enemy_projectile",
	Projectile = "effects/shot_firefly",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,2),
		CustomPawn = "Firefly1"
	}
}
			
FireflyAtk1 = Skill:new(FireflyAtk1)

function FireflyAtk1:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
			
	local target = GetProjectileEnd(p1,p2)  
	
	local damage = nil
	if self.Push == 1 then
		damage = SpaceDamage(target, self.Damage, direction)
	else
		damage = SpaceDamage(target, self.Damage)
	end
	
	damage.iFire = self.Fire
	damage.iFrozen = self.Freeze
	damage.iAcid = self.Acid
	
	ret:AddQueuedProjectile(damage,self.Projectile)--TRAILER
		
	--ret.path = Board:GetSimplePath(p1, target)
	
	return ret
end

----------|||------------

FireflyAtk2 = FireflyAtk1:new{
	Damage = 3,
	Push = 0,
	Class = "Enemy",
	Icon = "weapons/enemy_firefly2.png",
	Explosion = "ExploFirefly1",
	Projectile = "effects/shot_firefly2",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,2),
		CustomPawn = "Firefly2"
	}
}

FireflyAtk_Acid = FireflyAtk1:new{
	Acid = 1
}

----------------------


BeetleAtk1 = {
	Damage = 1,
	Class = "Enemy",
	Fire = false,--boss fire trail
	LaunchSound = "/enemy/beetle_1/attack_charge",
	Fly = false,
	Icon = "weapons/brute_beetle.png",
	PathSize = 1,--just needs to target immediately adjacent locations
	Explosion = "ExploAir1",
	TipImage = {
		Unit = Point(2,4),
		Target = Point(2,3),
		Enemy = Point(2,1),
		CustomPawn = "Beetle1",
	}
}
			
BeetleAtk1 = Skill:new(BeetleAtk1)

function BeetleAtk1:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
			
	local pathing = PATH_GROUND
	if self.Fly then pathing = PATH_PROJECTILE end
	
	local target = GetProjectileEnd(p1,p2,pathing)
	
	local doDamage = true
	
	if not Board:IsBlocked(target,pathing) then -- dont attack an empty edge square, just run to the edge
		doDamage = false
		target = target + DIR_VECTORS[direction]
	end
	
	if not Board:IsPawnSpace(target) and (Board:GetTerrain(target) == TERRAIN_WATER or Board:GetTerrain(target) == TERRAIN_HOLE) then ---run into water/hole and die!
		doDamage = false
		target = target + DIR_VECTORS[direction]
	end
	
	local delay = self.Fire and NO_DELAY or FULL_DELAY
	ret:AddQueuedCharge(Board:GetSimplePath(p1, target - DIR_VECTORS[direction]), delay)
	
	if self.Fire then -- boss fire trail
		local i = p1
		while i ~= target - DIR_VECTORS[direction] do
			damage = SpaceDamage(i,0)
			damage.iFire = 1
			damage.fDelay = 0.1
			ret:AddQueuedDamage(damage)
			i = i + DIR_VECTORS[direction]
		end
	end
	
	if doDamage then 
		damage = SpaceDamage(target, self.Damage, direction)
		damage.sAnimation = "ExploAir2"
		damage.sSound = "/enemy/beetle_1/attack_impact"
		ret:AddQueuedDamage(damage)
	end
	
	return ret
end

----------|||------------

BeetleAtk2 = BeetleAtk1:new{
	Damage = 3,
	Fly = false,
	Class = "Enemy",
	Icon = "weapons/brute_beetle.png",
	Explosion = "ExploAir2",
	TipImage = {
		Unit = Point(2,4),
		Target = Point(2,3),
		Enemy = Point(2,1),
		CustomPawn = "Beetle2",
	}--[[
	TipImage = {
		Unit = Point(2,4),
		Target = Point(2,3),
		Enemy = Point(2,1),
		Hole = Point(0,3),
		Hole2 = Point(1,3),
		Hole3 = Point(2,3),
		Hole4 = Point(3,3),
		Hole5 = Point(4,3),
		CustomPawn = "Beetle2",
	}]]--
}

----------------------

DiggerAtk1 = Skill:new{
	Damage = 1,
	Push = false,
	Class = "Enemy",
	Icon = "weapons/enemy_rocker1.png",
	LaunchSound = "",
	SoundId = "digger_1",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Building = Point(3,2),
		Target = Point(2,2),
		CustomPawn = "Digger1"
	}
}

function DiggerAtk1:GetTargetArea(point)
	local ret = PointList()
	ret:push_back(point)
	return ret
end

function DiggerAtk1:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	for dir = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[dir]
		if not Board:IsBlocked(curr,PATH_PROJECTILE) and Board:GetTerrain(curr) ~= TERRAIN_WATER and not Board:IsPod(curr) then
			local damage = SpaceDamage(curr)
			damage.sPawn = "Wall"
			damage.sSound = "/enemy/"..self.SoundId.."/attack_queued"
			ret:AddDamage(damage)
		end
		
		local push = self.Push and dir or DIR_NONE
		local damage = SpaceDamage(p1 + DIR_VECTORS[dir],self.Damage, push)
		
		damage.sAnimation = "explorocker_"..dir
		damage.sSound = "/enemy/"..self.SoundId.."/attack"
		ret:AddQueuedDamage(damage)
	end	
	return ret
end	

---||---

DiggerAtk2 = DiggerAtk1:new{
	Damage = 2,
	Class = "Enemy",
	Icon = "weapons/enemy_rocker.png",
	SoundId = "digger_2",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Building = Point(3,2),
		Target = Point(2,2),
		CustomPawn = "Digger2"
	}
}
	
	
	
-------------------------------------------

BlobberAtk1 = LineArtillery:new{ 
	ScoreNothing = 0, 
	MyPawn = "Blob1",
	Class = "Enemy",
	Icon = "weapons/enemy_blobber1.png",	
	MyArtillery =  "effects/shotup_blobber1.png",
	ImpactSound = "/impact/generic/blob",
	OnlyEmpty = true,
	Explosion = "",
	TipImage = {
		CustomPawn = "Blobber1",
		Unit = Point(2,3),
		Target = Point(2,1),
		Second_Origin = Point(2,1),
		Second_Target = Point(2,1),
		Enemy = Point(3,1),
		Enemy2 = Point(2,0),
	}
}

function BlobberAtk1:GetTargetScore(p1,p2)
	local effect = SkillEffect()
	
	if p2.x == 0 or p2.x == 7 or p2.y == 0 or p2.y == 7 then return -10 end
	
	if not Board:IsSafe(p2) then return -10 end
		
	effect:AddQueuedDamage(SpaceDamage(p2, 2))
	for i = DIR_START, DIR_END do
		effect:AddQueuedDamage(SpaceDamage(p2 + DIR_VECTORS[i], 1))
	end
			
	return self:ScoreList(effect.q_effect, true)
end

function BlobberAtk1:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(p2)
	damage.sPawn = self.MyPawn
	--damage.sAnimation = "ExploArt1"
	ret:AddArtillery(damage, self.MyArtillery)
		
	for dir = DIR_START, DIR_END do 
		damage = SpaceDamage(p2 + DIR_VECTORS[dir],0)
		ret:AddDamage(damage)
	end
	
	return ret
end

-----||||-----

BlobberAtk2 = BlobberAtk1:new{ 
	MyPawn = "Blob2", 
	Class = "Enemy",
	Icon = "weapons/enemy_blobber2.png",	
	MyArtillery =  "effects/shotup_blobber2.png",
	Explosion = "",
	TipImage = BlobberAtk1.TipImage,
}  

----------------------

BlobAtk1 = {
	Explosion = "explo_fire1",
	InnerDamage = DAMAGE_DEATH,
	OuterDamage = 1,
	OuterExplosion = "exploout1_",
	BombSize = 1,
	Class = "Enemy",
	Icon = "weapons/enemy_blob1.png",	
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		Enemy = Point(2,1),
		Building = Point(1,2),
		Enemy2 = Point(2,3),
		CustomPawn = "Blob1"
	}
}

BlobAtk1 = SelfTarget:new(BlobAtk1)

function BlobAtk1:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local damage = SpaceDamage(p1, self.InnerDamage)
	damage.sSound = "/impact/generic/explosion_large"
	ret:AddQueuedDamage(damage)
		
	for dir = DIR_START, DIR_END do
		for size = 1, self.BombSize do
			damage = SpaceDamage(p1 + DIR_VECTORS[dir]*size, self.OuterDamage)
			damage.sAnimation = self.OuterExplosion..dir
			ret:AddQueuedDamage(damage)
		end
	end
		
	return ret
end

function BlobAtk1:GetTargetScore(p1, p2)
	return 100
end

-----||||-----

BlobAtk2 = BlobAtk1:new{ 
	Explosion = "explo_fire1",
	Icon = "weapons/enemy_blob2.png",	
	InnerDamage = DAMAGE_DEATH,
	OuterDamage = 3,
	OuterExplosion = "exploout2_",
	Class = "Enemy",
	BombSize = 1,
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		Enemy = Point(2,1),
		Building = Point(1,2),
		Enemy2 = Point(2,3),
		CustomPawn = "Blob2"
	}
}  

------------------------

SpiderAtk1 = LineArtillery:new{
	MyArtillery =  "effects/shotup_webling.png",
	MyPawn = "WebbEgg1",
	ImpactSound = "/enemy/spider_boss_1/attack_egg_land",
	Class = "Enemy",
	OnlyEmpty = true,
	Explosion = "",
	TipImage = {
		CustomPawn = "Spider1",
		Unit = Point(2,3),
		Target = Point(2,1),
		Second_Origin = Point(2,1),
		Second_Target = Point(2,1),
		Enemy = Point(3,1),
		Enemy2 = Point(2,0),
	}
}

function SpiderAtk1:GetTargetScore(p1,p2)
	local effect = SkillEffect()
	
	local pos_score = ScorePositioning(p2,Pawn)
		
	local targetScore = 0
	for i = DIR_START, DIR_END do
		local curr = p2 + DIR_VECTORS[i]
		if Board:GetPawnTeam(curr) == TEAM_PLAYER then
			targetScore = targetScore + 5
		elseif Board:IsBuilding(curr) then
			targetScore = targetScore + 2
		elseif Board:IsValid(curr) then
			targetScore = targetScore + 1
		end
	end

	if pos_score < 0 then return pos_score end
	
	return targetScore
end

function SpiderAtk1:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(p2)
	damage.sPawn = self.MyPawn
	ret:AddArtillery(damage, self.MyArtillery)
		
	for dir = DIR_START, DIR_END do 
		ret:AddGrapple(p2,p2 + DIR_VECTORS[dir],"hold")
	end
	
	return ret
end

----------|||------------

SpiderAtk2 = SpiderAtk1:new{
	Class = "Enemy",
	TipImage = {
		CustomPawn = "Spider2",
		Unit = Point(2,3),
		Target = Point(2,1),
		Second_Origin = Point(2,1),
		Second_Target = Point(2,1),
		Enemy = Point(3,1),
		Enemy2 = Point(2,0),
	}
}

---

WebeggHatch1 = SelfTarget:new{ 
	SpiderType = "Spiderling1",
	Class = "Enemy",
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		CustomPawn = "WebbEgg1",
	}
}

function WebeggHatch1:GetTargetScore(p)
	return 10
end

function WebeggHatch1:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	
	--[[-- DO 1st turn..
	for dir = DIR_START, DIR_END do
		local sound = SpaceDamage(p1)
		ret:AddDamage(SoundEffect(p1,"/enemy/scorpion_soldier_1/attack_web"))
		ret:AddGrapple(p1,p1 + DIR_VECTORS[dir],"hold")
	end--]]
	
	-- DO 2nd turn..
	local damage = SpaceDamage(p1)
	damage.sPawn = self.SpiderType
	ret:AddQueuedDamage(damage)
	
	return ret
end


----------------------------------------
----------------------------------------

---------

--[[self target just because it's simple
Garden_Atk = SelfTarget:new{
	Class = "Enemy",
}

function Garden_Atk:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(0)
	damage.iVines = 1
	
	for i = 0, 7 do
		for j = 0, 7 do
			local curr = Point(i,j)
			for dir = DIR_START, DIR_END do
				if not Board:IsVines(curr) and Board:IsVines(curr + DIR_VECTORS[dir]) then
					damage.loc = curr
					ret:AddDamage(damage)
					ret:AddDelay(0.2)
				end
			end
		end
	end

	return ret
end

--always use it
function Garden_Atk:GetTargetScore(p1,p2)
	return 10
end--]]


---------------------------------------------
---------------------------------------------

Jelly_Health_Tooltip = Skill:new{
	Class = "Passive",
	PathSize = 1,
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,1),
		CustomPawn = "Jelly_Health1",
	}
}

function Jelly_Health_Tooltip:GetSkillEffect(p1,p2)

	local ret = SkillEffect()
	local damage = SpaceDamage(p2,0)
	damage.sPawn = "Scorpion1"
	damage.bHide = true
	ret:AddDamage(damage)
	damage.loc = Point(1,1)
	ret:AddDamage(damage)
	return ret
end

-----------------
-----------------

Jelly_Lava_Tooltip = Skill:new{
	Class = "Passive",
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,2),
		Enemy = Point(2,1),
		Enemy2 = Point(2,2),
		Enemy3 = Point(3,2),
		CustomPawn = "Jelly_Lava1",
	}
}

function Jelly_Lava_Tooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	--ret:AddDelay(1)
	ret:AddDamage(SpaceDamage(Point(2,1),1))
	ret:AddDamage(SpaceDamage(Point(2,2),1))
	ret:AddDamage(SpaceDamage(Point(3,2),1))
	return ret
end

-----------------
-----------------

Jelly_Explode_Tooltip = Skill:new{
	Class = "Passive",
	PathSize = 5,
	TipImage = {
		Unit = Point(2,3),
		Friendly = Point(2,1),
		Target = Point(2,1),
		Building = Point(3,2),
		Enemy1 = Point(1,1),
		CustomPawn = "Jelly_Explode1",
		Length = 3.5
	--	Enemy2 = Point(3,2)
		--Length = 6
	}
}

function Jelly_Explode_Tooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	--ret:AddDelay(1)
	ret:AddMelee(Point(1,1),SpaceDamage(p2,3,DIR_RIGHT))
	return ret
end

--------------------
--------------------

Jelly_Armor_Tooltip = Skill:new{
	Class = "Passive",
	PathSize = 5,
	TipImage = {
		Unit = Point(2,3),
		Friendly = Point(2,1),
		Target = Point(2,1),
		Enemy = Point(1,1),
		CustomPawn = "Jelly_Armor1",
		Length = 3
	}
}

function Jelly_Armor_Tooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	--ret:AddDelay(1)
	ret:AddMelee(Point(1,1),SpaceDamage(p2,2,DIR_RIGHT))
	return ret
end

--------------------
--------------------

Jelly_Regen_Tooltip = Skill:new{
	Class = "Passive",
	PathSize = 5,
	TipImage = {
		Unit = Point(2,4),
		Friendly = Point(1,2),
		Target = Point(2,2),
		Enemy = Point(0,2),
		--Friendly2 = Point(2,2),
		CustomPawn = "Jelly_Regen1",
		Length = 5
	}
}

function Jelly_Regen_Tooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	ret:AddMelee(Point(0,2),SpaceDamage(Point(1,2),2,DIR_RIGHT))
	ret:AddDelay(1)
	local damage = SpaceDamage(Point(2,2),-1)
	damage.bHide = true
	ret:AddDamage(damage)
	
	return ret
end

