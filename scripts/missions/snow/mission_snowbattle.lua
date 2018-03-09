
Mission_SnowBattle = Mission_Auto:new{
	RobotStart = 2,
	SpawnStartMod = -2,
	UseBonus = true
}

function Mission_SnowBattle:StartMission()
	for i = 1, self.RobotStart do
		Board:AddPawn(self:NextRobot())
	end
	
	local frozen = self:NextRobot()
	frozen:SetFrozen(true)
	Board:AddPawn(frozen)
end