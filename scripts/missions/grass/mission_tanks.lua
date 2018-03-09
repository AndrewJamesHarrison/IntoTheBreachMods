
Mission_Tanks = Mission_Infinite:new{
	Count = 2,
	MapTags = {"satellite"},
	Objectives = Objective("Defend the Tanks",2),
	Tanks = nil,
	UseBonus = false,
}

function Mission_Tanks:StartMission()
	self.Tanks = self:AddDefended("Archive_Tank")
	
	Board:GetPawn(self.Tanks[1]):SetPowered(false)
	Board:GetPawn(self.Tanks[2]):SetPowered(false)
end

function Mission_Tanks:NextTurn()
	if Game:GetTurnCount() == 3 and Game:GetTeamTurn() == TEAM_PLAYER then
		for i = 1, 2 do 
			if Board:IsPawnAlive(self.Tanks[i]) then
				Board:GetPawn(self.Tanks[i]):SetNeutral(false)
				Board:GetPawn(self.Tanks[i]):SetPowered(true)
				Game:TriggerSound("/enemy/shared/robot_power_on")
				
				--Game:AddTutorial("Tutorial_Tanks",Board:GetPawnSpace(self.Tanks[i]))
			end
		end
		
		if self:CountTanks() == 2 then
			self:TriggerMissionEvent("Activated")
		elseif self:CountTanks() == 1 then
			self:TriggerMissionEvent("PartialActivated")
		end
	end
end

function Mission_Tanks:GetCompletedObjectives()
	if self:CountTanks() == 1 then
		return Objective("Defend Archive Inc. Tanks (One Lost)",1,2)
	elseif self:CountTanks() == 2 then
		return self.Objectives
	else
		return self.Objectives:Failed()
	end
end

function Mission_Tanks:CountTanks()
	local count = 0
	if Board:IsPawnAlive(self.Tanks[1]) then count = count + 1 end
	if Board:IsPawnAlive(self.Tanks[2]) then count = count + 1 end
	return count
end

function Mission_Tanks:UpdateObjectives()
	local status = OBJ_STANDARD
	if self:CountTanks() == 0 then status = OBJ_FAILED end
	Game:AddObjective("Defend the Tanks\n("..self:CountTanks().."/2 undamaged)", status, REWARD_REP, 2)
end

Archive_Tank = 
{
	Name = "Archive Tank",
	Health = 1,
	MoveSpeed = 4,
	Neutral = true,
	Image = "SmallTank1",
	SkillList = { "Deploy_TankShot" },
	SoundLocation = "/support/civilian_tank/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
	Corporate = false,
	PilotDesc = "Archive Inc \nOld Earth Tank",
}
AddPawn("Archive_Tank")
