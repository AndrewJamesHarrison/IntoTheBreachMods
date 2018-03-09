
Mission_FreezeBots = Mission_Infinite:new{
	SpawnStartMod = -2,
	SpawnMod = 1,
	Objectives = Objective("Freeze and defend both robots",2),
	Bots = nil,
	UseBonus = false,
}	

function Mission_FreezeBots:StartMission()
	self.Bots = {}
	for i = 1, 2 do
		local bot = self:NextRobot()
		Board:AddPawn(bot)
		self.Bots[#self.Bots+1] = bot:GetId()
	end
	
	Board:AddPawn("Freeze_Tank")
end

function Mission_FreezeBots:GetCompletedObjectives()
	if self:CountFrozen() == 2 then
		return self.Objectives
	elseif self:CountFrozen() == 1 then
		return Objective("Freeze and defend the robots (one frozen)", 1, 2)
	else
		return self.Objectives:Failed()
	end
end

function Mission_FreezeBots:GetCompletedStatus()
	if self:CountFrozen() == 2 then
		return "Success"
	elseif self:CountDead() == 1 then
		return "Dead"
	elseif self:CountDead() == 2 then
		return "Failure"
	else
		return "Freed"
	end
end

function Mission_FreezeBots:CountDead()
	return bool_int(not Board:IsPawnAlive(self.Bots[1])) + bool_int(not Board:IsPawnAlive(self.Bots[2]))
end

function Mission_FreezeBots:CountFrozen()
	local count = 0
	for i = 1, 2 do
		count = count + bool_int(Board:IsPawnAlive(self.Bots[i]) and Board:GetPawn(self.Bots[i]):IsFrozen())
	end
	return count
end

function Mission_FreezeBots:UpdateObjectives()
	if self:CountDead() == 2 then
		Game:AddObjective("Freeze and defend \nboth robots", OBJ_FAILED, REWARD_REP, 2)
		Game:AddObjective("Freeze and defend the remaining robot", OBJ_FAILED, REWARD_REP, 1)
	elseif self:CountDead() == 1 then
		Game:AddObjective("Freeze and defend \nboth robots", OBJ_FAILED, REWARD_REP, 2)
		local status = self:CountFrozen() == 1 and OBJ_COMPLETE or OBJ_STANDARD
		Game:AddObjective("Freeze and defend the remaining robot", status, REWARD_REP, 1)
	else
		local status = self:CountFrozen() == 2 and OBJ_COMPLETE or OBJ_STANDARD
		Game:AddObjective("Freeze and defend \nboth robots", status, REWARD_REP, 2)
	end
end
