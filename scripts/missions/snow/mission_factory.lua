
Mission_Factory = Mission_Critical:new{
	Criticals = nil,
	Image = "str_timelab1",
	FlavorName = "Robot Factories",--for Mission_Critical naming in objective list
	FlavorSingle = "Robot Factory",
	Objectives = Objective("Defend both Robot Factories", 2),
	SpawnMod = -1,
	NewPoints = {},
	NewPawns = {},
	UseBonus = false,
	Reward = REWARD_REP,
}

function Mission_Factory:UpdateSpawning()
	self:SpawnPawns(self:GetSpawnCount())--spawn Vek
	
	if self:IsFinalTurn() then return end
	
	self.NewPoints = {}
	self.NewPawns = {}
	
	local last_list = {}
	local index = Game:GetTurnCount() % 2 + 1
	local loc = self.Criticals[index]
	
	if Board:IsDamaged(loc) then
		index = index == 1 and 2 or 1
		loc = self.Criticals[index]
	end
	
	if not Board:IsDamaged(loc) then
		PrepareVoiceEvent("Mission_Factory_Spawning",-1,-1)
		last_list = self:FlyingSpawns(loc,1,self:NextRobotName(),{image = "effects/shotup_robot.png", launch = "/props/factory_launch", impact = "/impact/generic/mech"}, last_list)
		--LOG("Added robot robot to "..last_list[1]:GetString())
		self.NewPoints[#self.NewPoints+1] = last_list[1]--only one spawned. change me if you spawn more than 1
	end
end

function Mission_Factory:UpdateMission()
 	for i,v in ipairs(self.NewPoints) do
		if Board:IsPawnSpace(v) then
			self.NewPawns[#self.NewPawns+1] = Board:GetPawn(v):GetId()
			Board:GetPawn(v):SetPowered(false)
			table.remove(self.NewPoints,i)
			return
		end
	end
	
	self:UpdateDescriptions()
end

function Mission_Factory:NextTurn()
	if Game:GetTeamTurn() == TEAM_ENEMY then
		for i,v in ipairs(self.NewPawns) do
			if Board:IsPawnAlive(v) then
				Board:GetPawn(v):SetPowered(true)
				Game:TriggerSound("/enemy/shared/robot_power_on")
			end
		end
		
		self.NewPawns = {}
	end
end

function Mission_Factory:GetCompletedObjectives()
	if self:GetDamagedCount() == 0 then
		return self.Objectives
	elseif self:GetDamagedCount() == 1 then 
		return Objective(self.Objectives.text.." (1 damaged)", 1, 2)
	else
		return self.Objectives:Failed()
	end
end

function Mission_Factory:UpdateObjectives()
--	Game:AddObjective("Defeat All Enemies", OBJ_STANDARD)
	local status = OBJ_STANDARD
	if self:GetDamagedCount() == 2 then status = OBJ_FAILED end
	local flavorName = IsLargeFont() and "Factories" or self.FlavorName
	Game:AddObjective("Defend the "..flavorName.." \n("..(2-self:GetDamagedCount()).."/2 undamaged)", status, self.Reward, 2)
end