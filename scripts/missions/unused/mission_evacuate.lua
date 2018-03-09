

Mission_Evacuate = Mission_Infinite:new{ 
		Name = "Evacuation",
		Evac1 = Point(-1,-1),
		Evac2 = Point(-1,-1),
		TotalEvac = 0,
		PowerStart = 0,
		UseBonus = true,
		Environment = "Env_Evacuation"
	}
	
Env_Evacuation = Environment:new{
	Image = "env_evacuation",
	Name = "Evacuation",
	Text = "Two buildings will evacuate at the end of every enemy turn. \n\nEvacuated buildings will not effect the Power Grid when damaged",
	StratText = "EVACUATION"
}
	
function Mission_Evacuate:StartMission()
	self.TotalEvac = Board:GetBuildingCount(POPULATED)
	self.TurnLimit = math.ceil(self.TotalEvac/2)
end


function Mission_Evacuate:NextTurn()
	if Game:GetTeamTurn() == TEAM_PLAYER then return end
	
	if Board:IsValid(self.Evac1) then 
		Board:SetPopulated(false, self.Evac1)
	end
	if Board:IsValid(self.Evac2) then 
		Board:SetPopulated(false, self.Evac2)
	end
	
	self.Evac1 = Board:GetRandomBuilding(true)
	if Board:GetBuildingCount(POPULATED) > 1 then
		repeat 
			self.Evac2 = Board:GetRandomBuilding(true)
		until (self.Evac2 ~= self.Evac1)
	else
	    self.Evac2 = Point(-1,-1)
	end

end

function Mission_Evacuate:UpdateMission()
	Board:MarkFlashing(self.Evac1, true)
	Board:MarkFlashing(self.Evac2, true)
	
	Board:MarkSpaceDesc(self.Evac1,"evacuation")
	Board:MarkSpaceDesc(self.Evac2,"evacuation")
end
