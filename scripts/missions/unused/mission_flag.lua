
---"InfiniteSpawn" tells the base victory code to not count killing all enemies as a win
Mission_Flag = Mission_Infinite:new{ 

	Name = "Supply Run", 
	Objective = "Retrieve the Supplies",
	Loss = "",
	Asset = "Str_Supply",
	Carrier = -1, 
	FlagSpace = Point(0,0),
	ReturnSpace = Point(0,0),
	MapTags = { "ctf" }
}

function Mission_Flag:IsFlagCarrierDead()
	return self.Carrier ~= -1 and not Board:IsPawnAlive(self.Carrier)
end

function Mission_Flag:StartMission()
	self.ReturnSpace = Board:GetZone("return"):index(1)
	self.FlagSpace = Board:GetZone("flag"):index(1)
end

function Mission_Flag:NextTurn()	
end

function Mission_Flag:UpdateMission()
	if self.Carrier ~= -1 then 
		if Board:IsPawnAlive(self.Carrier) then
			Board:MarkSpaceColor(self.ReturnSpace,COLOR_YELLOW) 
		else
			self.InfiniteSpawn = false
		end
		
		return
	else
		Board:MarkSpaceColor(self.FlagSpace,COLOR_YELLOW)
	end
	
	local flagPawn = Board:GetPawn(self.FlagSpace)
	
	if not flagPawn then return end
	
	if flagPawn:IsMech() and not flagPawn:IsBusy() and self.Carrier == -1 then
		self.Carrier = flagPawn:GetId()
	end
end

--Event_FlagRetrieved = { Text = "I've retrieved the tech from the ruins, heading home!"}

function Mission_Flag:UpdateObjectives()
	local status = self.Carrier == -1 and OBJ_STANDARD or OBJ_COMPLETE
	Game:AddObjective("Collect the supplies with one of your mechs", status)
	
	if self:IsFlagCarrierDead() then
		Game:AddObjective("Return to the marked space", OBJ_FAILED)
		Game:AddObjective("Destroy remaining enemies")
	elseif status == OBJ_COMPLETE then
		Game:AddObjective("Return to the marked space")
	end
end
