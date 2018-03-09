
Mission_AcidTank = Mission_Infinite:new{
	SpawnMod = 1,
	Objectives = Objective("Kill 4 enemies inflicted with A.C.I.D.",2),
	UseBonus = false,
	AcidKills = 0,
}

function Mission_AcidTank:StartMission()
	Board:AddPawn("Acid_Tank")
end


function Mission_AcidTank:GetCompletedObjectives()
	if self.AcidKills >= 4 then
		return self.Objectives
	elseif self.AcidKills > 0 then
		return Objective("Kill 4 enemies inflicted with A.C.I.D. ("..self.AcidKills.." killed)", 1, 2)
	else
		return self.Objectives:Failed()
	end
end

function Mission_AcidTank:GetCompletedStatus()
	if self.AcidKills >= 4 then
		return "Success"
	else
		return "Failure"
	end
end

function Mission_AcidTank:UpdateObjectives()
	local status = self.AcidKills >= 4 and OBJ_COMPLETE or OBJ_STANDARD
	local text = "Kill 4 enemies inflicted\nwith A.C.I.D. ("..self.AcidKills.."/4 killed)"	
	Game:AddObjective(text, status, REWARD_REP, 2)
end

function Mission_AcidTank:UpdateMission()
	self.AcidKills = self.AcidKills + Game:GetEventCount(EVENT_ACID_DESTROYED)
end

Acid_Tank = 
{
	Name = "A.C.I.D. Tank",
	Health = 1,
	MoveSpeed = 4,
	Image = "TankAcid1",
	SkillList = { "Acid_Tank_Attack" },
	SoundLocation = "/support/civilian_tank/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
	Corporate = true
}
AddPawn("Acid_Tank")

Acid_Tank_Attack = TankDefault:new{
	Class = "",
	ProjectileArt = "effects/shot_tankacid",
	Icon = "weapons/mission_tankacid.png",
	LaunchSound = "/weapons/acid_shot",
	ImpactSound = "/impact/generic/acid_canister",
	Rarity = 0,
	Damage = 0,
	Push = 0,
	Acid = 1,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Acid_Tank"
	}
}

function Acid_Tank_Attack:GetSkillEffect(p1,p2)
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