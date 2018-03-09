
Mission_Critical = Mission_Infinite:new{
	Criticals = nil,
	Image = "str_solar1",
	FlavorName = "Solar Farms",
	FlavorSingle = "Solar Farm",
	Objectives = PowerObjective("Defend both Solar Farms", 2),
	Reward = REWARD_POWER,
}

Mission_Solar = Mission_Critical:new{

}

Mission_Wind = Mission_Critical:new{
	Image = "str_wind1",
	FlavorName = "Wind Farms",
	FlavorSingle = "Wind Farm",
	Objectives = PowerObjective("Defend both Wind Farms", 2)
}

Mission_Power = Mission_Critical:new
{
	Image = "str_power1",
	FlavorName = "Power Plants",
	FlavorSingle = "Power Plant",
	Objectives = PowerObjective("Defend both Power Plants", 2)
}

function Mission_Critical:GetDamagedCount()
	local ret = 0
	if Board:IsDamaged(self.Criticals[1]) then ret = ret + 1 end
	if Board:IsDamaged(self.Criticals[2]) then ret = ret + 1 end
	return ret
end

function Mission_Critical:UpdateDescriptions()
	for i = 1, 2 do
		local tense = Board:IsDamaged(self.Criticals[i]) and "was" or "is"
		local name = self.FlavorSingle
		TILE_TOOLTIPS[name] = {name,"Your bonus objective "..tense.." to defend this structure."}
		Board:MarkSpaceDesc(self.Criticals[i],name)
	end
end

function Mission_Critical:UpdateMission()
	self:UpdateDescriptions()
end

function Mission_Critical:StartMission()
	self.Criticals = {Board:AddUniqueBuilding(self.Image),Board:AddUniqueBuilding(self.Image)}
end

function Mission_Critical:GetCompletedObjectives()
	if self:GetDamagedCount() == 0 then
		return self.Objectives
	elseif self:GetDamagedCount() == 1 then 
		return PowerObjective(self.Objectives.text.." (1 damaged)", 1, 2)
	else
		return self.Objectives:Failed()
	end
end

function Mission_Critical:UpdateObjectives()
--	Game:AddObjective("Defeat All Enemies", OBJ_STANDARD)
	local status = OBJ_STANDARD
	if self:GetDamagedCount() == 2 then status = OBJ_FAILED end
	Game:AddObjective("Defend the "..self.FlavorName.." \n("..(2-self:GetDamagedCount()).."/2 undamaged)", status, self.Reward, 2)
end