
Mission_FreezeBldg = Mission_Infinite:new{
	Objectives = Objective("Break 5 buildings out of the ice", 1),
	MapVetoes = { "any10" },
	Buildings = nil,
	BlockEasy = true
}

function Mission_FreezeBldg:StartMission()
	self.Buildings = extract_table(Board:GetBuildings())
	for i,v in ipairs(self.Buildings) do
		Board:SetFrozen(v,true)
	end
end

function Mission_FreezeBldg:GetCompletedObjectives()
	if self:CountThawed() >= 5 then
		return self.Objectives
	else
		return self.Objectives:Failed()
	end
end

function Mission_FreezeBldg:CountThawed()
	local count = 0
	for i,v in ipairs(self.Buildings) do
		if not Board:IsFrozen(v) then
			count = count + 1
		end
	end
	return count
end

function Mission_FreezeBldg:UpdateObjectives()
	local count = math.max(0,5 - self:CountThawed())
	local status1 = count  == 0 and OBJ_COMPLETE or OBJ_STANDARD
	local buildings = count == 1 and "building" or "buildings"
	local base = "Break 5 buildings out of the ice \n(Current: "
	if IsLargeFont() then
		base = "Break 5 buildings out\nof the ice (Current: "
	end
	Game:AddObjective(base..self:CountThawed()..")", status1)
end