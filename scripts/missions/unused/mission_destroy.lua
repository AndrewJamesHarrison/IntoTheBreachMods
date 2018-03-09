

Mission_Destroy = Mission_Infinite:new{
	Name = "Critical Destruction",
	Criticals = nil
}

function Mission_Destroy:GetDestroyedCount()
	local ret = 0
	if Board:GetTerrain(self.Criticals[1]) == TERRAIN_RUBBLE then ret = ret + 1 end
	if Board:GetTerrain(self.Criticals[2]) == TERRAIN_RUBBLE then ret = ret + 1 end
	return ret
end

function Mission_Destroy:StartMission()
	self.Criticals = {Board:AddUniqueBuilding("critical"),Board:AddUniqueBuilding("critical")}
end

function Mission_Destroy:UpdateObjectives()
	Game:AddObjective("Destroy Critical Buildings: "..(2-self:GetDestroyedCount()).."/2")
end
