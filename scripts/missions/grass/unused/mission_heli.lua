
Mission_Heli = Mission_Infinite:new
{ 
	Objectives = Objective("Defend the helicopters",2),
	MapTags = {"heli"},
	Helicopters = {},
	Saved = 0,
	Dead = 0
}

function Mission_Heli:StartMission()
	self.Helicopters = {}
	Saved = 0
	self:AddHelicopter()
end

function Mission_Heli:UpdateObjectives()
	local status = self.Dead >= 3 and OBJ_FAILED or OBJ_STANDARD
    Game:AddObjective("Defend the helicopters \n("..self.Dead.." destroyed)",status)
end

function Mission_Heli:GetCompletedObjectives()
	if self.Dead == 0 then
		return self.Objectives
	elseif self.Dead < 3 then
		return Objective("Defend the helicopters ("..self.Dead.." destroyed)",1,2)
	else
		return self.Objectives:Failed()
	end
end

function Mission_Heli:UpdateMission()
	for i = #self.Helicopters, 1, -1 do
		local heli = self.Helicopters[i]
		if not Board:IsPawnAlive(heli) then -- remove dead helicopters
			table.remove(self.Helicopters,i)
			self.Dead = self.Dead + 1
		elseif Game:GetTeamTurn() == TEAM_PLAYER then
			if Board:GetPawnSpace(heli).y == 0 then -- remove helicopters who get to the edge
				Board:RemovePawn(Board:GetPawn(heli))
				table.remove(self.Helicopters,i)
			end
		end
	end
end

function Mission_Heli:NextTurn()
	if Game:GetTeamTurn() == TEAM_ENEMY and (Game:GetTurnCount() == 1 or Game:GetTurnCount() == 2) then
		self:AddHelicopter()
	end
end

function Mission_Heli:AddHelicopter()
	
	local choices = {}
	for i = 2, 5 do
		if not Board:IsBlocked(Point(i,7),PATH_GROUND) then
			choices[#choices+1] = Point(i,7)
		end
	end
	
	if #choices == 0 then
		return false
	end
	
	local heli = PAWN_FACTORY:CreatePawn("Pawn_Mission_Heli")
	self.Helicopters[#self.Helicopters + 1] = heli:GetId()
	Board:AddPawn(heli,random_element(choices))
	
	return true
end

Pawn_Mission_Heli = 
{
	Name = "Helicopter",
	Health = 1,
	Neutral = true,
	Image = "HeliSupport1",
	MoveSpeed = 3,
	SkillList = { },
	DefaultTeam = TEAM_PLAYER,
	IgnoreSmoke = true,
	Flying = true,
	Corporate = true
}
	
AddPawn("Pawn_Mission_Heli") 

function Pawn_Mission_Heli:GetPositionScore(p)
	return 10 - p.y --always move to the edge
end

