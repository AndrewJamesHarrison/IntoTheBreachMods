
Mission_Artillery = Mission_Auto:new{ 
	Name = "Artillery Support",
	ArtilleryId = -1,
	Objectives = Objective("Defend the Artillery Support",1),
	UseBonus = false,
}

function Mission_Artillery:StartMission()
--[[	local backup = {}
	local optimal = {}
	for i = 2, 6 do
		for j = 2, 6 do 
			if Board:IsBuilding(Point(i,j)) then
				if i == 2 or i == 6 or j == 2 or j == 6 then
					backup[#backup+1] = Point(i,j)
				else
					optimal[#optimal+1] = Point(i,j)
				end
			end
		end
	end

	local artillery = PAWN_FACTORY:CreatePawn("ArchiveArtillery")
	self.ArtilleryId = artillery:GetId()
	
	local point = Point(-1,-1)
	
	if #optimal > 0 then
		point = random_removal(optimal)
	elseif #backup > 0 then
		point = random_removal(backup)
	else
		LOG("Couldn't find a point for the artillery")
	end
	
	if Board:IsValid(point) then
		Board:SetTerrain(point,TERRAIN_ROAD)
	end--]]
	
	local artillery = PAWN_FACTORY:CreatePawn("ArchiveArtillery")
	self.ArtilleryId = artillery:GetId()
	Board:AddPawn(artillery)
end

function Mission_Artillery:UpdateObjectives()
	local status = Board:IsPawnAlive(self.ArtilleryId) and OBJ_STANDARD or OBJ_FAILED
	Game:AddObjective("Defend the Artillery Unit",status)
end

function Mission_Artillery:GetCompletedObjectives()
	if Board:IsPawnAlive(self.ArtilleryId) then
		return self.Objectives
	else
		return self.Objectives:Failed()
	end
end

function Mission_Artillery:NextTurn()
	--if Game:GetTurnCount() == 1 and Game:GetTeamTurn() == TEAM_PLAYER then
	--	Game:AddTutorial("Tutorial_ArchiveArtillery",Board:GetPawnSpace(self.ArtilleryId));
--	end
end

ArchiveArtillery = 
{
	Name = "Old Artillery",
	Health = 2,
	MoveSpeed = 1,
	SkillList = { "Archive_ArtShot" },
	Image = "ArtSupport1",
	Massive = false,
	SoundLocation = "/support/civilian_artillery/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corpse = true,
	Corporate = true
}
	
AddPawn("ArchiveArtillery")

Archive_ArtShot = LineArtillery:new{   
	Range = RANGE_ARTILLERY,
	Icon = "weapons/ranged_artillery.png",
	UpShot = "effects/shotup_tribomb_missile.png",
	Damage = 2,---USED FOR TOOLTIPS
	Explosion = "ExploArt1",
	LaunchSound = "/support/civilian_artillery/fire",
	ImpactSound = "/impact/generic/explosion",
	Class = "Unique",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Enemy2 = Point(2,2),
		Target = Point(2,2),
		CustomPawn = "ArchiveArtillery",
	}	
}

function Archive_ArtShot:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2-p1)
	
	ret:AddArtillery(SpaceDamage(p2,self.Damage),self.UpShot,NO_DELAY)
	local damage2 = SpaceDamage(p2+DIR_VECTORS[dir],self.Damage)
	damage2.bHidePath = true
	ret:AddArtillery(damage2,self.UpShot)
		
	return ret
end