
Mission_Reactivation = Mission:new{ 
	UseBonus = true,
	SpawnStart = 0,
	SpawnStart_Easy = 0,--going to manually spawn robots
	BotsCount = 3,
	VekCount = 4,
	Enemies = nil
}

function Mission_Reactivation:StartMission()

	local choices = {}
	self.Enemies = {}
	
	for i = 3, 7 do
		for j = 0, 7 do
			if 	not Board:IsBlocked(Point(i,j),PATH_GROUND) then
				choices[#choices+1] = Point(i,j)
			end
		end
	end	
	
	for i = 1, self.BotsCount + self.VekCount do	
		if #choices == 0 then 
			return 
			end
		
		local pawn = nil
		
		if i > self.BotsCount then
			pawn = self:NextPawn()
		else
			pawn = self:NextRobot()
		end
			
		local choice = random_removal(choices)
		self.Enemies[i] = pawn:GetId()
		Board:AddPawn(pawn,choice)
		pawn:SetFrozen(true)
	end
end

function Mission_Reactivation:NextTurn()
	if Game:GetTeamTurn() == TEAM_ENEMY then
		local count = 0
		local thawed = false
		while count < 2 and #self.Enemies > 0 do
			local pawn = random_removal(self.Enemies)
			if Board:IsPawnAlive(pawn) and Board:GetPawn(pawn):IsFrozen() then
				count = count + 1
				Board:GetPawn(pawn):SetFrozen(false)
				thawed = true
			end
		end
		
		if thawed and Game:GetTeamTurn() > 1 then
			PrepareVoiceEvent("Mission_Reactivation_Thawed",-1,-1)
		end
	end
end

