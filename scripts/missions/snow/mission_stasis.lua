
Mission_Stasis = Mission_Infinite:new{
	Count = 2,
	Bots = nil,
	SpawnMod = -1,
	UseBonus = true,
}

function Mission_Stasis:StartMission()
	local choices = {}
	self.Bots = {}
	
	for i = 3, 6 do
		for j = 1, 6 do
			if 	not Board:IsBlocked(Point(i,j),PATH_GROUND) then
				choices[#choices+1] = Point(i,j)
			end
		end
	end
	
	if #choices < 2 then
		LOG("Didn't find locations for stasis bots")
		return
	end
	
	local levels = {"1", "2"}
	if GetSector() > 2 then
		levels = {"2", "2"}
	end
	
	for i = 1, 2 do
		local pawn = PAWN_FACTORY:CreatePawn(random_element({ "Snowtank", "Snowlaser", "Snowart" })..levels[i])
		local choice = random_removal(choices)
		self.Bots[i] = pawn:GetId()
		Board:AddPawn(pawn,choice)
		--pawn:SetPowered(false)
		pawn:SetFrozen(true)
		pawn:SetMissionCritical(true)
	end
	
end

function Mission_Stasis:UpdateMission()

end