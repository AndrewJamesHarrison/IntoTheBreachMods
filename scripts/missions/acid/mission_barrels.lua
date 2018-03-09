
Mission_Barrels = Mission_Infinite:new{ 
	--Barrels = {},
	BarrelCount = 2,
	MapTags = {"satellite"},--let's hijack it
	Objectives = Objective("Destroy the A.C.I.D. Vats",2,2),
	UseBonus = false
}

function Mission_Barrels:IsEndBlocked()
	return self:CountBarrels() ~= 0
end

function Mission_Barrels:CountBarrels()
	local pawns = extract_table(Board:GetPawns(TEAM_ENEMY))
	local count = 0
	for i, v in ipairs(pawns) do
		if string.find(Board:GetPawn(v):GetType(), "AcidVat") ~= nil then
			count = count + 1
		end
	end
	
	return count
end

function Mission_Barrels:StartMission()
	local zone = extract_table(Board:GetZone("satellite"))
	
	for i = 1, self.BarrelCount do
		local pawn = PAWN_FACTORY:CreatePawn("AcidVat")
		--self.Barrels[#self.Barrels + 1] = pawn:GetId()
		local choice = random_removal(zone)
		Board:ClearSpace(choice)
		Board:AddPawn(pawn, choice)
	end
end

function Mission_Barrels:GetCompletedStatus()
	if self:CountBarrels() > 0 then	
		return "Failure"
	else
		return "Success"
	end
end

function Mission_Barrels:GetCompletedObjectives()
	local barrel_count = self:CountBarrels()
	if barrel_count == 0 then
		return self.Objectives
	elseif barrel_count == 1 then
		return Objective("Destroy the Vats ("..barrel_count.." Remain)",1,2)
	else
		return self.Objectives:Failed()
	end
end

function Mission_Barrels:UpdateObjectives()
	local status = self:CountBarrels() == 0 and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective("Destroy the A.C.I.D. Vats",status, REWARD_REP, 2)
end

function Mission_Barrels:UpdateMission()
end

AcidVat = {
	Name = "Acid Vat",
	Health = 2,
	Neutral = true,
	MoveSpeed = 0,
	Image = "barrel1",
	DefaultTeam = TEAM_ENEMY,
	IsPortrait = false,
	Minor = true,
	Mission = true,
	Tooltip = "Acid_Death_Tooltip",
	IsDeathEffect = true,
}
AddPawn("AcidVat") 

function AcidVat:GetDeathEffect(point)
	local ret = SkillEffect()
	
	local dam = SpaceDamage(point)
	dam.iTerrain = TERRAIN_WATER
	dam.iAcid = 1
	dam.sAnimation = "splash"--hack
	dam.sSound = "/props/acid_vat_break"
	ret:AddDamage(dam)
	return ret
end

Acid_Death_Tooltip = SelfTarget:new{
	Class = "Death",
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		CustomPawn = "AcidVat"
	}
}

function Acid_Death_Tooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local space_damage = SpaceDamage(p2,DAMAGE_DEATH)
	space_damage.bHide = true
	space_damage.sAnimation = "ExploAir2" 
	ret:AddDelay(1)
	ret:AddDamage(space_damage)
	ret:AddDelay(1)
	return ret
end