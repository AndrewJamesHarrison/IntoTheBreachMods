
Mission_Force = Mission_Infinite:new{ 
	Name = "Display of Force",
	MapTags = { "mountain" },
	Objectives = { Objective("Destroy 2 mountains",1) },
	--SpawnMod = 1,
	Enemies = 0,
	Mountains = 0,
	MountainsGoal = 2,
	UseBonus = false,
}

function Mission_Force:PrepBonus()
	self.BonusObjs = {}
	self.BonusObjs[1] = BONUS_KILL_FIVE
end

--used for briefing messages
function Mission_Force:GetCompletedStatus()
	if self.Mountains < self.MountainsGoal and self:GetBonusStatus(BONUS_KILL_FIVE, true) ~= OBJ_COMPLETE then 
		return "Failure"
	elseif self.Mountains < self.MountainsGoal then
		return "MountainsAlive"
	--elseif self.Enemies < self.EnemiesGoal then
	--	return "VekAlive"
	else
		return "Success"
	end
end

function Mission_Force:NextTurn()
	if Game:GetTeamTurn() == TEAM_PLAYER and Game:GetTurnCount() == 3 and self.Mountains < self.MountainsGoal then
		PrepareVoiceEvent("Mission_Force_Reminder")
	end
end

function Mission_Force:StartMission()
	local mountains = self:GetTerrainList(TERRAIN_MOUNTAIN)
	
	for i = 1, 3 do
		if #mountains == 0 then
			break
		end
		
		Board:DamageSpace(random_removal(mountains),1)
	end
end

function Mission_Force:IsEndBlocked()
	return self.Mountains < self.MountainsGoal
end

function Mission_Force:UpdateMission()
	self.Mountains = self.Mountains + Game:GetEventCount(EVENT_MOUNTAIN_DESTROYED)
end

function Mission_Force:GetCompletedObjectives()
	local ret = {}
	ret[1] = self.Objectives[1]
	--ret[2] = self.Objectives[2]
	
	if self.Mountains < self.MountainsGoal then 
		ret[1] = ret[1]:Failed()
	end
	
	--if self.Enemies < self.EnemiesGoal then
	--	ret[1] = ret[1]:Failed()
	--end
	
	return ret
end

function Mission_Force:UpdateObjectives()
	local mountainStatus = (self.Mountains >= self.MountainsGoal) and OBJ_COMPLETE or OBJ_STANDARD
--	local enemyStatus = (self.Enemies >= self.EnemiesGoal) and OBJ_COMPLETE or OBJ_STANDARD
	--Game:AddObjective("Kill "..math.max(0,(self.EnemiesGoal - self.Enemies)).." Enemies", enemyStatus)
	Game:AddObjective("Destroy 2 mountains \n(Current: "..self.Mountains..")", mountainStatus)
end
