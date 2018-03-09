
Mission_Reclaim = Mission_Infinite:new
{
	Name = "Reclaim",
	Objective = "Reclaim this district region"
	SpawnsPerTurn = 2,
	SpawnStart = 0,
	Retake1 = Point(-1,-1),
	Retake2 = Point(-1,-1),
	GoalCount = 0
}
	
function Mission_Reclaim:StartMission()
	local board_size = Board:GetSize()
	local count = 0
	for i = board_size.x - 1, 0,-1 do
		for j = 0, board_size.y - 1  do
			if Board:IsBuilding(Point(i,j)) then
				Board:SetPopulated(false,Point(i,j))
			end
		end
	end
	
	self.GoalCount = math.ceil(Board:GetBuildingCount(UNPOPULATED)/2)
end

function Mission_Reclaim:UpdateObjectives()
	Game:AddObjective("Ensure "..self.GoalCount.." powered buildings survive undamaged")
	Game:AddNote("Two buildings will re-power automatically every turn")
end	

function Mission_Reclaim:NextTurn()
	if Game:GetTeamTurn() == TEAM_PLAYER then return end
	
	if Board:IsValid(self.Retake1) then 
		Board:SetPopulated(true, self.Retake1)
	end
	if Board:IsValid(self.Retake2) then 
		Board:SetPopulated(true, self.Retake2)
	end
	
	self.Retake1 = Board:GetRandomBuilding(false)
	if Board:GetBuildingCount(UNPOPULATED) > 1 then
		repeat 
			self.Retake2 = Board:GetRandomBuilding(false)
		until (self.Retake2 ~= self.Retake1)
	else
	    self.Retake2 = Point(-1,-1)
	end
end

function Mission_Reclaim:UpdateMission()
	Board:MarkFlashing(self.Retake1, true)
	Board:MarkFlashing(self.Retake2, true)
end
