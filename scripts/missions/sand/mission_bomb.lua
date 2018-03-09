
Mission_Bomb = Mission_Infinite:new{
	Count = 2,
	MapTags = {"satellite"},
	Objectives = Objective("Defend the Prototype Renfield Bombs",2),
	Bombs = nil,
	UseBonus = false,
}

function Mission_Bomb:StartMission()
	self.Bombs = self:AddDefended("ProtoBomb")
end

function Mission_Bomb:GetCompletedObjectives()
	if self:CountBombs() == 1 then
		return Objective("Defend Prototype Renfield Bombs (One Lost)",1,2)
	elseif self:CountBombs() == 2 then
		return self.Objectives
	else
		return self.Objectives:Failed()
	end
end

function Mission_Bomb:CountBombs()
	local count = 0
	if Board:IsPawnAlive(self.Bombs[1]) then count = count + 1 end
	if Board:IsPawnAlive(self.Bombs[2]) then count = count + 1 end
	return count
end

function Mission_Bomb:UpdateObjectives()
	local status = OBJ_STANDARD
	if self:CountBombs() == 0 then status = OBJ_FAILED end
	Game:AddObjective("Defend the Bombs\n("..self:CountBombs().."/2 undamaged)", status, REWARD_REP, 2)
end

ProtoBomb = Pawn:new{
	Name = "Prototype Bomb",
	Health = 1,
	Neutral = true,
	Corpse = false,
	IgnoreFire = true,
	MoveSpeed = 0,
	Image = "bomb1",
	DefaultTeam = TEAM_PLAYER,
	IsPortrait = false,
	Explodes = true,
}
