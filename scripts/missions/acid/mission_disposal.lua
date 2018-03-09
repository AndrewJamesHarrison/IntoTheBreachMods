
Mission_Disposal = Mission_Infinite:new{ 
	MapTags = { "disposal" },
	Objectives = { Objective("Defend the Disposal Unit",1), Objective("Destroy all mountains", 1),  }, 
	DisposalId = -1,
	SpawnStartMod = 1,
	SpawnMod = 2,
	UseBonus = false,
}

function Mission_Disposal:CountMountains()
	return #self:GetTerrainList(TERRAIN_MOUNTAIN)
end

function Mission_Disposal:IsEndBlocked()
	return self:CountMountains() > 0 and Board:IsPawnAlive(self.DisposalId)
end

function Mission_Disposal:GetCompletedObjectives()
	local ret = copy_table(self.Objectives)
	
	if not Board:IsPawnAlive(self.DisposalId) then
		ret[1] = ret[1]:Failed()
	end
	
	if self:CountMountains() > 0 then
		ret[2] = ret[2]:Failed()
	end
	
	return ret
end

function Mission_Disposal:UpdateObjectives()
	local alive = Board:IsPawnAlive(self.DisposalId) and OBJ_STANDARD or OBJ_FAILED
	local mountains = self:CountMountains() == 0 and OBJ_COMPLETE or OBJ_STANDARD
	
	--if alive == OBJ_FAILED and mountains == OBJ_STANDARD then
	--	mountains = OBJ_FAILED
	--end
	
	Game:AddObjective("Defend the Disposal Unit", alive)	
	Game:AddObjective("Dispose of all mountains", mountains)	
end

--used for briefing messages
function Mission_Disposal:GetCompletedStatus()
	local mnt_alive = self:CountMountains() > 0
	local pawn_alive = Board:IsPawnAlive(self.DisposalId) 
	if not pawn_alive and mnt_alive then 
		return "Failure"
	elseif  mnt_alive then
		return "Mountains"
	elseif not pawn_alive then
		return "Disposal"
	else
		return "Success"
	end
end

function Mission_Disposal:StartMission()
	local unit = PAWN_FACTORY:CreatePawn("Disposal_Unit")
	self.DisposalId = unit:GetId()
	Board:AddPawn(unit,"disposal")
	Board:SetAcid(unit:GetSpace(),false)
end

Disposal_Unit = Pawn:new{
	Name = "A.C.I.D. Launcher",
	Image = "terraformer2",
	Health = 2,
	MoveSpeed = 0,
	SkillList = { "Disposal_Attack" }, 
	DefaultTeam = TEAM_PLAYER,
	Pushable = false,
	Corporate = true,
	SoundLocation = "/support/disposal",
}

Disposal_Attack = Grenade_Base:new{  
	Explosion = "",
	Icon = "weapons/structure_disposal.png",	
	Class = "Unique",
	LaunchSound = "/support/disposal/attack",
	ImpactSound = "/support/disposal/attack_impact",
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,1),
		Enemy = Point(2,1),
		Enemy2 = Point(3,1),
		Mountain = Point(1,1),
		CustomPawn = "Disposal_Unit"
	}
}
				
function Disposal_Attack:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local acid = SpaceDamage(p2,0)
	acid.iAcid = 1
	acid.iTerrain = Board:IsTerrain(acid.loc, TERRAIN_MOUNTAIN) and TERRAIN_ROAD or 10
	acid.iDamage = DAMAGE_DEATH
	--acid.bHide = true
	acid.sAnimation = "ExploArtCrab2"
	ret:AddArtillery(acid, "effects/shotup_acid.png", NO_DELAY)
	for i = DIR_START, DIR_END do
		acid.loc = p2 + DIR_VECTORS[i]
		acid.bHidePath = true
		acid.iTerrain = Board:IsTerrain(acid.loc, TERRAIN_MOUNTAIN) and TERRAIN_ROAD or 10
		ret:AddArtillery(acid, "effects/shotup_acid.png", i == DIR_END and FULL_DELAY or NO_DELAY)
	end
	--[[
	local damage = SpaceDamage(p2,DAMAGE_DEATH) -- damage goes second
	ret:AddDamage(damage)
	for i = DIR_START, DIR_END do
		damage.loc = p2 + DIR_VECTORS[i]
		damage.sAnimation = ""
		ret:AddDamage(damage)
	end]]--
	
	return ret
end

