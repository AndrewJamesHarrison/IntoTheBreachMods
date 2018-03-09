-----------------------
-------SNOWBOTS--------
-----------------------


SnowtankAtk1 = FireflyAtk1:new{
	Damage = 1,
	Push = 0,
	Freeze = 0,
	Fire = 1,
	Class = "Enemy",
	Icon = "weapons/skill_default.png",
	Explosion = "ExploAir2",
	Projectile = "effects/shot_mechtank",
	--LaunchSound = "/enemy/snowtank_1/attack",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2, 2),
		CustomPawn = "Snowtank1",
	}
}
---||---
SnowtankAtk2 = SnowtankAtk1:new{
	Damage = 3,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2, 2),
		CustomPawn = "Snowtank2",
	}
}

---------------

SnowlaserAtk1 = Laser_Base:new{
	Icon = "weapons/skill_default.png",
	Explosion = "",
	--Sound = "",
	Damage = 2,
	--LaunchSound = "default",
	MinDamage = 1,
	FriendlyDamage = true,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Friendly = Point(2,1),
		Target = Point(2,2),
		Mountain = Point(2,0),
		CustomPawn = "Snowlaser1",
	}
}
function SnowlaserAtk1:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local target = p1 + DIR_VECTORS[direction]
	
	self:AddQueuedLaser(ret, target, direction)
	
	return ret
end
---||---

SnowlaserAtk2 = SnowlaserAtk1:new{
	Icon = "weapons/skill_default.png",
	Explosion = "",
	Sound = "",
	Damage = 4,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Friendly = Point(2,1),
		Target = Point(2,2),
		Mountain = Point(2,0),
		CustomPawn = "Snowlaser2",
	}
}

---------------



SnowartAtk1 = {   
	ArtillerySize = 5,
	Explosion = "ExploArt1",
	Damage = 1,
	Class = "Enemy",
	Icon = "weapons/skill_default.png",
	ImpactSound = "/impact/generic/explosion",
	Projectile = "effects/shot_artimech.png",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(3,1),
		Target = Point(2, 1),
		CustomPawn = "Snowart1",
	}
}
SnowartAtk1 = LineArtillery:new(SnowartAtk1)

function SnowartAtk1:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2-p1)
	ret:AddQueuedArtillery(SpaceDamage(p2, self.Damage),self.Projectile)
	ret:AddQueuedDamage(SpaceDamage(p2 + DIR_VECTORS[(dir + 1)% 4], self.Damage))
	ret:AddQueuedDamage(SpaceDamage(p2 + DIR_VECTORS[(dir - 1)% 4], self.Damage))
	return ret
end

---||---

SnowartAtk2 = SnowartAtk1:new{
	Damage = 3,
	Icon = "weapons/skill_default.png",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(3,1),
		Target = Point(2, 1),
		CustomPawn = "Snowart2",
	}
}


----------------------------

SnowmineAtk1 = Skill:new{
	Class = "Enemy",
	Icon = "weapons/skill_default.png",
	ScoreNothing = 5,
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,1),
		CustomPawn = "Snowmine1",
	}
}

function SnowmineAtk1:GetTargetArea(point)
	return Board:GetReachable(point, 3, Pawn:GetPathProf())
end

function SnowmineAtk1:GetSkillEffect(p1,p2)
    local ret = SkillEffect()
	
	if Pawn:IsGrappled() then
		return ret
	end
	
	if p1 ~= p2 then
		local damage = SpaceDamage(p1)
		damage.sItem = "Freeze_Mine"
		ret:AddDamage(damage)
		ret:AddMove(Board:GetPath(p1, p2, Pawn:GetPathProf()), FULL_DELAY)
	end
	
	return ret
end
