Mission_BotDefense = Mission_Infinite:new{
	RobotStart = 2,
	Bots = nil,
	Objectives = Objective("Defend the Robots",2,2),
	UseBonus = false
}

function Mission_BotDefense:StartMission()
	self.Bots = {}
	for i = 1, self.RobotStart do
		local pawn = PAWN_FACTORY:CreatePawn("Snowmine1")
		Board:AddPawn(pawn)
		self.Bots[#self.Bots + 1] = pawn:GetId()
		pawn:SetTeam(TEAM_PLAYER)
	end
end

function Mission_BotDefense:GetCompletedObjectives()
	if self:CountBots() == 1 then
		return Objective("Defend the Robots (One Lost)",1,2)
	elseif self:CountBots() == 2 then
		return self.Objectives
	else
		return self.Objectives:Failed()
	end
end

function Mission_BotDefense:CountBots()
	local count = 0
	if Board:IsPawnAlive(self.Bots[1]) then count = count + 1 end
	if Board:IsPawnAlive(self.Bots[2]) then count = count + 1 end
	return count
end

function Mission_BotDefense:UpdateObjectives()
	local status1 = self:CountBots()  == 2 and OBJ_STANDARD or OBJ_FAILED
	Game:AddObjective("Defend both the Robots" , status1, REWARD_REP, 2)
	
	if status1 == OBJ_FAILED then
		local status2 = self:CountBots()  == 1 and OBJ_STANDARD or OBJ_FAILED
		Game:AddObjective("Defend the remaining Robot", status2, REWARD_REP, 1)
	end
end